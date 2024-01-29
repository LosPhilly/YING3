import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import '../../../core/constants/string_const.dart';

class RegisterIndividualVerifyEmailScreen extends StatefulWidget {
  const RegisterIndividualVerifyEmailScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<RegisterIndividualVerifyEmailScreen> createState() =>
      _RegisterIndividualVerifyEmailScreenState();
}

class _RegisterIndividualVerifyEmailScreenState
    extends State<RegisterIndividualVerifyEmailScreen> {
  bool isEmailVerified = false;

  Timer? timer;
  Timer? timerCountDown;
  Timer? timerCountDownSeconds;
  late int countdownSeconds; // Variable to keep track of remaining seconds

  late MediaQueryData mediaQueryData;

  bool canResendEmail = false;

  toSetUpScreenInterest(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.successfullyVerifiedEmailScreen,
        arguments: {"isindividual": true});
    // Navigator.pushNamed(context, AppRoutes.registerIndividualInterestScreen);
  }

  void onCancelVerify(BuildContext context) {
    deleteUserAndDocument();
    Navigator.pushNamed(context, AppRoutes.welcomeMainScreen);
  }

  Future<void> deleteUserAndDocument() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;

      // Delete user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Delete user from Firebase Authentication
      await user.delete();
      timer?.cancel();
      timerCountDown?.cancel();
      timerCountDownSeconds?.cancel();

      // ignore: avoid_print
      print('User and document deleted successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to delete user and document: $e');
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      // ignore: use_build_context_synchronously
      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      timerCountDown?.cancel();
      timerCountDownSeconds?.cancel();
      // ignore: use_build_context_synchronously
      toSetUpScreenInterest(context);
    }
  }

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    countdownSeconds = 60;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) {
          checkEmailVerified();
        },
      );
      timerCountDown = Timer.periodic(
        const Duration(seconds: 60),
        (_) {
          setState(() {
            canResendEmail = true;
          });
        },
      );

      timerCountDownSeconds = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          setState(() {
            if (countdownSeconds > 0) {
              countdownSeconds--;
            }
          });
        },
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the timer to avoid memory leaks when the widget is disposed
    timer?.cancel();
    timerCountDown?.cancel();
    timerCountDownSeconds?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 40.h,
            vertical: 45.v,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVerifyEmailSent,
              ),
              SizedBox(height: 35.v),
              Text("Verify your email", style: theme.textTheme.headlineLarge),
              SizedBox(height: 12.v),
              Text(
                  "We sent you an email verification link on your email address",
                  style: CustomTextStyles.bodyLargeOnPrimary_1),
              SizedBox(height: 35.v),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      theme.colorScheme.primary), // Changed to use theme color
                ),
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.email,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                onPressed: canResendEmail
                    ? () async {
                        sendVerificationEmail();
                        setState(() {
                          canResendEmail = false;
                          countdownSeconds =
                              45; // Reset the countdown after clicking the button
                        });
                      }
                    : null,
                label: Text(
                  canResendEmail
                      ? 'Resend Email'
                      : 'Resend Email in $countdownSeconds',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: REGULAR_FONT,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              SizedBox(height: 12.v),
              /* Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(theme
                        .colorScheme.primary), // Changed to use theme color
                  ),
                  icon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.cancel,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    onCancelVerify(context);
                  },
                  label: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: REGULAR_FONT,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ), */
            ],
          )),
    );
  }
}
