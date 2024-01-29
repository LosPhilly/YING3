import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/IndividualGigFeedScreen/gig_feed_1_feed_screen.dart';
import 'package:ying_3_3/Presentation/OpenScreen/welcome_main_screen.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/widgets/nav.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  void toLoginInScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  void toGigFeedScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.gigFeedOneScreen);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapShot) {
        if (userSnapShot.data == null) {
          // ignore: avoid_print
          print('User is not logged in');

          return const WelcomeMainScreen();
        } else if (userSnapShot.hasData) {
          // ignore: avoid_print
          print('User is logged in');
          return const Scaffold(
            body: Center(child: GigFeed1FeedScreen()),
            bottomNavigationBar: Nav(initialIndex: 0),
          );
        } else if (userSnapShot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error has occured'),
            ),
          );
        } else if (userSnapShot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: Text('Somthing went wrong..'),
          ),
        );
      },
    );
  }
}
