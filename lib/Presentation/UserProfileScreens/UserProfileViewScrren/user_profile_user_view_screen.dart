import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/UserProfileViewScrren/widgets/chipviewchips8_item_widget.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';

import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_3.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';

import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_rating_bar.dart';

// ignore_for_file: must_be_immutable
class UserProfileUserViewScreen extends StatefulWidget {
  final String userId;
  const UserProfileUserViewScreen({super.key, required this.userId});

  @override
  State<UserProfileUserViewScreen> createState() =>
      _UserProfileUserViewScreenState();
}

class _UserProfileUserViewScreenState extends State<UserProfileUserViewScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  onTapImgOutlineburgerme(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.individualMainMenuScreen);
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
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.9,
      child: Scaffold(
        body: SizedBox(
            width: mediaQueryData.size.width,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(left: 28.h, bottom: 24.v, top: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppBar(height: 88.v, actions: [
                            AppbarIconbutton3(
                                svgPath:
                                    ImageConstant.imgOutlinesettingsOnprimary,
                                margin: EdgeInsets.only(
                                  left: 25.h,
                                  top: 30.v,
                                  right: 20.h,
                                ),
                                onTap: () {
                                  onTapOutlinesettings(context);
                                })
                          ]),
                          imageUrl.isEmpty
                              ? const CircularProgressIndicator()
                              : CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(imageUrl),
                                ),
                          SizedBox(height: 17.v),
                          Text(name.toString(),
                              style: CustomTextStyles.titleMediumOnPrimaryBold),
                          SizedBox(height: 4.v),
                          Text("UX/UI Designer",
                              style: theme.textTheme.bodyMedium),
                          CustomElevatedButton(
                              height: 33.v,
                              width: 163.h,
                              text: "My Schedule",
                              margin: EdgeInsets.only(left: 78.h, top: 17.v),
                              buttonStyle: CustomButtonStyles.outlineBlack,
                              buttonTextStyle: CustomTextStyles
                                  .titleSmallPrimaryContainerBold,
                              onTap: () {
                                onTapMyschedule(context);
                              }),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 11.h, top: 34.v, right: 43.h),
                              child: Row(children: [
                                Column(children: [
                                  Text("Completed",
                                      style: theme.textTheme.bodyMedium),
                                  SizedBox(height: 2.v),
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "89 ",
                                            style: CustomTextStyles
                                                .titleMediumOnPrimary18),
                                        TextSpan(
                                            text: "jobs",
                                            style: CustomTextStyles
                                                .bodySmallOnPrimary)
                                      ]),
                                      textAlign: TextAlign.left)
                                ]),
                                Padding(
                                    padding: EdgeInsets.only(left: 31.h),
                                    child: Column(children: [
                                      Text("In Progress",
                                          style: theme.textTheme.bodyMedium),
                                      SizedBox(height: 1.v),
                                      RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "5 ",
                                                style: CustomTextStyles
                                                    .titleMediumOnPrimary18),
                                            TextSpan(
                                                text: "jobs",
                                                style: CustomTextStyles
                                                    .bodySmallOnPrimary)
                                          ]),
                                          textAlign: TextAlign.left)
                                    ])),
                                Padding(
                                    padding: EdgeInsets.only(left: 30.h),
                                    child: Column(children: [
                                      Text("Experience",
                                          style: theme.textTheme.bodyMedium),
                                      SizedBox(height: 2.v),
                                      RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "4.5 ",
                                                style: CustomTextStyles
                                                    .titleMediumOnPrimary18),
                                            TextSpan(
                                                text: "years",
                                                style: CustomTextStyles
                                                    .bodySmallOnPrimary)
                                          ]),
                                          textAlign: TextAlign.left)
                                    ]))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 47.v, right: 28.h),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Skills",
                                        style: theme.textTheme.titleLarge),
                                    CustomImageView(
                                        svgPath: ImageConstant.imgLink,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        margin: EdgeInsets.only(
                                            top: 3.v, bottom: 2.v))
                                  ])),
                          SizedBox(height: 16.v),
                          Wrap(
                              runSpacing: 14.v,
                              spacing: 14.h,
                              children: List<Widget>.generate(
                                  8, (index) => Chipviewchips8ItemWidget())),
                          SizedBox(height: 47.v),
                          Text("Reviews", style: theme.textTheme.titleLarge),
                          SizedBox(height: 16.v),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: IntrinsicWidth(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgLizhangkdwbstxliyunsplash,
                                              height: 148.v,
                                              width: 152.h,
                                              radius:
                                                  BorderRadius.circular(16.h)),
                                          SizedBox(height: 13.v),
                                          Text("Project Name",
                                              style: CustomTextStyles
                                                  .titleMediumOnPrimary),
                                          SizedBox(height: 3.v),
                                          SizedBox(
                                              width: 150.h,
                                              child: Text(
                                                  "Extremely satisfied with the skills Joshua showed!",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: CustomTextStyles
                                                      .bodySmallOnPrimary_1
                                                      .copyWith(height: 1.70))),
                                          SizedBox(height: 10.v),
                                          CustomRatingBar(initialRating: 0)
                                        ]),
                                    Padding(
                                        padding: EdgeInsets.only(left: 15.h),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomImageView(
                                                  imagePath: ImageConstant
                                                      .imgDimgungerokn1,
                                                  height: 148.v,
                                                  width: 152.h,
                                                  radius: BorderRadius.circular(
                                                      16.h)),
                                              SizedBox(height: 13.v),
                                              Text("Project Name",
                                                  style: CustomTextStyles
                                                      .titleMediumOnPrimary),
                                              SizedBox(height: 3.v),
                                              SizedBox(
                                                  width: 150.h,
                                                  child: Text(
                                                      "Extremely satisfied with the skills Joshua showed!",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: CustomTextStyles
                                                          .bodySmallOnPrimary_1
                                                          .copyWith(
                                                              height: 1.70))),
                                              SizedBox(height: 10.v),
                                              CustomRatingBar(initialRating: 0)
                                            ])),
                                    Padding(
                                        padding: EdgeInsets.only(left: 15.h),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomImageView(
                                                  imagePath: ImageConstant
                                                      .imgSimonleexx5rq,
                                                  height: 148.v,
                                                  width: 152.h,
                                                  radius: BorderRadius.circular(
                                                      16.h)),
                                              SizedBox(height: 13.v),
                                              Text("Project Name",
                                                  style: CustomTextStyles
                                                      .titleMediumOnPrimary),
                                              SizedBox(height: 3.v),
                                              SizedBox(
                                                  width: 152.h,
                                                  child: Text(
                                                      "Extremely satisfied with the skills Joshua showed!",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: CustomTextStyles
                                                          .bodySmallOnPrimary_1
                                                          .copyWith(
                                                              height: 1.70))),
                                              SizedBox(height: 10.v),
                                              Row(children: [
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOutlinestarfilled,
                                                    height: 12.adaptSize,
                                                    width: 12.adaptSize),
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOutlinestarfilled,
                                                    height: 12.adaptSize,
                                                    width: 12.adaptSize),
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOutlinestarfilled,
                                                    height: 12.adaptSize,
                                                    width: 12.adaptSize),
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOutlinestarfilled,
                                                    height: 12.adaptSize,
                                                    width: 12.adaptSize),
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOutlinestarBlueGray200,
                                                    height: 12.adaptSize,
                                                    width: 12.adaptSize)
                                              ])
                                            ]))
                                  ])))
                        ])))),
      ),
    );
  }

  /// Navigates to the userProfileSettingsOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileSettingsOneScreen.
  onTapOutlinesettings(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the taskScheduleOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the taskScheduleOneScreen.
  onTapMyschedule(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
