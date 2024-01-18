import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';
import 'package:ying_3_3/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirebaseProvider(),
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                routes: AppRoutes.routes,
                home: const Scaffold(
                  body: Center(
                      child: Center(
                    child: CircularProgressIndicator(),
                  )),
                ),
              );
            } else if (snapshot.hasError) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                routes: AppRoutes.routes,
                home: Scaffold(
                  body: Center(
                    child: Text(
                      'AN ERROR HAS OCCURED 4',
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'YING App',
              theme: ThemeData(
                  scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
                  primaryColor: theme.colorScheme.primary),
              routes: AppRoutes.routes,
              home: const UserState(),
            );
          }),
    );
  }
}
