class UpdateProfileRequest {
  final String displayName;
  final String? profileImageUrl;

  const UpdateProfileRequest({
    required this.displayName,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
    };
  }
}