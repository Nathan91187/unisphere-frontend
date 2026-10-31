abstract class ClubMembershipEvent {}

class GetMyMembership extends ClubMembershipEvent {
  final int clubId;

  GetMyMembership({required this.clubId});
}

class LeaveClub extends ClubMembershipEvent {
  final int clubId;

  LeaveClub({required this.clubId});
}
class JoinClub extends ClubMembershipEvent {
  final int clubId;

  JoinClub({required this.clubId});
}
class CheckLeaveEligibility extends ClubMembershipEvent {
  final int clubId;

  CheckLeaveEligibility({required this.clubId});
}
class GetClubMembers extends ClubMembershipEvent {
  final int clubId;

  GetClubMembers({required this.clubId});
}