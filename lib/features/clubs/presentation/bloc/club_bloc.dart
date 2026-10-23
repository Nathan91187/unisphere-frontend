import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_state.dart';

class ClubBloc  extends Bloc<ClubEvent, ClubState>{
  final ClubRepository clubRepository;
  final unableToConnect = "Unable to connect. Please try again";
  ClubBloc({required this.clubRepository}) : super(ClubInitial()){
    on<LoadClubs> ((event,emit) async{
      try{
        emit(ClubLoading());
        final clubs = await clubRepository.getAllClubs();
        emit(ClubLoaded(clubs: clubs));
      } catch(e){
        emit(ClubError(errorMsg: unableToConnect));
      }
    });
  }
}