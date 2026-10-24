import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:uni_sphere/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:uni_sphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:uni_sphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uni_sphere/features/clubs/data/datasources/club_remote_data_source.dart';
import 'package:uni_sphere/features/clubs/data/repositories/club_repository_impl.dart';
import 'package:uni_sphere/features/clubs/domain/repositories/club_repository.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_bloc.dart';
import 'package:uni_sphere/features/events/data/datasources/event_remote_data_source.dart';
import 'package:uni_sphere/features/events/data/repositories/event_repository_impl.dart';
import 'package:uni_sphere/features/events/domain/repositories/event_repository.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/firebase_options.dart';

import 'app/app.dart';
import 'features/clubs/presentation/bloc/club_event.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final eventRemoteDataSource = EventRemoteDataSource();
  final clubRemoteDataSource = ClubRemoteDataSource();
  final authRemoteDataSource = AuthRemoteDataSource();
  final EventRepository eventRepository = EventRepositoryImpl(dataSource: eventRemoteDataSource);
  final ClubRepository clubRepository = ClubRepositoryImpl(remoteDataSource: clubRemoteDataSource);
  final AuthRepository authRepository = AuthRepositoryImpl(authRemoteDataSource: authRemoteDataSource);
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider<EventBloc>(create: (context) => EventBloc(
              eventRepository: eventRepository)..add(LoadEvents()),
          ),
          BlocProvider<ClubBloc>(create: (context)=> ClubBloc(
              clubRepository: clubRepository)..add(LoadClubs())),
          BlocProvider(create: (context)=> AuthBloc(
              repository: authRepository))
        ],
      child: const UnisphereApp(),
      ));
}