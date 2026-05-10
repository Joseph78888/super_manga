// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manga _$MangaFromJson(Map<String, dynamic> json) => Manga(
  id: json['id'] as String,
  titleAr: json['title_ar'] as String,
  titleEn: json['title_en'] as String,
  description: json['description'] as String?,
  coverUrl: json['cover_url'] as String,
  status: json['status'] as String,
  rating: (json['rating'] as num?)?.toDouble(),
  author: json['author'] as String?,
  artist: json['artist'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  type: json['type'] as String?,
  genres: Manga._genresFromJson(json['manga_genres']),
);

Map<String, dynamic> _$MangaToJson(Manga instance) => <String, dynamic>{
  'id': instance.id,
  'title_ar': instance.titleAr,
  'title_en': instance.titleEn,
  'description': instance.description,
  'cover_url': instance.coverUrl,
  'status': instance.status,
  'rating': instance.rating,
  'author': instance.author,
  'artist': instance.artist,
  'created_at': instance.createdAt?.toIso8601String(),
  'type': instance.type,
  'manga_genres': instance.genres,
};
