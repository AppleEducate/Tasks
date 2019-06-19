import 'package:flutter_web/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_task.g.dart';

@JsonSerializable(explicitToJson: true)
class SubTask {
  final int id;
  DateTime date;
  String title, subtitle, status;

  SubTask({
    @required this.id,
    this.date,
    this.title,
    this.subtitle,
    this.status,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) =>
      _$SubTaskFromJson(json);

  Map<String, dynamic> toJson() => _$SubTaskToJson(this);
}
