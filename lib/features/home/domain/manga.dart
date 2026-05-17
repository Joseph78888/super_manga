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
  final String? type;
  @JsonKey(name: 'manga_genres', fromJson: _genresFromJson)
  final List<String>? genres;

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
    this.type,
    this.genres,
  });

  static List<String>? _genresFromJson(dynamic json) {
    if (json == null) return null;
    if (json is List) {
      final List<String> result = [];
      for (var e in json) {
        if (e is Map<String, dynamic>) {
          if (e.containsKey('name') && e['name'] != null) {
            result.add(e['name'].toString());
          } else if (e.containsKey('title') && e['title'] != null) {
            result.add(e['title'].toString());
          } else if (e.containsKey('genres') && e['genres'] != null) {
            final g = e['genres'];
            if (g is Map) {
              final name = g['name'] ?? g['title'];
              if (name != null) result.add(name.toString());
            }
          } else if (e.containsKey('genre') && e['genre'] != null) {
            final g = e['genre'];
            if (g is Map) {
              final name = g['name'] ?? g['title'];
              if (name != null) result.add(name.toString());
            }
          }
        }
      }
      return result.isEmpty ? null : result;
    }
    return null;
  }

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
