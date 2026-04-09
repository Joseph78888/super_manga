// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manga _$MangaFromJson(Map<String, dynamic> json) => Manga(
  id: json['id'] as String,
  title: json['title'] as String,
  thumbnailUrl: json['thumbnail_url'] as String,
  description: json['description'] as String?,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  status: json['status'] as String,
  rating: (json['rating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MangaToJson(Manga instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'thumbnail_url': instance.thumbnailUrl,
  'description': instance.description,
  'genres': instance.genres,
  'status': instance.status,
  'rating': instance.rating,
};
