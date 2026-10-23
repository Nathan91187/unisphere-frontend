import 'package:flutter/material.dart';
import 'package:uni_sphere/app/app_router.dart';
import 'package:uni_sphere/core/theme/app_theme.dart';
class UnisphereApp extends StatefulWidget {
  const UnisphereApp ({super.key});

  @override
  State<UnisphereApp> createState() => _UnisphereAppState();
}

class _UnisphereAppState extends State<UnisphereApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Unisphere',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.appTheme,
      routerConfig: appRouter,
    );
  }
}
