import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/AccountSettingsScreen/account_settings_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/my_cards_bank_account_tab_container_screen/my_cards_bank_account_screen.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PersonalDataScreen/user_profile_settings_data_screen.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_circleimage_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_7.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_page.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_circleimage_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_7.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_bottom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';

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
  String imageUrl = '';
  String uid = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc == null) {
        return CircularProgressIndicator();
      } else {
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
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
      // ignore: empty_catches
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  /// to navigate back to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
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
          const MyCardsBankAccountScreen(), // Replace YourNewPage with the actual page you want to navigate to
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
              height: 247.v,
              width: 347.h,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgObject240x227,
                      height: 240.v,
                      width: 227.h,
                      alignment: Alignment.centerRight),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 115.v),
                      child: SizedBox(
                        width: 319.h,
                        child: const Divider(),
                      ),
                    ),
                  ),
                  CustomAppBar(
                    height: 77.v,
                    leadingWidth: 76.h,
                    leading: imageUrl.isEmpty
                        ? const CircularProgressIndicator()
                        : CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
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
                                left: 5.h, top: 8.v, bottom: 8.v, right: 20.v),
                            onTap: () {
                              onTapArrowleftone(context);
                            }),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () {
                        onTapBasiclist(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 135.v, right: 30.h, bottom: 68.v),
                        child: Row(
                          children: [
                            CustomIconButton(
                                height: 44.adaptSize,
                                width: 44.adaptSize,
                                padding: EdgeInsets.all(12.h),
                                decoration: IconButtonStyleHelper.fillGray,
                                child: CustomImageView(
                                    svgPath: ImageConstant
                                        .imgOutlineuserOnprimarycontainer)),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.h, top: 11.v, bottom: 11.v),
                              child: Text("Personal data",
                                  style:
                                      CustomTextStyles.bodyMediumOnPrimary_3),
                            ),
                            Spacer(),
                            CustomImageView(
                                svgPath:
                                    ImageConstant.imgOutlinerightarrowOnprimary,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 10.v))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () {
                        onTapAccountSettings(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 203.v, right: 30.h),
                        child: Row(
                          children: [
                            CustomIconButton(
                                height: 44.adaptSize,
                                width: 44.adaptSize,
                                padding: EdgeInsets.all(12.h),
                                decoration:
                                    IconButtonStyleHelper.fillLightBlueTL16,
                                child: CustomImageView(
                                    svgPath: ImageConstant
                                        .imgOutlinesettingsIndigo400)),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 16.h, top: 13.v, bottom: 9.v),
                                child: Text("Account Settings",
                                    style: CustomTextStyles
                                        .bodyMediumOnPrimary_3)),
                            Spacer(),
                            CustomImageView(
                              svgPath:
                                  ImageConstant.imgOutlinerightarrowOnprimary,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.only(top: 10.v, bottom: 9.v),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24.v),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 28.h, right: 28.h, bottom: 5.v),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(12.h),
                              decoration: IconButtonStyleHelper.fillPurpleTL16,
                              child: CustomImageView(
                                  svgPath: ImageConstant
                                      .imgOutlinebankcardPurple400),
                            ),
                            GestureDetector(
                              onTap: () {
                                onTapPaymentSettings(context);
                              },
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.h, top: 13.v, bottom: 9.v),
                                  child: Text("Payments",
                                      style: CustomTextStyles
                                          .bodyMediumOnPrimary_3)),
                            ),
                            Spacer(),
                            CustomImageView(
                              svgPath:
                                  ImageConstant.imgOutlinerightarrowOnprimary,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.only(top: 10.v, bottom: 9.v),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.v, right: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(12.h),
                              decoration: IconButtonStyleHelper.fillOrange,
                              child: CustomImageView(
                                  svgPath:
                                      ImageConstant.imgOutlineheartYellow900),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.h, top: 13.v, bottom: 9.v),
                              child: Text("My Groups",
                                  style:
                                      CustomTextStyles.bodyMediumOnPrimary_3),
                            ),
                            Spacer(),
                            CustomImageView(
                                svgPath:
                                    ImageConstant.imgOutlinerightarrowOnprimary,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.only(top: 10.v, bottom: 9.v))
                          ],
                        ),
                      ),
                      SizedBox(height: 28.v),
                      Divider(),
                      GestureDetector(
                        onTap: () {
                          onTapBasiclist2(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 28.v, right: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconButton(
                                  height: 44.adaptSize,
                                  width: 44.adaptSize,
                                  padding: EdgeInsets.all(12.h),
                                  decoration: IconButtonStyleHelper
                                      .gradientCyanToGreenTL16,
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgInfo)),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.h, top: 11.v, bottom: 11.v),
                                  child: Text("About YING",
                                      style: CustomTextStyles
                                          .bodyMediumOnPrimary_3)),
                              Spacer(),
                              CustomImageView(
                                  svgPath: ImageConstant
                                      .imgOutlinerightarrowOnprimary,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize,
                                  margin: EdgeInsets.symmetric(vertical: 10.v))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.v, right: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                                height: 44.adaptSize,
                                width: 44.adaptSize,
                                padding: EdgeInsets.all(12.h),
                                decoration: IconButtonStyleHelper
                                    .gradientCyanToGreenTL16,
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgLink)),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 16.h, top: 11.v, bottom: 11.v),
                                child: Text("Handbook",
                                    style: CustomTextStyles
                                        .bodyMediumOnPrimary_3)),
                            Spacer(),
                            CustomImageView(
                                svgPath:
                                    ImageConstant.imgOutlinerightarrowOnprimary,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 10.v))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.v, right: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                                height: 44.adaptSize,
                                width: 44.adaptSize,
                                padding: EdgeInsets.all(12.h),
                                decoration: IconButtonStyleHelper
                                    .gradientCyanToGreenTL16,
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgOutlinechattext)),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 16.h, top: 12.v, bottom: 10.v),
                                child: Text("Community",
                                    style: CustomTextStyles
                                        .bodyMediumOnPrimary_3)),
                            Spacer(),
                            CustomImageView(
                                svgPath:
                                    ImageConstant.imgOutlinerightarrowOnprimary,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 10.v))
                          ],
                        ),
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
                          decoration: CustomButtonStyles
                              .gradientCyanToGreenTL16Decoration,
                          buttonTextStyle: CustomTextStyles.labelLargePrimary)
                    ],
                  ),
                ),
              ),
            )
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
              uid), // Replace YourNewPage with the actual page you want to navigate to
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
