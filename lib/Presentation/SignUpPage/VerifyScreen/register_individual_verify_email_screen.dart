import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

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
    Navigator.pushNamed(context, AppRoutes.registerIndividualInterestScreen);
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
            children: [
              const Spacer(),
              Expanded(
                child: CustomImageView(
                  svgPath: ImageConstant.imgIcon,
                  height: 164.adaptSize,
                  width: 164.adaptSize,
                ),
              ),
              SizedBox(height: 35.v),
              SizedBox(
                width: 295.h,
                child: Text(
                  "Welcome\nto the YING Lifestyle!",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.headlineMediumPrimary.copyWith(
                    height: 1.50,
                  ),
                ),
              ),
              SizedBox(height: 13.v),
              SizedBox(
                width: 170.h,
                child: Text(
                  "Let’s start \nGroup SkillsharingTM!",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.64,
                  ),
                ),
              ),
              SizedBox(height: 13.v),
              SizedBox(
                width: 170.h,
                child: Text(
                  "A verification email has been sent to your email",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.64,
                  ),
                ),
              ),
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
                    size: 32,
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
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    canResendEmail
                        ? 'Resend Email'
                        : 'Resend Email in $countdownSeconds',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.v),
              /* ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      theme.colorScheme.primary), // Changed to use theme color
                ),
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.cancel,
                    size: 32,
                  ),
                ),
                onPressed: () {
                  onCancelVerify(context);
                },
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ), */
              SizedBox(height: 17.v),
              CustomImageView(
                svgPath: ImageConstant.imgConfetti,
                height: 155.v,
                width: 185.h,
              ),
              const Spacer(),
            ],
          )),
    );
  }
}
