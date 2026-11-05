import 'package:uni_sphere/features/events/domain/entities/rsvp_status.dart';

class Rsvp {
  final int id;
  final String userUid;
  final int eventId;
  final DateTime createdAt;
  final RsvpStatus status;
  const Rsvp({
    required this.eventId,
    required this.id,
    required this.createdAt,
    required this.status,
    required this.userUid
});
}