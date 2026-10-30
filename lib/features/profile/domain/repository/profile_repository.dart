import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser> getProfileByUid({required String uid});

  Future<ProfileUser> createProfile({
    required String displayName,
    String? profileImageUrl,
  });

  Future<ProfileUser> updateProfile({
    required String displayName,
    String? profileImageUrl,
  });

  Future<void> deleteProfile();
}