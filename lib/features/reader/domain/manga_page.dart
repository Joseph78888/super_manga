import 'package:json_annotation/json_annotation.dart';

part 'manga_page.g.dart';

/// Represents a page record from the `page` Supabase table.
@JsonSerializable(fieldRename: FieldRename.snake)
class MangaPage {
  final String id;
  final String chapterId;
  final int pageNumber;
  final String imageUrl;

  const MangaPage({
    required this.id,
    required this.chapterId,
    required this.pageNumber,
    required this.imageUrl,
  });

  factory MangaPage.fromJson(Map<String, dynamic> json) =>
      _$MangaPageFromJson(json);
  Map<String, dynamic> toJson() => _$MangaPageToJson(this);
}
