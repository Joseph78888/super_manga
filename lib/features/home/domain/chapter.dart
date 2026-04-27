import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';

/// Represents a chapter record from the `chapter` Supabase table.
@JsonSerializable(fieldRename: FieldRename.snake)
class Chapter {
  final String id;
  final String mangaId;
  final int chapterNumber;
  final String? chapterName;
  final DateTime? createdAt;

  const Chapter({
    required this.id,
    required this.mangaId,
    required this.chapterNumber,
    this.chapterName,
    this.createdAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
