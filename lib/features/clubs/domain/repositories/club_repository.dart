import 'package:uni_sphere/features/clubs/domain/entities/club.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_membership.dart';

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
  Future<ClubMembership> getMyMembership({required int clubId});
  Future<void> leaveClub({required int clubId});
  Future<ClubMembership> joinClub({required int clubId});
  Future<bool> checkLeaveEligibility({required int clubId});
}

