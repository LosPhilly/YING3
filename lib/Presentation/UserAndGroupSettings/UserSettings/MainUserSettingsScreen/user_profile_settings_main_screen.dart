import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/GroupGigFeedScreen/AdminView/group_profile_admin_view_profile_screen/group_profile_admin_view_profile_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/AccountSettingsScreen/account_settings_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/BankAccountTabScreen/BankAccountTabScreen/my_cards_bank_account_tab_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PersonalDataScreen/user_profile_settings_data_screen.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_7.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';

import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/core/app_export.dart';

import 'package:ying_3_3/widgets/settings_menu.dart';

// ignore_for_file: must_be_immutable
class UserProfileSettingsMainScreen extends StatefulWidget {
  final String userId;
  const UserProfileSettingsMainScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  State<UserProfileSettingsMainScreen> createState() =>
      _UserProfileSettingsMainScreenState();
}

class _UserProfileSettingsMainScreenState
    extends State<UserProfileSettingsMainScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  List<List> intrestList = [];
  String? imageUrl = '';
  String? uid = '';
  String? joinedAt = '';
  //bool _isLoading = false;
  bool _isSameUser = false;

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserData() async {
    try {
      //_isLoading = true;
      User? user = _auth.currentUser;
      final _uid = user!.uid;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      setState(() {
        name = userDoc.get('name');
        email = userDoc.get('email');
        imageUrl = userDoc.get('userImage');
        uid = userDoc.get('id');
        Timestamp joinedAtTimeStamp = userDoc.get('createdAt');

        dynamic intrestData = userDoc.get('interest');
        intrestList.add(intrestData);

        var joinedDate = joinedAtTimeStamp.toDate();
        joinedAt =
            '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';

        _isSameUser = _uid == widget.userId;
      });

      /* print(name);
      print(email);
      print(imageUrl);
      print(uid);
      print(joinedAt); */

      // ignore: empty_catches
    } catch (error) {} /* finally {
      _isLoading = false;
    } */
  }

  /// to navigate back to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  onTapAccountSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          AccountSettingsScreen(), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  onTapPaymentSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          const MyCardsBankAccountTabScreen(), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  onTapPersonalData(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserProfileSettingsDataScreen(
        userId: _auth.currentUser!.uid,
      ), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  onTapMyGroups(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          GroupProfileAdminViewProfileScreen(), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 157.v,
              width: 347.h,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgObject240x227,
                      height: 165.v,
                      width: 137.h,
                      alignment: Alignment.centerRight),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomAppBar(
                      height: 77.v,
                      leadingWidth: 76.h,
                      leading: imageUrl!.isNotEmpty
                          ? CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(imageUrl!),
                            )
                          : const CircularProgressIndicator(),
                      title: Padding(
                        padding: EdgeInsets.only(left: 12.h),
                        child: Column(
                          children: [
                            AppbarSubtitle1(
                              text: name.toString(),
                              margin: EdgeInsets.only(right: 3.h),
                            ),
                            AppbarSubtitle7(
                                text: intrestList.isEmpty
                                    ? 'Loading..'
                                    : intrestList[0][0].toString())
                          ],
                        ),
                      ),
                      actions: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppbarIconbutton(
                              svgPath: ImageConstant.imgArrowleftOnprimary,
                              margin: EdgeInsets.only(
                                  left: 5.h,
                                  top: 8.v,
                                  bottom: 8.v,
                                  right: 20.v),
                              onTap: () {
                                onTapArrowleftone(context);
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 115.v),
                        child: SizedBox(
                          width: 319.h,
                          child: const Divider(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.v),
            Column(
              children: [
                buildSectionTitle("Settings"),
                buildSpacer(),
                buildMenuItem(
                  label: "Personal data",
                  svgPath: ImageConstant.imgOutlineuserOnprimarycontainer,
                  onTap: () => onTapPersonalData(context),
                ),
                buildSpacer(),
                buildMenuItem(
                  label: "Account Settings",
                  svgPath: ImageConstant.imgOutlinesettingsIndigo400,
                  onTap: () => onTapAccountSettings(context),
                ),
                buildSpacer(),
                buildSectionTitle("Payments"),
                buildMenuItem(
                  label: "Payments",
                  svgPath: ImageConstant.imgOutlinebankcardPurple400,
                  onTap: () => onTapPaymentSettings(context),
                ),
                buildSpacer(),
                buildSectionTitle("Group Settings"),
                buildMenuItem(
                  label: "My Groups",
                  svgPath: ImageConstant.imgOutlineheartYellow900,
                  onTap: () => onTapMyGroups(context),
                ),
              ],
            ),
            SizedBox(height: 28.v),
            CustomElevatedButton(
                height: 64.v,
                text: "Feel free to ask, we ready to help",
                leftIcon: Container(
                    margin: EdgeInsets.only(right: 12.h),
                    child: CustomImageView(
                        svgPath: ImageConstant.imgDuetoneInfoCrfr)),
                buttonStyle: CustomButtonStyles.none,
                decoration:
                    CustomButtonStyles.gradientCyanToGreenTL16Decoration,
                buttonTextStyle: CustomTextStyles.labelLargePrimary)
          ],
        ),
      ),
    );
  }

  /// Navigates to the userProfileSettingsTwoScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileSettingsTwoScreen.

  onTapBasiclist(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserProfileSettingsDataScreen(
          userId:
              uid!), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  /// Navigates to the accountSettingsOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the accountSettingsOneScreen.

  /// Navigates to the userProfileYingProfileScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileYingProfileScreen.
  onTapBasiclist2(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
