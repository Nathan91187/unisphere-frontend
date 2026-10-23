import 'package:uni_sphere/features/clubs/domain/entities/club.dart';

abstract class ClubState {}
class ClubInitial extends ClubState{}
class ClubLoading extends ClubState{}
class ClubLoaded extends ClubState{
  final List<Club> clubs;
  ClubLoaded({required this.clubs});
}
class ClubError extends ClubState{
  final String errorMsg;
  ClubError({required this.errorMsg});
}