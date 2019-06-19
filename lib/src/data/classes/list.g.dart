// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskList _$TaskListFromJson(Map<String, dynamic> json) {
  return TaskList(
      id: json['id'] as String,
      name: json['name'] as String,
      tasks: (json['tasks'] as List)
          ?.map((e) =>
              e == null ? null : Task.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      active: json['active'] as bool);
}

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
      'name': instance.name,
      'tasks': instance.tasks?.map((e) => e?.toJson())?.toList(),
      'active': instance.active,
      'id': instance.id
    };
