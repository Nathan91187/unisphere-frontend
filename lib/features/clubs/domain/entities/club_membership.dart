import 'club_member_role.dart';

class ClubMembership {
  final int id;
  final int clubId;
  final String userId;
  final DateTime joinedAt;
  final ClubMemberRole role;

  const ClubMembership({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.joinedAt,
    required this.role,
  });
}