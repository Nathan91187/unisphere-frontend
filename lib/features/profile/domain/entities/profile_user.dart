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
}