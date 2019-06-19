import 'package:firebase/firestore.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart' as fb;

import '../../ui/common/bottom_sheet/more.dart';
import '../classes/list.dart';
import '../classes/task.dart';

class TaskState extends ChangeNotifier {
  TaskState(this.userID);

  final String defaultListName = "My Tasks";
  final String userID;

  List<TaskList> _lists = [];
  SortBy _sort = SortBy.custom;

  TaskList get activeList => _lists == null || _lists.isEmpty
      ? null
      : _lists?.firstWhere((t) => t.active);

  List<Task> get pendingTaskList =>
      (activeList?.tasks ?? []).where((t) => t.status == 'PENDING').toList();

  List<Task> get completedTaskList =>
      (activeList?.tasks ?? []).where((t) => t.status == 'COMPLETED').toList();

  List<String> get tblNames => _lists?.map((n) => n.name)?.toList();

  TaskList getListByName(String value) =>
      _lists[_lists.map((t) => t.name).toList().indexOf(value)];

  void init() async {
    await _loadListsCloud();
    if (_lists == null || _lists.isEmpty) {
      final _list = TaskList(
          id: 'default', name: defaultListName, tasks: [], active: true);
      _lists.add(_list);
      _saveListsCloud();
    }
  }

  CollectionReference get listRef =>
      fb.firestore().collection('users').doc(userID).collection('lists');

  Future _loadListsCloud() async {
    final ref = listRef;
    final _data = await ref.get();
    if (_data != null) {
      for (var doc in _data.docs) {
        final _meta = doc.data();
        final _item = TaskList.fromJson(_meta);
        _lists.add(_item);
      }
    }
    notifyListeners();
  }

  void refreshTasks() {
    _loadListsCloud();
  }

  void _saveListCloud(String id) async {
    final ref = listRef.doc(id);
    ref.set(activeList.toJson());
    notifyListeners();
  }

  void _saveListsCloud() async {
    final ref = listRef;

    for (var list in _lists) {
      final _doc = await ref.doc(list.id);
      _doc.set(list.toJson());
    }

    notifyListeners();
  }

  SortBy get sort => _sort;

  String get listName => activeList == null ? defaultListName : activeList.name;

  void changeList(String value) {
    final _list = getListByName(value);
    activeList.active = false;
    _list.active = true;
    notifyListeners();
    _saveListsCloud();
  }

  void addList(String name) {
    final ref = listRef.doc();
    var _list = TaskList(id: ref.id, name: name, tasks: [], active: true);
    activeList.active = false;
    _lists.add(_list);
    notifyListeners();
    _saveListsCloud();
  }

  void updateListName(String name) {
    activeList.name = name;
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  void removeList(String name) {
    _lists.removeWhere((t) => t.name == name);
    notifyListeners();
    _saveListsCloud();
  }

  void clearLists() {
    _lists.clear();
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  void addTask(Task task) {
    print("Adding Task: " + task?.title + " for: $listName");
    if (task != null) activeList.tasks.add(task);
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  void removeTask(Task task) {
    if (task != null) activeList.tasks.remove(task);
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  List<Task> getTasksByStatus(String status) {
    List<Task> _list = [];
    for (var _task in activeList.tasks) {
      if (_task.status
          .toUpperCase()
          .trim()
          .contains(status.toUpperCase().trim())) {
        _list.add(_task);
        notifyListeners();
      }
    }
    return _list;
  }

  void clearTasks(String listName) {
    activeList.tasks.clear();
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  Task getTask(int id) {
    final _list = getListByName(listName);
    return _list.tasks.firstWhere((t) => t.id == id);
  }

  void updateTask(int id, Task task) {
    var _list = getListByName(listName);
    final _taskItem = _list.tasks.firstWhere((t) => t.id == id);
    _list.tasks[_list.tasks.indexOf(_taskItem)] = task;
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  void clearCompletedTasks(String listName) {
    var _list = getListByName(listName);
    _list.tasks.removeWhere((t) => t.status == "COMPLETED");
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  void onNewTaskSave(Task task) {
    if (task != null) {
      var _newTask = task;
      _newTask.status = "PENDING";
      addTask(_newTask);
      print("Task saved!");
      print("${task.title}");
    } else {
      print("Empty field!");
    }
    notifyListeners();
  }

  void sortChanged(SortBy value) {
    _sort = value;
    sortList(value);
    notifyListeners();
  }

  void deleteList() {
    removeList(listName);
    final _list = _lists.first;
    _list.active = true;
    _saveListsCloud();
    notifyListeners();
  }

  void renameList(String value) {
    final _list = activeList;
    _list.name = value;
    notifyListeners();
    _saveListCloud(activeList.id);
  }

  void sortList(SortBy sort) {
    pendingTaskList.sort((Task a, Task b) {
      if (sort == SortBy.date) {
        return a.date.millisecondsSinceEpoch
            .compareTo(b.date.millisecondsSinceEpoch);
      }
      return a.title.compareTo(b.title);
    });
    completedTaskList.sort((Task a, Task b) {
      if (sort == SortBy.date) {
        return a.date.millisecondsSinceEpoch
            .compareTo(b.date.millisecondsSinceEpoch);
      }
      return a.title.compareTo(b.title);
    });
    notifyListeners();
  }

  void updateTaskStatus(Task task, {bool undo = false}) {
    var _task = task;
    if (undo) {
      _task.status = "PENDING";
      completedTaskList.remove(task);
      pendingTaskList.add(task);
    } else {
      _task.status = "COMPLETED";
      pendingTaskList.remove(task);
      completedTaskList.add(task);
    }
    updateTask(task.id, _task);
    print('Update Task');
    _saveListCloud(activeList.id);
    notifyListeners();
  }
}

enum StorageProvider { sqlLite, memory, firebase }

StorageProvider storage = StorageProvider.memory;

enum DetailsWidgetStatus { OPEN, CLOSE }
