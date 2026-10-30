class CreateProfileRequest {
  final String displayName;
  final String? profileImageUrl;
  const CreateProfileRequest({
    required this.displayName,
    this.profileImageUrl
});
  Map<String,dynamic> toJson(){
    return {
      'displayName' : displayName,
      'profileImageUrl' : profileImageUrl
    };
  }
}