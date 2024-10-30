import 'package:hive/hive.dart';
part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String uri;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final String source;
  @HiveField(4)
  final List<String> ingredientLines;
  @HiveField(5)
  DateTime? visitedDate;
  Recipe(
      {required this.uri,
      required this.label,
      required this.image,
      required this.source,
      required this.ingredientLines,
      this.visitedDate});
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      uri: json['uri'],
      label: json['label'],
      image: json['image'],
      source: json['source'],
      ingredientLines: List<String>.from(json['ingredientLines']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      'label': label,
      'image': image,
      'source': source,
      'ingredientLines ': ingredientLines
    };
  }
}
