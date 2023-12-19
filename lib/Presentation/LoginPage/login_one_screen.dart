import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/SignUpPage/register_individual_one_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';

import 'package:ying_3_3/widgets/custom_checkbox_button.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_floating_text_field.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore_for_file: must_be_immutable
class LoginOneScreen extends StatefulWidget {
  const LoginOneScreen({Key? key}) : super(key: key);

  @override
  State<LoginOneScreen> createState() => _LoginOneScreenState();
}

class _LoginOneScreenState extends State<LoginOneScreen> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passTextController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool englishLabel = false;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();

    super.dispose();
  }

  void _onTapLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        // ignore: use_build_context_synchronously
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        // ignore: use_build_context_synchronously
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        // ignore: avoid_print
        print('error occured at Login: $error');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _loginFormKey,
        child: SizedBox(
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
                                  margin:
                                      EdgeInsets.only(top: 96.v, right: 73.h))
                            ],
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 71.v),
                              child: Text("Let’s log you in",
                                  style: theme.textTheme.headlineLarge))),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 38.v),
                              child: Text("Welcome Back 👋",
                                  style: CustomTextStyles.bodyLargeOnPrimary)))
                    ],
                  ),
                ),
              ),
              CustomFloatingTextField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    } else {
                      return null;
                    }
                  },
                  margin: EdgeInsets.only(left: 28.h, top: 13.v, right: 28.h),
                  controller: _emailTextController,
                  labelText: "Email address",
                  labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                  hintText: "Email address",
                  textInputType: TextInputType.emailAddress),
              CustomFloatingTextField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Please enter a valid password';
                    } else {
                      return null;
                    }
                  },
                  margin: EdgeInsets.only(left: 28.h, top: 24.v, right: 28.h),
                  controller: _passTextController,
                  labelText: "Password",
                  labelStyle: theme.textTheme.bodyMedium!,
                  hintText: "Password",
                  hintStyle: theme.textTheme.bodyMedium!,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true,
                  suffix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      child: CustomImageView(
                          svgPath: ImageConstant.imgOutlineEye)),
                  suffixConstraints: BoxConstraints(maxHeight: 56.v)),
              Padding(
                padding: EdgeInsets.only(left: 28.h, top: 24.v, right: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomCheckboxButton(
                      text: "Remember me",
                      value: englishLabel,
                      padding: EdgeInsets.symmetric(vertical: 1.v),
                      textStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                      onChange: (value) {
                        englishLabel = value;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.v),
                      child: TextButton(
                          onPressed: () {
                            onTapForgotPassword(context);
                          },
                          child: Text(
                            "Forgot Password",
                            style: theme.textTheme.bodyMedium,
                          )),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomElevatedButton(
                text: "Log In",
                margin: EdgeInsets.symmetric(horizontal: 28.h),
                onTap: () {
                  _onTapLogin();
                },
                buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
              ),
              SizedBox(height: 42.v),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Don’t have an account?",
                        style: theme.textTheme.bodyLarge),
                    const TextSpan(text: " "),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterIndividualOneScreen(),
                                ),
                              ),
                        text: "Sign Up",
                        style: CustomTextStyles.titleMediumPrimary_1)
                  ]),
                  textAlign: TextAlign.left),
              SizedBox(height: 69.v)
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the login2OtpOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the login2OtpOneScreen.

  /// Navigates to the registerIndividualOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the registerIndividualOneScreen.
  onTapTxtDonthaveanaccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  onTapForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
  }

  onTapLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
