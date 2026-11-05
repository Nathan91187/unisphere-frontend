import 'package:uni_sphere/features/events/domain/entities/rsvp.dart';

import '../../domain/entities/rsvp_status.dart';

class RsvpModel {
  final int id;
  final String userUid;
  final int eventId;
  final DateTime createdAt;
  final RsvpStatus status;
  const RsvpModel({
    required this.userUid,
    required this.status,
    required this.createdAt,
    required this.id,
    required this.eventId
});
  factory RsvpModel.fromJson(Map<String,dynamic>json){
    return RsvpModel(
        userUid: json['userUid'],
        status: RsvpStatus.values.byName(json['status'].toString().toLowerCase()),
        createdAt: DateTime.parse(json['createdAt']),
        id: json['id'],
        eventId: json['eventId']);
  }
  Rsvp toEntity(){
    return Rsvp(eventId: eventId, id: id, createdAt: createdAt, status: status, userUid: userUid);
  }
}
