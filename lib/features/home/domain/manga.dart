import 'package:json_annotation/json_annotation.dart';

part 'manga.g.dart';

/// Represents a Manga entity in the domain layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class Manga {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? description;
  final List<String> genres;
  final String status;
  final double? rating;

  const Manga({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.description,
    this.genres = const [],
    required this.status,
    this.rating,
  });

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
