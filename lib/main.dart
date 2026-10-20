import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/events/data/datasources/event_remote_data_source.dart';
import 'package:uni_sphere/features/events/data/repositories/event_repository_impl.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';

import 'app/app.dart';

void main() {
  final dataSource = EventRemoteDataSource();
  EventRepository eventRepository = EventRepositoryImpl(dataSource: dataSource);
  runApp(
      BlocProvider(create: (context) => EventBloc(
          eventRepository: eventRepository)..add(LoadEvents()),
      child: const UnisphereApp(),
      ));
}