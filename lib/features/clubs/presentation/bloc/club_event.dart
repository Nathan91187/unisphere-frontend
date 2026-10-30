import '../../domain/entities/club_category.dart';

abstract class ClubEvent {
  const ClubEvent();
}
class LoadClubs extends ClubEvent{
  const LoadClubs();
}
class CreateClub extends ClubEvent{
  final String name;
  final String description;
  final String? imageUrl;
  final ClubCategory category;
  const CreateClub({
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
  });
}
class GetClubById extends ClubEvent{
  final int clubId;
  const GetClubById({required this.clubId});
}
class UpdateClub extends ClubEvent{
  final int clubId;
  final String name;
  final String description;
  final String? imageUrl;
  final ClubCategory category;
  const UpdateClub({
    required this.clubId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
  });
}
class DeleteClub extends ClubEvent{
  final int clubId;
  const DeleteClub({required this.clubId});
}