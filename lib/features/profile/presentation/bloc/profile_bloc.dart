import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/profile/domain/repository/profile_repository.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  final ProfileRepository profileRepository;
  ProfileBloc({required this.profileRepository}):super(const ProfileInitial()){
    on<CheckUsernameAvailability>((event,emit) async {
      emit(const ProfileLoading());
      try{
        final isAvailable = await profileRepository
            .checkUsernameAvailability(username: event.username.trim());
        emit(UsernameAvailabilityChecked(isAvailable: isAvailable));
      }
      catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
    on<GetProfileByUid>((event,emit) async {
      emit(const ProfileLoading());
      try{
        final profile = await profileRepository.getProfileByUid(uid: event.uid);
        emit(ProfileLoaded(profileUser: profile));
      }
      catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
    on<GetAllProfilesByUid>((event,emit)async{
      if (event.uids.isEmpty) {
        emit(const ProfilesLoaded(profiles: []));
        return;
      }
      emit(ProfileLoading());
      try{
        final profiles = await profileRepository.getAllProfilesByUid(uids: event.uids);
        emit(ProfilesLoaded(profiles: profiles));
      }
      catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
    on<SearchUsersByUsername>((event,emit)async{
      if (event.username.trim().isEmpty) {
        emit(const ProfilesLoaded(profiles: []));
        return;
      }
      emit(ProfileLoading());
      try{
        final profiles = await profileRepository.searchUsersByUsername(username: event.username);
        emit(ProfilesLoaded(profiles: profiles));
      }
      catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
    on<CreateProfile>((event,emit) async{
      emit(const ProfileLoading());
      try{
        final profile = await profileRepository.createProfile(
            displayName: event.displayName,
            profileImageUrl: event.profileImageUrl,
            username: event.username.trim()
        );
        emit(ProfileLoaded(profileUser: profile));
      }catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });

    on<UpdateProfile>((event,emit) async{
      emit(const ProfileLoading());
      try{
        final profile = await profileRepository.updateProfile(
            username: event.username.trim(),
            displayName: event.displayName,
            profileImageUrl: event.profileImageUrl);
        emit(ProfileLoaded(profileUser: profile));
      }catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
    on<DeleteProfile>((event,emit) async{
      emit(const ProfileLoading());
      try{
       await profileRepository.deleteProfile();
       emit(const ProfileDeleted());
      }catch(e){
        emit(ProfileError(
          errorMsg: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    });
  }
}