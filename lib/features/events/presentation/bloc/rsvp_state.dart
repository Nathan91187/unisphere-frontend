import 'package:uni_sphere/features/events/domain/entities/rsvp.dart';

abstract class RsvpState {
  const RsvpState();
}

class RsvpInitial extends RsvpState {
  const RsvpInitial();
}

class RsvpLoading extends RsvpState {
  const RsvpLoading();
}

class RsvpLoaded extends RsvpState {
  final List<Rsvp> rsvps;

  const RsvpLoaded({required this.rsvps});
}
class MyRsvpLoaded extends RsvpState {
  final Rsvp? rsvp;

  const MyRsvpLoaded({required this.rsvp});
}
class RsvpOperationSuccess extends RsvpState {
  final String message;

  const RsvpOperationSuccess({required this.message});
}

class RsvpError extends RsvpState {
  final String errorMsg;

  const RsvpError({required this.errorMsg});
}