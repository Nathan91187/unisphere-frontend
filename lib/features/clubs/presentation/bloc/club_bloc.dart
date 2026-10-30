import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_state.dart';

class ClubBloc  extends Bloc<ClubEvent, ClubState>{
  final ClubRepository clubRepository;
  ClubBloc({required this.clubRepository}) : super(ClubInitial()){
    on<LoadClubs> ((event,emit) async{
      try{
        emit(ClubLoading());
        final clubs = await clubRepository.getAllClubs();
        emit(ClubLoaded(clubs: clubs));
      } catch(e){
        emit(ClubError(errorMsg: e.toString()));
      }
    });
    on<GetClubById>((event,emit)async{
      try{
        emit(ClubLoading());
        final club = await clubRepository.getClubById(clubId: event.clubId);
        emit(ClubDetailsLoaded(club: club));
      }
      catch(e){
        emit (ClubError(errorMsg: e.toString()));
      }
    });
    on<CreateClub>((event,emit)async{
      try{
        emit(ClubLoading());
        final club = await clubRepository.createClub(
            name: event.name,
            description: event.description,
            category: event.category,
            imageUrl: event.imageUrl
        );
        emit(
            ClubOperationSuccess(
            club: club,
            message: 'Club created successfully')
        );
      }
      catch(e){
        emit (ClubError(errorMsg: e.toString()));
      }
    });
    on<UpdateClub>((event,emit)async{
      try{
        emit(ClubLoading());
        final club = await clubRepository.updateClub(
            clubId: event.clubId,
            name: event.name,
            description: event.description,
            category: event.category,
            imageUrl: event.imageUrl
        );
        emit(
            ClubOperationSuccess(
            club: club,
            message: 'Club updated successfully')
        );
      }
      catch(e){
        emit (ClubError(errorMsg: e.toString()));
      }
    });
    on<DeleteClub>((event,emit)async{
      try{
        emit(ClubLoading());
        await clubRepository.deleteClub(clubId: event.clubId);
        emit(
            ClubOperationSuccess(
                message: 'Club deleted successfully')
        );
      }
      catch(e){
        emit (ClubError(errorMsg: e.toString()));
      }
    });
  }
}