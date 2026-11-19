class ProfileUser {
  final String uid;
  final String username;
  final String displayName;
  final String? profileImageUrl;

  const ProfileUser({
    required this.uid,
    required this.username,
    required this.displayName,
    this.profileImageUrl,
  });
  ProfileUser copyWith({
    String? username,
    String? displayName,
    String? profileImageUrl
}){
    return ProfileUser(
        uid : uid,
        username : username ?? this.username,
        displayName : displayName ?? this.displayName,
        profileImageUrl : profileImageUrl ?? this.profileImageUrl
    );
  }
}