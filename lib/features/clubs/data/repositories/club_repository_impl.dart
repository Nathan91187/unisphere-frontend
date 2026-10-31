import 'package:uni_sphere/features/clubs/data/datasources/club_remote_data_source.dart';
import 'package:uni_sphere/features/clubs/data/models/club_membership_model.dart';
import 'package:uni_sphere/features/clubs/data/models/create_club_request.dart';
import 'package:uni_sphere/features/clubs/data/models/update_club_request.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_membership.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';

class ClubRepositoryImpl implements ClubRepository{
  final ClubRemoteDataSource remoteDataSource;
  const ClubRepositoryImpl({
    required this.remoteDataSource
});
  @override
  Future<List<Club>> getAllClubs() async{
    final clubModels = await remoteDataSource.getAllClubs();
    return clubModels.map((clubModel) => clubModel.toEntity()).toList();
  }
  @override
  Future<Club> createClub({
    required String name,
    required String description,
    String? imageUrl,
    required ClubCategory category}) async{
    final request = CreateClubRequest(
        name: name,
        description: description,
        category: category,
        imageUrl: imageUrl
    );
    final club = await remoteDataSource.createClub(request);
    return club.toEntity();
  }

  @override
  Future<void> deleteClub({required int clubId}) async{
    await remoteDataSource.deleteClub(clubId);
  }

  @override
  Future<Club> getClubById({required int clubId}) async{
    final club = await remoteDataSource.getClubById(clubId);
    return club.toEntity();
  }

  @override
  Future<Club> updateClub({
    required int clubId,
    required String name,
    required String description,
    String? imageUrl,
    required ClubCategory category}) async{
   final request = UpdateClubRequest(
       name: name,
       description: description,
       category: category,
       imageUrl: imageUrl
   );
   final club = await remoteDataSource.updateClub(clubId, request);
   return club.toEntity();
  }

  @override
  Future<ClubMembership> getMyMembership({required int clubId}) async{
    final membership = await remoteDataSource.getMyMembership(clubId);
    return membership.toEntity();
  }

  @override
  Future<void> leaveClub({required int clubId}) async{
    await remoteDataSource.leaveClub(clubId);
  }

  @override
  Future<ClubMembership> joinClub({required int clubId})async{
    final membership = await remoteDataSource.joinClub(clubId);
    return membership.toEntity();
  }

  @override
  Future<bool> checkLeaveEligibility({required int clubId}) async{
    return await remoteDataSource.checkLeaveEligibility(clubId);
  }
}