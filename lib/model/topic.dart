import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Topic {
  DateTime createTime = DateTime.now();
  String name = '';
  String cover = '';
  int count = 0;

  Topic();

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic()
  ..createTime = DateTime.parse(json['createTime'] as String)
  ..name = json['name'] as String
  ..cover = json['cover'] as String
  ..count = json['count'] ?? 0;

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'createTime': instance.createTime.toIso8601String(),
      'name': instance.name,
      'cover': instance.cover,
    };
