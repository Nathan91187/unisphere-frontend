class UpdateProfileRequest {
  final String displayName;
  final String? profileImageUrl;
  final String username;
  const UpdateProfileRequest({
    required this.displayName,
    this.profileImageUrl,
    required this.username
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'username' : username
    };
  }
}