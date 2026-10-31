import '../../domain/entities/club_member_role.dart';
import '../../domain/entities/club_membership.dart';

class ClubMembershipModel {
  final int id;
  final int clubId;
  final String userId;
  final DateTime joinedAt;
  final ClubMemberRole role;

  const ClubMembershipModel({
    required this.id,
    required this.clubId,
    required this.userId,
    required this.joinedAt,
    required this.role,
  });
  factory ClubMembershipModel.fromJson(Map<String,dynamic> json){
    return ClubMembershipModel(
        id: json['id'],
        clubId: json['clubId'],
        userId: json['userId'],
        joinedAt: DateTime.parse(json['joinedAt']),
        role: ClubMemberRole.values.byName(json['role'].toString().toLowerCase()));
  }
  ClubMembership toEntity() {
    return ClubMembership(
      id: id,
      clubId: clubId,
      userId: userId,
      joinedAt: joinedAt,
      role: role,
    );
  }
}