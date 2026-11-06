import 'package:uni_sphere/features/events/domain/entities/rsvp_status.dart';

abstract class RsvpEvent {
  const RsvpEvent();
}
class LoadRsvps extends RsvpEvent{
  final int eventId;
  const LoadRsvps({required this.eventId});
}
class LoadMyRsvp extends RsvpEvent{
  final int eventId;
  const LoadMyRsvp({required this.eventId});
}
class CreateRsvp extends RsvpEvent{
  final int eventId;
  final RsvpStatus status;
  const CreateRsvp({
  required this.status,
  required this.eventId});
}
class UpdateRsvp extends RsvpEvent{
  final int eventId;
  final RsvpStatus status;
  const UpdateRsvp({
    required this.status,
    required this.eventId
});
}
class DeleteRsvp extends RsvpEvent{
  final int eventId;
  const DeleteRsvp({required this.eventId});
}