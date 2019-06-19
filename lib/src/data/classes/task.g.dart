// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
      id: json['id'] as int,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      status: json['status'] as String,
      subtasks: (json['subtasks'] as List)
          ?.map((e) =>
              e == null ? null : SubTask.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'title': instance.title,
      'subtitle': instance.subtitle,
      'status': instance.status,
      'subtasks': instance.subtasks?.map((e) => e?.toJson())?.toList()
    };
