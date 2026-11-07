import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepository {
  Future<bool>checkUsernameAvailability({required String username});
  Future<ProfileUser> getProfileByUid({required String uid});
  Future<List<ProfileUser>> getAllProfilesByUid({required List<String> uids});
  Future<List<ProfileUser>> searchUsersByUsername({required String username});
  Future<ProfileUser> createProfile({
    required String displayName,
    String? profileImageUrl,
    required String username
  });
  Future<ProfileUser> updateProfile({
    required String displayName,
    String? profileImageUrl,
    required String username
  });
  Future<void> deleteProfile();
}