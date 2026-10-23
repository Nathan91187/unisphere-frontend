class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? profileImageUrl;

  const User({
    required this.uid,
    this.email,
    this.displayName,
    this.profileImageUrl,
  });
}