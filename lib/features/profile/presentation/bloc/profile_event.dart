import 'dart:io';

abstract class ProfileEvent {
  const ProfileEvent();
}
class CheckUsernameAvailability extends ProfileEvent {
  final String username;

  const CheckUsernameAvailability({required this.username});
}
class GetAllProfilesByUid extends ProfileEvent{
  final List<String> uids;
  const GetAllProfilesByUid({required this.uids});
}
class SearchUsersByUsername extends ProfileEvent{
  final String username;
  const SearchUsersByUsername({required this.username});
}
class GetProfileByUid extends ProfileEvent{
  final String uid;
  const GetProfileByUid({required this.uid});
}
class CreateProfile extends ProfileEvent{
  final String displayName;
  final String? profileImageUrl;
  final String username;
  const CreateProfile({this.profileImageUrl, required this.displayName, required this.username});
}class SaveProfileChanges extends ProfileEvent {
  final String username;
  final String displayName;
  final bool updateText;
  final File? image;

  const SaveProfileChanges({
    required this.username,
    required this.displayName,
    required this.updateText,
    this.image,
  });
}
class DeleteProfile extends ProfileEvent{
  const DeleteProfile();
}