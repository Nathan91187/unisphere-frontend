import 'club_category.dart';

class Club {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int memberCount;
  final ClubCategory category;
  const Club({
  required this.id,
  required this.name,
  required this.description,
  this.imageUrl,
  required this.memberCount,
  required this.category,
});
  Club copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    int? memberCount,
    ClubCategory? category,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      memberCount: memberCount ?? this.memberCount,
      category: category ?? this.category,
    );
  }
}
