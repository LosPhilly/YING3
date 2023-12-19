import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_floating_text_field.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _forgetPassTextController =
      TextEditingController(text: '');

  @override
  void dispose() {
    super.dispose();
  }

//LOGIN SCREEN ANIMATION
  @override
  void initState() {
    super.initState();
  }

  //LOGIN SCREEN ANIMATION END

//FORGOT PASSWORD SUBMIT START//

  void _forgetPassSubmitForm() async {
    try {
      await _auth.sendPasswordResetEmail(
        email: _forgetPassTextController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, AppRoutes.loginOneScreen);
    } catch (error) {
      // ignore: use_build_context_synchronously
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }

//FORGOT PASSWORD SUBMIT END//

  onTapGoBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 254.v,
                width: 347.h,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 254.v,
                        width: 268.h,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgObject254x268,
                                height: 254.v,
                                width: 268.h,
                                alignment: Alignment.center),
                            CustomImageView(
                                svgPath: ImageConstant.imgComputer,
                                height: 29.v,
                                width: 34.h,
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 96.v, right: 73.h))
                          ],
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 71.v),
                            child: Text("Forgot Password",
                                style: theme.textTheme.headlineLarge))),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 38.v),
                            child: Text("Did you forget your password? 👋",
                                style: CustomTextStyles.bodyLargeOnPrimary)))
                  ],
                ),
              ),
            ),
            CustomFloatingTextField(
                margin: EdgeInsets.only(left: 28.h, top: 13.v, right: 28.h),
                controller: _forgetPassTextController,
                labelText: "Email address",
                labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                hintText: "Email address",
                textInputType: TextInputType.emailAddress),
            SizedBox(height: 42.v),
            CustomElevatedButton(
              text: "Reset Password",
              margin: EdgeInsets.symmetric(horizontal: 28.h),
              onTap: () {
                _forgetPassSubmitForm();
              },
              buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
            ),
            SizedBox(height: 42.v),
            GestureDetector(
              onTap: () {
                onTapGoBack(context);
              },
              child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Nevermind!", style: theme.textTheme.bodyLarge),
                    const TextSpan(text: " "),
                    TextSpan(
                        text: "Go Back!",
                        style: CustomTextStyles.titleMediumPrimary_1)
                  ]),
                  textAlign: TextAlign.left),
            ),
            SizedBox(height: 69.v)
          ],
        ),
      ),
    );
  }
}
