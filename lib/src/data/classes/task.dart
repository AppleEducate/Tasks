import 'package:flutter_web/material.dart';

import 'index.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true)
class Task {
  final int id;
  DateTime date;
  String title, subtitle, status;
  List<SubTask> subtasks;

  Task({
    @required this.id,
    this.date,
    this.title,
    this.subtitle,
    this.status,
    this.subtasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
