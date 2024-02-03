import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:ying_3_3/Presentation/SplashScreen/welcome_splash_screen/welcome_splash_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/firebase_options.dart';
import 'package:ying_3_3/providers/auth_controller.dart';
import 'package:ying_3_3/providers/firebase_provider.dart';
import 'package:ying_3_3/user_state.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  // Initialize Firebase before using Firebase services
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Your background message handling code
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase before using Firebase Messaging
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
                      'AN ERROR HAS OCCURRED 4',
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
              home: const WelcomeSplashScreen(),
            );
          }),
    );
  }
}
