class CreateProfileRequest {
  final String displayName;
  final String? profileImageUrl;
  final String username;
  const CreateProfileRequest({
    required this.displayName,
    required this.username,
    this.profileImageUrl
});
  Map<String,dynamic> toJson(){
    return {
      'displayName' : displayName,
      'profileImageUrl' : profileImageUrl,
      'username' : username
    };
  }
}