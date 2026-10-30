import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';

class UpdateClubRequest {
  final String name;
  final String description;
  final String? imageUrl;
  final ClubCategory category;

  const UpdateClubRequest({
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.name.toUpperCase(),
    };
  }
}