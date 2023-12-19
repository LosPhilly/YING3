import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_floating_text_field.dart';
import 'package:random_string/random_string.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore_for_file: must_be_immutable
class SetupGAccountGroupCodeScreen extends StatefulWidget {
  const SetupGAccountGroupCodeScreen({Key? key}) : super(key: key);

  @override
  State<SetupGAccountGroupCodeScreen> createState() =>
      _SetupGAccountGroupCodeScreenState();
}

class GroupData {
  final String? groupName;

  GroupData({this.groupName});
}

class _SetupGAccountGroupCodeScreenState
    extends State<SetupGAccountGroupCodeScreen> {
  final TextEditingController _codeController = TextEditingController(text: '');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? groupDisplayName = '';

  @override
  void initState() {
    getGroupData();
    super.initState();
  }

  @override
  void dispose() {
    getGroupData();
    _codeController.dispose();
    super.dispose();
  }

  /// GET USER DATA
  Future<GroupData?> getGroupData() async {
    try {
      final User? user = _auth.currentUser;
      String uid = user!.uid;

      // Reference to the "users" collection and a specific user document
      var userDocRef = FirebaseFirestore.instance.collection('groups').doc(uid);

      // Get the user document snapshot
      var groupDocSnapshot = await userDocRef.get();

      // Check if the user document exists
      if (groupDocSnapshot.exists) {
        // Access the data within the document
        var groupData = groupDocSnapshot.data() as Map<String, dynamic>;

        // Check if the "imageUrl" and "name" fields exist in the user document

        var groupNameVar = groupData['groupName'] as String?;

        if (groupNameVar != null) {
          setState(() {
            groupDisplayName = groupNameVar;
          });
        } else {
          // ignore: avoid_print
          print('User does not have an name.');
          return null;
        }
      } else {
        // ignore: avoid_print
        print('User document not found.');
        return null;
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error getting user document: $error');
      return null;
    }
    return null;
  }

  /// GET USER DATA END

  deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  deleteGroup() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    await FirebaseFirestore.instance.collection('groups').doc(uid).delete();
  }

  Future<void> deleteUserAndDocument() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Delete user document from Firestore
      deleteUser();
      deleteGroup();

      // Delete user from Firebase Authentication
      await user!.delete();

      // ignore: avoid_print
      print('User and document deleted successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to delete user and document: $e');
    }
  }

  void _randomString() {
    var r = randomAlphaNumeric(6);
    var num = randomAlphaNumeric(2);
    setState(() {
      _codeController.text = '$r-$num';
    });
  }

//SUBMIT SIGN UP FORM START//
  _submitGroupInviteCode(BuildContext context) async {
    try {
      final User? group = _auth.currentUser;
      final uid = group!.uid;

      FirebaseFirestore.instance.collection('groups').doc(uid).update({
        'groupCode': _codeController.text,
      });

      Navigator.pushNamed(context, AppRoutes.setupGAccountOfferingScreen);
    } catch (e) {
      // ignore: avoid_print
      print('Error creating group code: $e');

      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, AppRoutes.welcomeMainScreen);
    }
  }

//SUBMIT SIGN UP FORM END//

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            leadingWidth: double.maxFinite,
            leading: AppbarIconbutton1(
                svgPath: ImageConstant.imgArrowleftOnprimary,
                margin: EdgeInsets.fromLTRB(28.h, 4.v, 299.h, 4.v),
                onTap: () {
                  onTapArrowleftone(context);
                })),
        body: Form(
            key: _formKey,
            child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 6.v),
                child: Column(children: [
                  SizedBox(
                      height: 201.v,
                      width: 236.h,
                      child: Stack(alignment: Alignment.topLeft, children: [
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: 138.v,
                                width: 236.h,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.h, vertical: 5.v),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            fs.Svg(ImageConstant.imgGroup950),
                                        fit: BoxFit.cover)),
                                child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      CustomImageView(
                                          svgPath: ImageConstant.imgTrash,
                                          height: 48.v,
                                          width: 34.h),
                                      CustomImageView(
                                          svgPath: ImageConstant.imgPlants,
                                          height: 36.v,
                                          width: 19.h)
                                    ]))),
                        CustomImageView(
                            svgPath: ImageConstant.imgMailbox,
                            height: 98.v,
                            width: 53.h,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 35.h, top: 29.v)),
                        CustomImageView(
                            svgPath: ImageConstant.imgCharacter,
                            height: 162.v,
                            width: 81.h,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(right: 45.h))
                      ])),
                  SizedBox(height: 43.v),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Setup Group Invite Code",
                          style: theme.textTheme.headlineSmall)),
                  Container(
                      width: 310.h,
                      margin: EdgeInsets.only(top: 12.v, right: 8.h),
                      child: Text(
                          "Generate a random group invite code or create your own",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.bodyMediumOnPrimary
                              .copyWith(height: 1.70))),
                  SizedBox(height: 34.v),
                  CustomFloatingTextField(
                      controller: _codeController,
                      labelText: "Group Code",
                      labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                      hintText: "Generate or Input Group Code",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress),
                  SizedBox(height: 27.v),
                  CustomElevatedButton(
                      text: "Generate Code",
                      buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
                      width: 187.v,
                      onTap: () {
                        _randomString();
                      }),
                  SizedBox(height: 32.v),
                  CustomElevatedButton(
                      text: "Save Code",
                      buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
                      onTap: () {
                        _submitGroupInviteCode(context);
                      }),
                  SizedBox(height: 67.v),
                  GestureDetector(
                      onTap: () {
                        onTapTxtAlreadyamember(context);
                      },
                      child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Already a member?",
                                style: theme.textTheme.bodyLarge),
                            const TextSpan(text: " "),
                            TextSpan(
                                text: "Log In",
                                style: CustomTextStyles.titleMediumPrimary_1)
                          ]),
                          textAlign: TextAlign.left)),
                  SizedBox(height: 5.v)
                ]))));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.welcomeMainScreen);
    deleteUserAndDocument();
  }

  /// Navigates to the setupGAccount3VerifyEmailTwoScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the setupGAccount3VerifyEmailTwoScreen.

  /// Navigates to the loginOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the loginOneScreen.
  onTapTxtAlreadyamember(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }
}
