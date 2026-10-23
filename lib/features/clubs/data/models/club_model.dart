import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';

class ClubModel {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final int memberCount;
  final ClubCategory category;
  const ClubModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.memberCount,
    required this.category,
});
  factory ClubModel.fromJson(Map<String,dynamic> json){
    return ClubModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        memberCount: json['memberCount'],
        category: ClubCategory.values.byName(json['category'].toString().toLowerCase()));
  }
}
