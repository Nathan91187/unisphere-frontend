import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/features/clubs/presentation/pages/clubs_page.dart';
import 'package:uni_sphere/features/events/presentation/pages/event_details_page.dart';
import 'package:uni_sphere/features/events/presentation/pages/events_page.dart';
import 'package:uni_sphere/features/home/presentation/pages/home_page.dart';
import 'package:uni_sphere/features/profile/presentation/pages/profile_page.dart';

import '../features/events/domain/entities/event.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.event_outlined),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.group_outlined),
                label: 'Clubs',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/events',
              builder: (context, state) => const EventsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/clubs',
              builder: (context, state) => const ClubsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: "/event-details",
        builder: (context,state){
          final event = state.extra as Event;
          return EventDetailsPage(event: event);
        }

    )

  ],
);
