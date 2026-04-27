// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  id: json['id'] as String,
  mangaId: json['manga_id'] as String,
  chapterNumber: (json['chapter_number'] as num).toInt(),
  chapterName: json['chapter_name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'manga_id': instance.mangaId,
  'chapter_number': instance.chapterNumber,
  'chapter_name': instance.chapterName,
  'created_at': instance.createdAt?.toIso8601String(),
};
