import 'package:uni_sphere/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {
  const ProfileState();
}
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}
class ProfileLoaded extends ProfileState{
  final ProfileUser profileUser;
  const ProfileLoaded({required this.profileUser});
}
class ProfileError extends ProfileState{
  final String errorMsg;
  const ProfileError({required this.errorMsg});
}
class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}