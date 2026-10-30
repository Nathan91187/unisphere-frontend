import 'package:uni_sphere/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:uni_sphere/features/profile/data/models/create_profile_request.dart';
import 'package:uni_sphere/features/profile/data/models/update_profile_request.dart';
import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';
import 'package:uni_sphere/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ProfileRemoteDataSource dataSource;
  const ProfileRepositoryImpl({required this.dataSource});
  @override
  Future<ProfileUser> createProfile({required String displayName, String? profileImageUrl}) async{
    final request = CreateProfileRequest(displayName: displayName,profileImageUrl: profileImageUrl);
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
  Future<ProfileUser> updateProfile({required String displayName, String? profileImageUrl}) async{
    final request = UpdateProfileRequest(displayName: displayName,profileImageUrl: profileImageUrl);
    final response = await dataSource.updateProfile(request);
    return response.toEntity();
  }

}