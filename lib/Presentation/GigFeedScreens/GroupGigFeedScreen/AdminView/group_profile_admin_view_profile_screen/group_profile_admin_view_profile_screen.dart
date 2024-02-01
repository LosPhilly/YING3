import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/app_decoration.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton_4.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_2.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_11.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_6.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import '../group_profile_admin_view_profile_screen/widgets/eventpost1_item_widget.dart';
import '../group_profile_admin_view_profile_screen/widgets/imagelist1_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;

// ignore_for_file: must_be_immutable
class GroupProfileAdminViewProfileScreen extends StatefulWidget {
  GroupProfileAdminViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<GroupProfileAdminViewProfileScreen> createState() =>
      _GroupProfileAdminViewProfileScreenState();
}

class _GroupProfileAdminViewProfileScreenState
    extends State<GroupProfileAdminViewProfileScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: CustomAppBar(
        leadingWidth: 192.h,
        leading: AppbarImage1(
          svgPath: ImageConstant.imgGroup36850,
          margin: EdgeInsets.only(top: 2.v, right: 152.h, bottom: 4.v),
        ),
        title: Container(
          margin: EdgeInsets.only(left: 10.h),
          decoration: AppDecoration.column31,
          child: Column(
            children: [
              AppbarSubtitle(
                text: "Ying Co-Working",
                margin: EdgeInsets.only(left: 41.h),
              ),
              AppbarImage2(
                imagePath: ImageConstant.imgYinglogoblack,
                margin: EdgeInsets.only(right: 163.h),
              ),
              AppbarSubtitle6(
                text: "Short Description",
                margin: EdgeInsets.only(left: 41.h, right: 20.h),
              ),
              AppbarSubtitle11(
                text: "YING",
                margin: EdgeInsets.only(left: 1.h, right: 165.h, bottom: 10.v),
              )
            ],
          ),
        ),
        actions: [
          AppbarIconbutton4(
            svgPath: ImageConstant.imgOutlinesettings,
            margin: EdgeInsets.fromLTRB(28.h, 6.v, 28.h, 9.v),
            onTap: () {
              onTapOutlinesettings(context);
            },
          )
        ],
      ),
      body: SizedBox(
          width: double.maxFinite,
          child: Column(children: [
            SizedBox(height: 23.v),
            Expanded(
                child: SizedBox(
                    width: double.maxFinite,
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 23.v),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: fs.Svg(ImageConstant.imgGroup47),
                                fit: BoxFit.cover)),
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 28.h),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: 4.v),
                                        child: Text("Members",
                                            style: CustomTextStyles
                                                .titleMediumOnPrimaryBold)),
                                    CustomElevatedButton(
                                        height: 32.v,
                                        width: 115.h,
                                        text: "Invite Link",
                                        leftIcon: Container(
                                            margin: EdgeInsets.only(right: 6.h),
                                            child: CustomImageView(
                                                svgPath: ImageConstant
                                                    .imgLinkOnprimary)),
                                        buttonStyle: CustomButtonStyles.none,
                                        decoration: CustomButtonStyles
                                            .gradientCyanToGreenDecoration,
                                        buttonTextStyle: CustomTextStyles
                                            .labelLargeOnPrimarySemiBold)
                                  ])),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                      height: 156.v,
                                      child: ListView.separated(
                                          padding: EdgeInsets.only(
                                              left: 28.h, top: 16.v),
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(width: 15.h);
                                          },
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Imagelist1ItemWidget(
                                                onTapImgUserImage: () {
                                              onTapImgUserImage(context);
                                            });
                                          })))),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 28.h, top: 48.v),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadiusStyle
                                                    .customBorderTL40),
                                            child: Column(children: [
                                              Text("Tasks",
                                                  style: CustomTextStyles
                                                      .titleMediumPrimary),
                                              SizedBox(height: 10.v),
                                              Container(
                                                  height: 5.v,
                                                  width: 12.h,
                                                  decoration: BoxDecoration(
                                                      color: theme
                                                          .colorScheme.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.h)))
                                            ])),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 24.h,
                                                top: 2.v,
                                                bottom: 13.v),
                                            child: Text("Group Tasks",
                                                style: CustomTextStyles
                                                    .titleMediumOnPrimary_2))
                                      ]))),
                          Padding(
                              padding:
                                  EdgeInsets.fromLTRB(28.h, 16.v, 28.h, 99.v),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 241.v,
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 15.h,
                                          crossAxisSpacing: 15.h),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Eventpost1ItemWidget(
                                        onTapImgProjectName: () {
                                      onTapImgProjectName(context);
                                    });
                                  }))
                        ]))))
          ])),
    );
  }

  /// Navigates to the groupGigFeedTaskDetailsScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the groupGigFeedTaskDetailsScreen.
  onTapImgProjectName(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the groupProfileClientViewMemberScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the groupProfileClientViewMemberScreen.
  onTapImgUserImage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the groupProfileAdminViewSettingsScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the groupProfileAdminViewSettingsScreen.
  onTapOutlinesettings(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
