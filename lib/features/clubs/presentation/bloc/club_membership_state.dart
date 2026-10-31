import '../../domain/entities/club_membership.dart';

abstract class ClubMembershipState {}

class ClubMembershipInitial extends ClubMembershipState {}

class ClubMembershipLoading extends ClubMembershipState {}

class ClubMembershipLoaded extends ClubMembershipState {
  final ClubMembership membership;
  final bool? isOnlyOrganizer;

  ClubMembershipLoaded({
    required this.membership,
    this.isOnlyOrganizer,
  });
}
class ClubMembersLoaded extends ClubMembershipState {
  final List<ClubMembership> members;

  ClubMembersLoaded({required this.members});
}
class ClubMembershipOperationSuccess extends ClubMembershipState {
  final String message;

  ClubMembershipOperationSuccess({required this.message});
}
class ClubMembershipError extends ClubMembershipState {
  final String errorMsg;

  ClubMembershipError({required this.errorMsg});
}