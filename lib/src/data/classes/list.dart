import 'package:flutter_web/material.dart';

import 'task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable(explicitToJson: true)
class TaskList {
  String name;
  final List<Task> tasks;
  bool active;
  final String id;

  TaskList({
    @required this.id,
    @required this.name,
    @required this.tasks,
    @required this.active,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListToJson(this);
}
