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
}
