// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaPage _$MangaPageFromJson(Map<String, dynamic> json) => MangaPage(
  id: json['id'] as String,
  chapterId: json['chapter_id'] as String,
  pageNumber: (json['page_number'] as num).toInt(),
  imageUrl: json['image_url'] as String,
);

Map<String, dynamic> _$MangaPageToJson(MangaPage instance) => <String, dynamic>{
  'id': instance.id,
  'chapter_id': instance.chapterId,
  'page_number': instance.pageNumber,
  'image_url': instance.imageUrl,
};
