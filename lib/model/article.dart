import 'dart:js_util';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Topic {
  // ignore: prefer_final_fields, unused_field
  String _id = '';
  int createTime = 0;
  String name = '';
  String cover = '';
  int count = 0;

  Topic();
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable()
class Article {
  // ignore: prefer_final_fields, unused_field
  String _id = "";
  int createTime = 0;
  DateTime createTimeObj = DateTime.now();
  int updateTime = 0;
  String title = "";
  List<Topic> topics = [];
  String type = 'moment'; //"article" | "moment" | "photo"
  String cover = '';
  String htmlContent = '';
  String textContent = '';
  String desc = '';
  Location location = Location();
  List<String> imgs = [];
  Map<String, dynamic> weather = {};
  Movie movie = Movie();

  Article();
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class Movie {
  String cover = '';
  String link = '';
  String title = '';
  String rate = '';
  String meta = '';

  Movie();
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class Location {
  String id = '';
  String name = '';
  String address = '';
  LngLat location = LngLat();
  String type = '';

  Location();
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class LngLat {
  double lat = 0.0;
  double lng = 0.0;

  LngLat();
  factory LngLat.fromJson(Map<String, dynamic> json) => _$LngLatFromJson(json);
  Map<String, dynamic> toJson() => _$LngLatToJson(this);
}

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic()
    ..createTime = json['createTime'] as int
    ..name = json['name'] as String
    ..cover = json['cover'] as String
    ..count = json['count'] ?? 0;
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'createTime': instance.createTime,
      'name': instance.name,
      'cover': instance.cover,
      'count': instance.count,
    };

Article _$ArticleFromJson(Map<String, dynamic> json) {
  var article = Article()
    ..createTime = json['createTime'] as int
    ..createTimeObj =
        DateTime.fromMillisecondsSinceEpoch(json['createTime'] as int)
    ..updateTime = json['updateTime'] as int
    ..title = json['title'] ?? ""
    ..topics = (json['topics'] as List<dynamic>)
        .map((e) => Topic.fromJson(e as Map<String, dynamic>))
        .toList()
    ..type = json['type'] as String
    ..cover = json['cover'] ?? ""
    ..htmlContent = json['htmlContent'] ?? ""
    ..textContent = json['textContent'] as String
    ..desc = json['desc'] as String
    ..imgs = (json['imgs'] as List<dynamic>).map((e) => e as String).toList()
    ..weather = json['weather'] ?? Map<String, dynamic>()
    ..movie = Movie.fromJson(json['movie'] ?? Map<String, dynamic>());
  if (json['location'] != null) {
    if (json['location'].runtimeType == String) {
      article.location = Location.fromJson({"name": json['location']});
    } else {
      article.location = Location.fromJson(json['location']);
    }
  }
  return article;
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'createTime': instance.createTime,
      'createTimeObj': instance.createTimeObj.toIso8601String(),
      'updateTime': instance.updateTime,
      'title': instance.title,
      'topics': instance.topics,
      'type': instance.type,
      'cover': instance.cover,
      'htmlContent': instance.htmlContent,
      'textContent': instance.textContent,
      'desc': instance.desc,
      'location': instance.location,
      'imgs': instance.imgs,
      'weather': instance.weather,
      'movie': instance.movie,
    };

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie()
  ..cover = json['cover'] ?? ""
  ..link = json['link'] ?? ""
  ..title = json['title'] ?? ''
  ..rate = json['rate'] ?? ''
  ..meta = json['meta'] ?? '';

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'cover': instance.cover,
      'link': instance.link,
      'title': instance.title,
      'rate': instance.rate,
      'meta': instance.meta,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location()
  ..id = json['id'] ?? ""
  ..name = json['name'] ?? ""
  ..address = json['address'] ?? ""
  ..location = LngLat.fromJson(json['location'] ?? Map<String, dynamic>())
  ..type = json['type'] ?? "";

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'location': instance.location,
      'type': instance.type,
    };

LngLat _$LngLatFromJson(Map<String, dynamic> json) => LngLat()
  ..lat = (json['lat'] ?? 0).toDouble()
  ..lng = (json['lng'] ?? 0).toDouble();

Map<String, dynamic> _$LngLatToJson(LngLat instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
