class ProfileUser {
  final String uid;
  final String email;
  final String displayName;
  final String? profileImageUrl;

  const ProfileUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
  });
}