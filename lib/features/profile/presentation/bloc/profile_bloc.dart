import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/profile/domain/repository/profile_repository.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  final ProfileRepository profileRepository;
  ProfileBloc({required this.profileRepository}):super(const ProfileInitial()){
    on<GetProfileByUid>((event,emit) async {
      emit(const ProfileLoading());
      try{
        final profile = await profileRepository.getProfileByUid(uid: event.uid);
        emit(ProfileLoaded(profileUser: profile));
      }
      catch(e){
        emit(ProfileError(errorMsg: e.toString()));
      }
    });
    on<CreateProfile>((event,emit) async{
      emit(const ProfileLoading());
      try{
        final profile = await profileRepository.createProfile(
            displayName: event.displayName,
            profileImageUrl: event.profileImageUrl);
        emit(ProfileLoaded(profileUser: profile));
      }catch(e){
        emit(ProfileError(errorMsg: e.toString()));
      }
    });

    on<UpdateProfile>((event,emit) async{
      emit(const ProfileLoading());
      try{
        final profile = await profileRepository.updateProfile(
            displayName: event.displayName,
            profileImageUrl: event.profileImageUrl);
        emit(ProfileLoaded(profileUser: profile));
      }catch(e){
        emit(ProfileError(errorMsg: e.toString()));
      }
    });
    on<DeleteProfile>((event,emit) async{
      emit(const ProfileLoading());
      try{
       await profileRepository.deleteProfile();
       emit(const ProfileDeleted());
      }catch(e){
        emit(ProfileError(errorMsg: e.toString()));
      }
    });
  }
}