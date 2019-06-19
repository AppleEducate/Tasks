import 'package:after_layout/after_layout.dart';
import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import '../../data/classes/index.dart';
import '../../data/models/index.dart';
import '../common/app_bar/main_list.dart';
import '../common/bottom_sheet/index.dart';
import '../common/index.dart';
import '../common/lists/completed.dart';
import '../common/lists/pending.dart';
import 'index.dart';

class TasksHomePage extends StatefulWidget {
  @override
  _TasksHomePageState createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage>
    with TickerProviderStateMixin, AfterLayoutMixin<TasksHomePage> {
  AnimationController detailsTapAnimationController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showCompleted = false;

  final _duration = Duration(milliseconds: 300);

  @override
  void dispose() {
    super.dispose();
    detailsTapAnimationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    detailsTapAnimationController =
        AnimationController(duration: _duration, vsync: this);
  }

  Widget buildPendingList(BuildContext context) {
    return Consumer<TaskState>(
      builder: (context, tasks, child) {
        if (tasks.pendingTaskList == null || tasks.pendingTaskList.isEmpty) {
          return SliverFillRemaining(
              child: ImageWidget(
            image: "images/new_list.png",
            title: 'A fresh start',
            subtitle: 'Anything to Add?',
          ));
        }
        showCompleted = false;
        return PendingList(
          items: tasks.pendingTaskList,
          dismissedTask: (Task task) {
            tasks.updateTaskStatus(task);
            showInSnackBar(context, "1 completed", task: task);
          },
          listRefresh: () {
            tasks..refreshTasks();
          },
          listName: tasks.listName,
        );
      },
    );
  }

  Widget buildCompletedImage(BuildContext context) {
    if (showCompleted) {
      return SliverFillRemaining(
          child: ImageWidget(
        image: "images/completed.png",
        title: 'Nicely Done!',
        subtitle: "You've finished all your tasks.\nTake a second to recharge.",
      ));
    }

    return Consumer<TaskState>(
      builder: (context, tasks, child) => CompletedList(
            items: tasks.completedTaskList,
            listName: tasks.listName,
            listRefresh: () {
              tasks.refreshTasks();
            },
            restoreTask: (Task task) {
              tasks.updateTaskStatus(task, undo: true);
            },
          ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    final _state = Provider.of<TaskState>(context);
    showModalBottomSheet(
        // resizeToAvoidBottomPadding: true,
        context: context,
        builder: (builder) {
          return MenuWidget(
            listNames: _state.tblNames,
            createList: () async {
              Navigator.pop(context);
              var newListPage = await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return NewListPage();
              }));
              if (newListPage == null) {
                _state.refreshTasks();
              }
            },
            activeList: _state.listName,
            listChange: _state.changeList,
          );
        });
  }

  void _modalBottomSheetMore(BuildContext context) {
    final _state = Provider.of<TaskState>(context);
    showModalBottomSheet(
      // resizeToAvoidBottomPadding: true,
      context: context,
      builder: (builder) {
        return MoreWidget(
          sort: _state.sort,
          sortChanged: _state.sortChanged,
          completedTasksCount: _state.completedTaskList?.length,
          renameList: _state.activeList.name == _state.defaultListName
              ? null
              : () async {
                  Navigator.pop(context);
                  var renameListPage = await Navigator.push<String>(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RenameListPage(_state.activeList.name);
                  }));
                  if (renameListPage != null) {
                    _state.renameList(renameListPage);
                  }
                },
          deleteList: _state.activeList.name == _state.defaultListName
              ? null
              : () {
                  Navigator.pop(context);
                  _state.deleteList();
                },
          deleteCompletedTasks: () async {
            _state.clearCompletedTasks(_state.activeList.name);
            _state.refreshTasks();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showInSnackBar(BuildContext context, String value, {Task task}) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(value),
        FlatButton(
          child: Text(
            "Undo",
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Provider.of<TaskState>(context).updateTaskStatus(task, undo: true);
            scaffoldKey.currentState?.hideCurrentSnackBar();
          },
        )
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskState>(
      builder: (context, tasks, child) => Scaffold(
            resizeToAvoidBottomInset: true,
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton.extended(
              elevation: 4.0,
              icon: const Icon(Icons.add),
              label: const Text('Add a new task', maxLines: 1),
              onPressed: () {
                showModalCustomBottomSheet<Task>(
                    context: context,
                    builder: (BuildContext context) {
                      // return new AnimatedPadding(
                      //   padding: MediaQuery.of(context).viewInsets,
                      //   duration: const Duration(milliseconds: 100),
                      //   curve: Curves.decelerate,
                      //   child: new Container(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Wrap(
                      //       children: <Widget>[
                      //         AddTaskWidget(),
                      //       ],
                      //     ),
                      //   ),
                      // );
                      return SafeArea(child: AddTaskWidget());
                    }).then((newTask) {
                  if (newTask == null || newTask.title.isNotEmpty)
                    tasks.onNewTaskSave(newTask);
                });
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              elevation: 25.0,
              // hasNotch: false,
              // shape: CircularNotchedRectangle(),
              // notchMargin: 4.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _modalBottomSheetMenu(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _modalBottomSheetMore(context),
                  )
                ],
              ),
            ),
            body: Consumer<TaskState>(
              builder: (context, tasks, child) => Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          MainListAppBar(name: tasks.listName),
                          buildPendingList(context),
                          buildCompletedImage(context),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
    );
  }

  StateSetter setSheetState;
  @override
  void afterFirstLayout(BuildContext context) {
    detailsTapAnimationController.addListener(() {
      setSheetState(() {
        print("Animation: ${detailsTapAnimationController.value.toDouble()}");
        // _bottomSheet;
      });
    });
  }
}
