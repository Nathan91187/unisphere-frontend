import 'package:uni_sphere/features/clubs/domain/entities/club.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';

abstract class ClubRepository {
  Future<List<Club>> getAllClubs();
  Future<Club> getClubById({required int clubId});
  Future<Club> createClub({
    required String name,
    required String description,
    String? imageUrl,
    required ClubCategory category});
  Future<Club> updateClub({
    required int clubId,
    required String name,
    required String description,
    String? imageUrl,
    required ClubCategory category});
  Future<void> deleteClub({required int clubId});
}
