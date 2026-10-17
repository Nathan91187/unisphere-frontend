import 'package:flutter/material.dart';

class UnisphereApp extends StatelessWidget {
  const UnisphereApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unisphere',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Unisphere'),
        ),
        body: Center(
          child: Text('Unishpere'),
        ),
      ),
    );
  }
}
