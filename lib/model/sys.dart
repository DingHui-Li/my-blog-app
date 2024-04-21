import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SettingConf {
  WebsiteConf website = WebsiteConf();
  ProfileConf profile = ProfileConf();

  SettingConf();

  factory SettingConf.fromJson(Map<String, dynamic> json) =>
      _$SettingConfFromJson(json);
  Map<String, dynamic> toJson() => _$SettingConfToJson(this);
}

@JsonSerializable()
class WebsiteConf {
  String name = "";
  String cover = "";
  String about = "";
  String aboutme = "";

  WebsiteConf();

  factory WebsiteConf.fromJson(Map<String, dynamic> json) =>
      _$WebsiteConfFromJson(json);
  Map<String, dynamic> toJson() => _$WebsiteConfToJson(this);
}

@JsonSerializable()
class ProfileConf {
  String name = '';
  String avatar = "";
  DateTime brithday = DateTime.now();

  ProfileConf();

  factory ProfileConf.fromJson(Map<String, dynamic> json) =>
      _$ProfileConfFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileConfToJson(this);
}

SettingConf _$SettingConfFromJson(Map<String, dynamic> json) => SettingConf()
  ..website = WebsiteConf.fromJson(json['website'] as Map<String, dynamic>)
  ..profile = ProfileConf.fromJson(json['profile'] as Map<String, dynamic>);

Map<String, dynamic> _$SettingConfToJson(SettingConf instance) =>
    <String, dynamic>{
      'website': instance.website,
      'profile': instance.profile,
    };

WebsiteConf _$WebsiteConfFromJson(Map<String, dynamic> json) => WebsiteConf()
  ..name = json['name'] as String
  ..cover = json['cover'] as String
  ..about = json['about'] as String
  ..aboutme = json['aboutme'] as String;

Map<String, dynamic> _$WebsiteConfToJson(WebsiteConf instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cover': instance.cover,
      'about': instance.about,
      'aboutme': instance.aboutme,
    };

ProfileConf _$ProfileConfFromJson(Map<String, dynamic> json) {
  var t = ProfileConf()
    ..name = json['name'] as String
    ..avatar = json['avatar'] as String;
  if (json['brithday'] != null) {
    t.brithday = DateTime.parse(json['brithday'] as String);
  }
  return t;
}

Map<String, dynamic> _$ProfileConfToJson(ProfileConf instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar,
      'brithday': instance.brithday.toIso8601String(),
    };
