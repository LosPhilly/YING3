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
class SetupGAccountOneScreen extends StatefulWidget {
  const SetupGAccountOneScreen({Key? key}) : super(key: key);

  @override
  State<SetupGAccountOneScreen> createState() => _SetupGAccountOneScreenState();
}

class _SetupGAccountOneScreenState extends State<SetupGAccountOneScreen> {
  final TextEditingController _adminNameController = TextEditingController();

  final TextEditingController _groupNameController = TextEditingController();

  final TextEditingController _emailControllerGroup = TextEditingController();

  TextEditingController newpasswordController = TextEditingController();

  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _adminNameController.dispose();
    _emailControllerGroup.dispose();
    newpasswordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  //SUBMIT SIGN UP FORM START//
  _submitGroupFormOnSignUp(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailControllerGroup.text.trim().toLowerCase(),
          password: _confirmpasswordController.text.trim(),
        );
        final User? user = _auth.currentUser;
        final uid = user!.uid;

        await FirebaseFirestore.instance.collection('groups').doc(uid).set({
          'id': uid,
          'groupName': _groupNameController.text,
          'adminName': _adminNameController.text,
          'email': _emailControllerGroup.text,
          'password': _confirmpasswordController.text,
          'createdAt': Timestamp.now(),
          'groupCode': '',
          'groupOffering': [],
          'groupSkills': [],
          'groupImage': '',
          'user': 'group',
        });

        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': _adminNameController.text,
          'email': _emailControllerGroup.text,
          'password': _confirmpasswordController.text,
          'createdAt': Timestamp.now(),
          'groupsIn': [_groupNameController.text],
          'interest': [],
          'skills': [],
          'daysAvailable': [],
          'timesAvailable': [],
          'locationPreference': [],
          'userImage': '',
          'user': 'individual',
          'isOnline': true,
          'lastActive': DateTime.now(),
        });

        // ignore: use_build_context_synchronously
        verifyEmail(context);
      } catch (e) {
        print('Error creating group: $e');

        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, AppRoutes.loginOneScreen);
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
                height: 830.v,
                width: double.maxFinite,
                child: Stack(alignment: Alignment.topLeft, children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.h, vertical: 26.v),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: fs.Svg(ImageConstant.imgGroup5),
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Sign up Group",
                                  style: theme.textTheme.headlineMedium)),
                          SizedBox(height: 21.v),
                          CustomTextFormField(
                              controller: _groupNameController,
                              textStyle: const TextStyle(color: Colors.black),
                              hintText: "Group name",
                              hintStyle: theme.textTheme.bodyMedium!,
                              prefix: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      16.h, 18.v, 8.h, 18.v),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgOutlineUser)),
                              prefixConstraints:
                                  BoxConstraints(maxHeight: 56.v),
                              borderDecoration:
                                  TextFormFieldStyleHelper.outlineOnPrimary),
                          SizedBox(height: 24.v),
                          CustomTextFormField(
                            textStyle: const TextStyle(color: Colors.black),
                            controller: _adminNameController,
                            hintText: "Group Admin name",
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
                              controller: _emailControllerGroup,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                              textStyle: const TextStyle(color: Colors.black),
                              hintText: "Email address",
                              hintStyle: theme.textTheme.bodyMedium!,
                              textInputType: TextInputType.emailAddress,
                              prefix: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      16.h, 18.v, 8.h, 18.v),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgMail)),
                              prefixConstraints:
                                  BoxConstraints(maxHeight: 56.v),
                              contentPadding: EdgeInsets.only(
                                  top: 17.v, right: 30.h, bottom: 17.v),
                              borderDecoration:
                                  TextFormFieldStyleHelper.outlineOnPrimary),
                          SizedBox(height: 24.v),
                          CustomTextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Please enter a valid password';
                                } else {
                                  return null;
                                }
                              },
                              controller: newpasswordController,
                              textStyle: const TextStyle(color: Colors.black),
                              hintText: "New Password",
                              hintStyle: theme.textTheme.bodyMedium!,
                              textInputType: TextInputType.visiblePassword,
                              prefix: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      16.h, 18.v, 8.h, 18.v),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgOutlineLock)),
                              prefixConstraints:
                                  BoxConstraints(maxHeight: 56.v),
                              suffix: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      30.h, 18.v, 16.h, 18.v),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgOutlineEye)),
                              suffixConstraints:
                                  BoxConstraints(maxHeight: 56.v),
                              obscureText: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 17.v),
                              borderDecoration:
                                  TextFormFieldStyleHelper.outlineOnPrimary),
                          SizedBox(height: 24.v),
                          CustomTextFormField(
                              validator: (value) {
                                if (value! != newpasswordController.text) {
                                  return 'Passwords do not match!';
                                } else {
                                  return null;
                                }
                              },
                              controller: _confirmpasswordController,
                              textStyle: const TextStyle(color: Colors.black),
                              hintText: "Confirm Password",
                              hintStyle: theme.textTheme.bodyMedium!,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.visiblePassword,
                              prefix: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      16.h, 18.v, 8.h, 18.v),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgOutlineLock)),
                              prefixConstraints:
                                  BoxConstraints(maxHeight: 56.v),
                              suffix: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      30.h, 18.v, 16.h, 18.v),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgOutlineEye)),
                              suffixConstraints:
                                  BoxConstraints(maxHeight: 56.v),
                              obscureText: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 17.v),
                              borderDecoration:
                                  TextFormFieldStyleHelper.outlineOnPrimary),
                          SizedBox(height: 40.v),
                          CustomElevatedButton(
                              text: "Sign Up Group",
                              buttonStyle:
                                  CustomButtonStyles.outlineOnPrimaryTL121,
                              onTap: () {
                                _submitGroupFormOnSignUp(context);
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
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(height: 30.v),
                          GestureDetector(
                              onTap: () {
                                onTapTxtAlreadyamember(context);
                              },
                              child: RichText(
                                  text: TextSpan(
                                    children: [
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
                                                        const LoginOneScreen(),
                                                  ),
                                                ),
                                          text: "Log In",
                                          style: CustomTextStyles
                                              .titleSmallPrimary_1)
                                    ],
                                  ),
                                  textAlign: TextAlign.left)),
                          SizedBox(height: 19.v)
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                          onTap: () {
                            onTapTxtSignUpIndividual(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 28.h, top: 81.v),
                              child: Text("Individual",
                                  style: CustomTextStyles
                                      .titleMediumOnPrimary_2)))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 133.h, top: 83.v, right: 133.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.customBorderTL40),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Text("Group Admin",
                                style: CustomTextStyles.titleMediumPrimary),
                            SizedBox(height: 9.v),
                            Container(
                                height: 5.v,
                                width: 12.h,
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2.h)))
                          ]))),
                  Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 247.v,
                          width: 236.h,
                          child:
                              Stack(alignment: Alignment.topRight, children: [
                            CustomImageView(
                                imagePath: ImageConstant.imgObject247x236,
                                height: 254.v,
                                width: 268.h,
                                alignment: Alignment.topRight),
                          ])))
                ]))));
  }

  /// Navigates to the setupGAccount2VerifyEmailOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the setupGAccount2VerifyEmailOneScreen.

  /// Navigates to the loginOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the loginOneScreen.
  onTapTxtAlreadyamember(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  onTapTxtSignUpIndividual(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerIndividualOneScreen);
  }

  verifyEmail(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.setupGAccountVerifyEmailScreen);
  }

  /// Navigates to the registerIndividualOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the registerIndividualOneScreen.
  onTapTxtSignin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }
}
