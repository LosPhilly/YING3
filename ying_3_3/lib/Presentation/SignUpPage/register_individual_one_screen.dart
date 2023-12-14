// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:ying_3_3/Presentation/LoginPage/login_one_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class RegisterIndividualOneScreen extends StatefulWidget {
  const RegisterIndividualOneScreen({Key? key}) : super(key: key);

  @override
  State<RegisterIndividualOneScreen> createState() =>
      _RegisterIndividualOneScreenState();
}

class _RegisterIndividualOneScreenState
    extends State<RegisterIndividualOneScreen> {
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _newpasswordController = TextEditingController();

  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _newpasswordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

//SUBMIT SIGN UP FORM START//
  _onTapSignup(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _confirmpasswordController.text.trim(),
        );

        final User? user = _auth.currentUser;
        final uid = user!.uid;

        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': _fullNameController.text,
          'email': _emailController.text,
          'password': _confirmpasswordController.text,
          'createdAt': Timestamp.now(),
          'groupsIn': [],
          'interest': [],
          'skills': [],
          'daysAvailable': [],
          'timesAvailable': [],
          'locationPreference': [],
          'userImage': '',
          'user': 'individual',
        });

        // ignore: use_build_context_synchronously
        verifyEmail(context);
      } catch (e) {
        print('Error creating user: $e');

        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(
            context, AppRoutes.registerIndividualInterestScreen);
      }
    }
  }

//SUBMIT SIGN UP FORM END//

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: 768.v,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.h, vertical: 26.v),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: fs.Svg(ImageConstant.imgGroup5),
                              fit: BoxFit.cover)),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Sign up",
                                style: theme.textTheme.headlineMedium)),
                        SizedBox(height: 21.v),
                        CustomTextFormField(
                          textStyle: const TextStyle(color: Colors.black),
                          controller: _fullNameController,
                          hintText: "Full name",
                          hintStyle: theme.textTheme.bodyMedium!,
                          prefix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(16.h, 18.v, 8.h, 18.v),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgOutlineUser)),
                          prefixConstraints: BoxConstraints(maxHeight: 56.v),
                          contentPadding: EdgeInsets.only(
                              top: 17.v, right: 30.h, bottom: 17.v),
                          borderDecoration:
                              TextFormFieldStyleHelper.outlineOnPrimary,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field Missing';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 24.v),
                        CustomTextFormField(
                          textStyle: const TextStyle(color: Colors.black),
                          controller: _emailController,
                          hintText: "Email address",
                          hintStyle: theme.textTheme.bodyMedium!,
                          textInputType: TextInputType.emailAddress,
                          prefix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(16.h, 18.v, 8.h, 18.v),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgMail)),
                          prefixConstraints: BoxConstraints(maxHeight: 56.v),
                          contentPadding: EdgeInsets.only(
                              top: 17.v, right: 30.h, bottom: 17.v),
                          borderDecoration:
                              TextFormFieldStyleHelper.outlineOnPrimary,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 24.v),
                        CustomTextFormField(
                            textStyle: const TextStyle(color: Colors.black),
                            controller: _newpasswordController,
                            hintText: "New Password",
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                            hintStyle: theme.textTheme.bodyMedium!,
                            textInputType: TextInputType.visiblePassword,
                            prefix: Container(
                                margin:
                                    EdgeInsets.fromLTRB(16.h, 18.v, 8.h, 18.v),
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgOutlineLock)),
                            prefixConstraints: BoxConstraints(maxHeight: 56.v),
                            suffix: Container(
                                margin:
                                    EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgOutlineEye)),
                            suffixConstraints: BoxConstraints(maxHeight: 56.v),
                            obscureText: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 17.v),
                            borderDecoration:
                                TextFormFieldStyleHelper.outlineOnPrimary),
                        SizedBox(height: 24.v),
                        CustomTextFormField(
                            validator: (value) {
                              if (value! != _newpasswordController.text) {
                                return 'Passwords do not match!';
                              } else {
                                return null;
                              }
                            },
                            textStyle: const TextStyle(color: Colors.black),
                            controller: _confirmpasswordController,
                            hintText: "Confirm Password",
                            hintStyle: theme.textTheme.bodyMedium!,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.visiblePassword,
                            prefix: Container(
                                margin:
                                    EdgeInsets.fromLTRB(16.h, 18.v, 8.h, 18.v),
                                child: CustomImageView(
                                    svgPath:
                                        ImageConstant.imgOutlineLockOnprimary)),
                            prefixConstraints: BoxConstraints(maxHeight: 56.v),
                            suffix: Container(
                                margin:
                                    EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgOutlineEye)),
                            suffixConstraints: BoxConstraints(maxHeight: 56.v),
                            obscureText: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 17.v),
                            borderDecoration:
                                TextFormFieldStyleHelper.outlineOnPrimary),
                        SizedBox(height: 40.v),
                        CustomElevatedButton(
                            text: "Sign Up",
                            buttonStyle:
                                CustomButtonStyles.outlineOnPrimaryTL121,
                            onTap: () {
                              _onTapSignup(context);
                            }),
                        SizedBox(height: 23.v),
                        SizedBox(
                            width: 222.h,
                            child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "By clicking Sign Up, you agree to the\n",
                                      style: theme.textTheme.bodySmall),
                                  TextSpan(
                                      text: "Terms of Services",
                                      style: CustomTextStyles
                                          .labelLargePrimarySemiBold),
                                  TextSpan(
                                      text: " and ",
                                      style: theme.textTheme.bodySmall),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: CustomTextStyles
                                          .labelLargePrimarySemiBold)
                                ]),
                                textAlign: TextAlign.center)),
                        SizedBox(height: 30.v),
                        GestureDetector(
                            onTap: () {
                              onTapTxtAlreadyamember(context);
                            },
                            child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Already a member",
                                      style: theme.textTheme.bodyMedium),
                                  TextSpan(
                                      text: "?",
                                      style: theme.textTheme.bodyMedium),
                                  const TextSpan(text: " "),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginOneScreen(),
                                              ),
                                            ),
                                      text: "Log In",
                                      style:
                                          CustomTextStyles.titleSmallPrimary_1)
                                ]),
                                textAlign: TextAlign.left)),
                        SizedBox(height: 19.v)
                      ]))),
              CustomImageView(
                  imagePath: ImageConstant.imgObject247x236,
                  height: 247.v,
                  width: 236.h,
                  alignment: Alignment.topRight),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 28.h, top: 81.v),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusStyle.customBorderTL40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Individual",
                          style: CustomTextStyles.titleMediumPrimary),
                      SizedBox(height: 11.v),
                      Container(
                        height: 5.v,
                        width: 12.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onTapTxtGroupRegister(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 83.v),
                        child: Text("Group Admin",
                            style: CustomTextStyles.titleMediumOnPrimary_2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the registerIndividualVerifyEmailTwoScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the registerIndividualVerifyEmailTwoScreen.
  onTapSignup(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  /// Navigates to the loginOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the loginOneScreen.
  onTapTxtAlreadyamember(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  verifyEmail(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerIndividualVerifyEmailScreen);
  }

  /// Navigates to the setupGAccountOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the setupGAccountOneScreen.
  onTapTxtGroupRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.setupGAccountOneScreen);
  }
}
