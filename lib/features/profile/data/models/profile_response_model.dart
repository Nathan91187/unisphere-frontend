import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';

class ProfileResponseModel {
  final String uid;
  final String username;
  final String displayName;
  final String? profileImageUrl;

  const ProfileResponseModel({
    required this.uid,
    required this.username,
    required this.displayName,
    this.profileImageUrl,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      uid: json['uid'],
      username: json['username'],
      displayName: json['displayName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
  ProfileUser toEntity(){
    return ProfileUser(
        uid: uid,
        username: username,
        displayName: displayName,
        profileImageUrl: profileImageUrl
    );
  }
}