import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/core/widgets/loading.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/rsvp_state.dart';

import '../../../../core/widgets/unable_to_connect.dart';
class EventRegistrations extends StatefulWidget {

  final int eventId;
  const EventRegistrations({
    super.key,
    required this.eventId
  });

  @override
  State<EventRegistrations> createState() => _EventRegistrationsState();
}

class _EventRegistrationsState extends State<EventRegistrations> {
  @override
  void initState() {
    super.initState();

    context.read<RsvpBloc>().add(
      LoadRsvps(eventId: widget.eventId),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrations'),
      ),
      body: BlocBuilder<RsvpBloc,RsvpState>(
          builder: (context,state){
            if(state is RsvpLoading){
              return const Loading();
            }
            if (state is RsvpError) {
              return unableToConnectWidget(
                state.errorMsg,
                    () => context.read<RsvpBloc>().add(LoadRsvps(eventId: widget.eventId)),
              );
            }
            if(state is RsvpLoaded){
              final rsvps = state.rsvps;
              if(rsvps.isEmpty){
                return Center(
                  child: Text(
                    'No one has registered for this event'
                  ),
                );
              }
            }
            return SizedBox.shrink();
          }),
    );
  }
}
