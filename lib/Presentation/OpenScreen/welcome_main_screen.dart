import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class WelcomeMainScreen extends StatefulWidget {
  const WelcomeMainScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeMainScreen> createState() => _WelcomeMainScreenState();
}

class _WelcomeMainScreenState extends State<WelcomeMainScreen> {
  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: SizedBox(
            height: 768.v,
            width: double.maxFinite,
            child: Stack(alignment: Alignment.center, children: [
              CustomImageView(
                  imagePath: ImageConstant.imgUnsplashoalh2mojuuk,
                  height: 355.v,
                  width: 374.h,
                  alignment: Alignment.topCenter),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.h, vertical: 58.v),
                      decoration: AppDecoration
                          .gradientPrimaryContainerToPrimaryContainer,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Spacer(),
                            Text("Welcome to YING",
                                style: theme.textTheme.headlineLarge),
                            SizedBox(height: 12.v),
                            Text("The Community Platform",
                                style: CustomTextStyles.bodyLargeOnPrimary_1),
                            SizedBox(height: 78.v),
                            CustomElevatedButton(
                                buttonStyle:
                                    CustomButtonStyles.outlineOnPrimaryTL121,
                                height: 60.v,
                                text: "Log In",
                                buttonTextStyle: CustomTextStyles.titleMedium18,
                                onTap: () {
                                  onTapLogin(context);
                                }),
                            SizedBox(height: 20.v),
                            CustomElevatedButton(
                                height: 60.v,
                                text: "Sign Up",
                                buttonStyle: CustomButtonStyles.none,
                                decoration: CustomButtonStyles
                                    .gradientCyanToGreenDecoration,
                                buttonTextStyle:
                                    CustomTextStyles.titleMediumOnPrimary18_2,
                                onTap: () {
                                  onTapSignup(context);
                                })
                          ])))
            ])));
  }

  /// Navigates to the loginOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the loginOneScreen.
  onTapLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  /// Navigates to the onboardingTwoScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the onboardingTwoScreen.
  onTapSignup(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerIndividualOneScreen);
  }
}
