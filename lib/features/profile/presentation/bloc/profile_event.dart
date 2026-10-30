abstract class ProfileEvent {
  const ProfileEvent();
}
class GetProfileByUid extends ProfileEvent{
  final String uid;
  const GetProfileByUid({required this.uid});
}
class CreateProfile extends ProfileEvent{
  final String displayName;
  final String? profileImageUrl;
  const CreateProfile({this.profileImageUrl, required this.displayName});
}
class UpdateProfile extends ProfileEvent{
  final String displayName;
  final String? profileImageUrl;
  const UpdateProfile({this.profileImageUrl, required this.displayName});
}
class DeleteProfile extends ProfileEvent{
  const DeleteProfile();
}