import 'package:uni_sphere/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:uni_sphere/features/profile/data/models/create_profile_request.dart';
import 'package:uni_sphere/features/profile/data/models/update_profile_request.dart';
import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';
import 'package:uni_sphere/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ProfileRemoteDataSource dataSource;
  const ProfileRepositoryImpl({required this.dataSource});
  @override
  Future<ProfileUser> createProfile({required String displayName, required String username,String? profileImageUrl}) async{
    final request = CreateProfileRequest(
        username:username,
        displayName: displayName,
        profileImageUrl: profileImageUrl
    );
    final response = await dataSource.createProfile(request);
    return response.toEntity();
  }

  @override
  Future<void> deleteProfile() async{
    await dataSource.deleteProfile();
  }

  @override
  Future<ProfileUser> getProfileByUid({required String uid}) async{
    final response = await dataSource.getProfileByUid(uid);
    return response.toEntity();
  }

  @override
  Future<ProfileUser> updateProfile({required String username,required String displayName, String? profileImageUrl}) async{
    final request = UpdateProfileRequest(
        username: username,
        displayName: displayName,
        profileImageUrl: profileImageUrl
    );
    final response = await dataSource.updateProfile(request);
    return response.toEntity();
  }

  @override
  Future<List<ProfileUser>> getAllProfilesByUid({required List<String> uids}) async{
    final profiles = await dataSource.getAllProfilesByUid(uids);
    return profiles.map((profile)=>profile.toEntity()).toList();
  }

  @override
  Future<List<ProfileUser>> searchUsersByUsername({required String username}) async{
    final profiles = await dataSource.searchUsersByUsername(username);
    return profiles.map((profile)=>profile.toEntity()).toList();
  }

  @override
  Future<bool> checkUsernameAvailability({required String username}){
   return dataSource.isUsernameAvailable(username);
  }

}