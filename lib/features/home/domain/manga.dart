import 'package:json_annotation/json_annotation.dart';

part 'manga.g.dart';

/// Represents a Manga entity matching the `manga` Supabase table.
@JsonSerializable(fieldRename: FieldRename.snake)
class Manga {
  final String id;
  final String titleAr;
  final String titleEn;
  final String? description;
  final String coverUrl;
  final String status;
  final double? rating;
  final String? author;
  final String? artist;
  final DateTime? createdAt;

  const Manga({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    this.description,
    required this.coverUrl,
    required this.status,
    this.rating,
    this.author,
    this.artist,
    this.createdAt,
  });

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
