import 'package:flutter/material.dart';
import 'package:uni_sphere/core/theme/app_theme.dart';
import 'package:uni_sphere/features/clubs/presentation/pages/clubs_page.dart';
import 'package:uni_sphere/features/events/presentation/pages/events_page.dart';
import 'package:uni_sphere/features/home/presentation/pages/home_page.dart';
import 'package:uni_sphere/features/profile/presentation/pages/profile_page.dart';

class UnisphereApp extends StatefulWidget {
  const UnisphereApp ({super.key});

  @override
  State<UnisphereApp> createState() => _UnisphereAppState();
}

class _UnisphereAppState extends State<UnisphereApp> {
  final List<Widget> pages = [
    const HomePage(),
    const EventsPage(),
    const ClubsPage(),
    const ProfilePage()
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unisphere',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.appTheme,
      home: Scaffold(
        body: IndexedStack(
          index:selectedIndex,
            children: pages),
        bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.event_outlined),
                  label: "Events"),
              NavigationDestination(
                  icon: Icon(Icons.group_outlined),
                  label: "Clubs"),
              NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  label: "Profile"),
            ]),
      ),
    );
  }
}
