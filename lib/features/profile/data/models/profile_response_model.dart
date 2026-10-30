import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';

class ProfileResponseModel {
  final String uid;
  final String email;
  final String displayName;
  final String? profileImageUrl;

  const ProfileResponseModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
  ProfileUser toEntity(){
    return ProfileUser(
        uid: uid,
        email: email,
        displayName: displayName,
        profileImageUrl: profileImageUrl
    );
  }
}