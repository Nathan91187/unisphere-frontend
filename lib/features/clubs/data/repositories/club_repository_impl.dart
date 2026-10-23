import 'package:uni_sphere/features/clubs/data/datasources/club_remote_data_source.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';

class ClubRepositoryImpl implements ClubRepository{
  final ClubRemoteDataSource remoteDataSource;
  const ClubRepositoryImpl({
    required this.remoteDataSource
});
  @override
  Future<List<Club>> getAllClubs() async{
    final clubModels = await remoteDataSource.getAllClubs();
    return clubModels.map((clubModel)=> Club(
        id: clubModel.id,
        name: clubModel.name,
        description: clubModel.description,
        memberCount: clubModel.memberCount,
        imageUrl: clubModel.imageUrl,
        category: clubModel.category)
    ).toList();  }

}