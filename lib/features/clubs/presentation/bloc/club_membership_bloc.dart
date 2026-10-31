import 'package:bloc/bloc.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_membership_state.dart';

import '../../domain/entities/club_member_role.dart';

class ClubMembershipBloc extends Bloc<ClubMembershipEvent, ClubMembershipState>{
  final ClubRepository clubRepository;
  ClubMembershipBloc({required this.clubRepository}):super(ClubMembershipInitial()){
    on<GetMyMembership>((event, emit) async {
      try {
        emit(ClubMembershipLoading());

        final membership = await clubRepository.getMyMembership(
          clubId: event.clubId,
        );

        if (membership.role == ClubMemberRole.organizer) {
          final isOnlyOrganizer =
          await clubRepository.checkLeaveEligibility(
            clubId: event.clubId,
          );

          emit(ClubMembershipLoaded(
            membership: membership,
            isOnlyOrganizer: isOnlyOrganizer,
          ));
        } else {
          emit(ClubMembershipLoaded(
            membership: membership,
          ));
        }
      } catch (e) {
        emit(ClubMembershipError(errorMsg: e.toString()));
      }
    });
    on<LeaveClub>((event,emit)async{
      try{
        emit(ClubMembershipLoading());
        await clubRepository.leaveClub(clubId: event.clubId);
        emit(ClubMembershipOperationSuccess(message: 'You have left the club'));
      }
      catch(e){
        emit(ClubMembershipError(errorMsg: e.toString()));
      }
    });
    on<JoinClub>((event,emit)async{
      try{
        emit(ClubMembershipLoading());
        final membership = await clubRepository.joinClub(clubId: event.clubId);
        emit(ClubMembershipLoaded(membership: membership));
      }
      catch(e){
        emit(ClubMembershipError(errorMsg: e.toString()));
      }
    });
    on<CheckLeaveEligibility>((event, emit) async {
      try {
        final currentState = state;

        if (currentState is! ClubMembershipLoaded ||
            currentState.membership.clubId != event.clubId) {
          return;
        }
        final isOnlyOrganizer = await clubRepository
            .checkLeaveEligibility(
              clubId: event.clubId,
            );
        emit(ClubMembershipLoaded(
          membership: currentState.membership,
          isOnlyOrganizer: isOnlyOrganizer,
        ));
      } catch (e) {
        emit(ClubMembershipError(errorMsg: e.toString()));
      }
    });
  }
}