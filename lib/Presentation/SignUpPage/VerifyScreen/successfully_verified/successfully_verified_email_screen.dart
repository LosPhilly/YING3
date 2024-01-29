import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

// import '../../../../core/utils/image_constant.dart';
import '../../../../widgets/custom_image_view.dart';

class SuccessfullyVerifiedEmailScreen extends StatefulWidget {
  const SuccessfullyVerifiedEmailScreen({Key? key}) : super(key: key);

  @override
  State<SuccessfullyVerifiedEmailScreen> createState() =>
      _SuccessfullyVerifiedEmailScreenState();
}

class _SuccessfullyVerifiedEmailScreenState
    extends State<SuccessfullyVerifiedEmailScreen> {
  toSetUpScreenGroupCode(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.setupGAccountGroupCodeScreen);
  }

  toSetUpScreenGroupOffering(BuildContext context) {
    if (isindividual == true) {
      Navigator.pushNamed(
        context,
        AppRoutes.registerIndividualSkillsScreen,
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.setupGAccountSkillsScreen,
      );
    }
  }

  var isindividual = false;
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        // toSetUpScreenGroupCode(context);
        toSetUpScreenGroupOffering(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    print(arguments['isindividual']);
    isindividual = arguments['isindividual'] ?? false;
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .1,
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
                // width: 295.h,
                child: Text(
                  isindividual == true
                      ? "Welcome\nto the Village!"
                      : "Welcome\nto the YING Lifestyle!",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.headlineMediumPrimary.copyWith(
                    height: 1.50,
                  ),
                ),
              ),
              SizedBox(height: 13.v),
              SizedBox(
                // width: 100.h,
                child: Text(
                  isindividual == true
                      ? "Let’s start Skill Sharing!"
                      : "Let’s start \nGroup SkillsharingTM!",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.64,
                  ),
                ),
              ),
              SizedBox(height: 13.v),
              // SizedBox(
              //   width: 170.h,
              //   child: Text(
              //     "A verification email has been sent to your email",
              //     maxLines: 3,
              //     textAlign: TextAlign.center,
              //     style: theme.textTheme.bodyLarge!.copyWith(
              //       height: 1.64,
              //     ),
              //   ),
              // ),
              SizedBox(height: 35.v),
              // ElevatedButton.icon(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all(
              //         theme.colorScheme.primary), // Changed to use theme color
              //   ),
              //   icon: const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Icon(
              //       Icons.email,
              //       size: 32,
              //       color: Colors.white,
              //     ),
              //   ),
              //   onPressed: canResendEmail
              //       ? () async {
              //           sendVerificationEmail();
              //           setState(() {
              //             canResendEmail = false;
              //             countdownSeconds =
              //                 45; // Reset the countdown after clicking the button
              //           });
              //         }
              //       : null,
              //   label: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       canResendEmail
              //           ? 'Resend Email'
              //           : 'Resend Email in $countdownSeconds',
              //       style: TextStyle(
              //         fontSize: 20,
              //         color: Theme.of(context).colorScheme.onPrimary,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 5.v),
              // ElevatedButton.icon(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all(
              //         theme.colorScheme.primary), // Changed to use theme color
              //   ),
              //   icon: const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Icon(
              //       Icons.cancel,
              //       size: 32,
              //       color: Colors.white,
              //     ),
              //   ),
              //   onPressed: () {
              //     onCancelVerify(context);
              //   },
              //   label: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       'Cancel',
              //       style: TextStyle(
              //         fontSize: 20,
              //         color: Theme.of(context).colorScheme.onPrimary,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 17.v),
              CustomImageView(
                svgPath: ImageConstant.imgConfetti,
                height: 155.v,
                width: 185.h,
              ),
            ],
          )),
    );
  }
}
