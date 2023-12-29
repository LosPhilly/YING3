import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_page.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_4.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_bottom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_search_view.dart';
import 'package:ying_3_3/widgets/custom_switch.dart';

// ignore_for_file: must_be_immutable
class AccountSettingsScreen extends StatefulWidget {
  AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  TextEditingController searchController = TextEditingController();

  bool isSelectedSwitch = false;

  bool isSelectedSwitch1 = false;

  bool isSelectedSwitch2 = false;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          height: 49.v,
          leadingWidth: 52.h,
          leading: AppbarImage1(
              svgPath: ImageConstant.imgArrowleft,
              margin: EdgeInsets.only(left: 28.h, top: 12.v, bottom: 13.v),
              onTap: () {
                onTapArrowleftone(context);
              }),
          centerTitle: true,
          title: AppbarSubtitle4(text: "Account Settings")),
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 10.v),
          child: Column(children: [
            CustomSearchView(
                margin: EdgeInsets.symmetric(horizontal: 28.h),
                controller: searchController,
                hintText: "Search",
                prefix: Container(
                    margin: EdgeInsets.fromLTRB(16.h, 10.v, 8.h, 10.v),
                    child: CustomImageView(svgPath: ImageConstant.imgSearch)),
                prefixConstraints: BoxConstraints(maxHeight: 40.v),
                suffix: Padding(
                    padding: EdgeInsets.only(right: 15.h),
                    child: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(Icons.clear, color: Colors.grey.shade600)))),
            GestureDetector(
                onTap: () {
                  onTapRowoutlineactiv(context);
                },
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 28.h, top: 28.v, right: 28.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                              svgPath:
                                  ImageConstant.imgOutlineactivityOnprimary,
                              height: 24.adaptSize,
                              width: 24.adaptSize),
                          Padding(
                              padding: EdgeInsets.only(left: 20.h, top: 3.v),
                              child: Text("My Schedule",
                                  style:
                                      CustomTextStyles.bodyMediumOnPrimary_3)),
                          Spacer(),
                          CustomImageView(
                              svgPath:
                                  ImageConstant.imgOutlinerightarrowOnprimary,
                              height: 24.adaptSize,
                              width: 24.adaptSize)
                        ]))),
            Padding(
                padding: EdgeInsets.only(left: 28.h, top: 27.v, right: 28.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlinebankcardOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize),
                  Padding(
                      padding: EdgeInsets.only(left: 20.h, top: 3.v),
                      child: Text("My Cards",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlinerightarrowOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize)
                ])),
            Padding(
                padding: EdgeInsets.only(left: 28.h, top: 27.v, right: 28.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlineshoppingOnprimary24x24,
                      height: 24.adaptSize,
                      width: 24.adaptSize),
                  Padding(
                      padding: EdgeInsets.only(left: 20.h, top: 2.v),
                      child: Text("My Transactions",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlinerightarrowOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize)
                ])),
            Padding(
                padding: EdgeInsets.only(left: 28.h, top: 28.v, right: 28.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlineeyeOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize),
                  Padding(
                      padding: EdgeInsets.only(left: 20.h, top: 2.v),
                      child: Text("Privacy",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlinerightarrowOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize)
                ])),
            Padding(
                padding: EdgeInsets.only(left: 28.h, top: 28.v, right: 28.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlineinfocrfrOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize),
                  Padding(
                      padding: EdgeInsets.only(left: 20.h, top: 3.v),
                      child: Text("Help",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomImageView(
                      svgPath: ImageConstant.imgOutlinerightarrowOnprimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize)
                ])),
            SizedBox(height: 27.v),
            Divider(),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 24.h, top: 27.v),
                    child: Text("Permissions",
                        style: CustomTextStyles.titleMediumOnPrimaryBold))),
            Padding(
                padding: EdgeInsets.only(left: 24.h, top: 19.v, right: 24.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomIconButton(
                      height: 44.adaptSize,
                      width: 44.adaptSize,
                      padding: EdgeInsets.all(12.h),
                      decoration: IconButtonStyleHelper.gradientCyanToGreenTL16,
                      child: CustomImageView(
                          svgPath: ImageConstant.imgOutlinebellPrimary)),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 16.h, top: 11.v, bottom: 11.v),
                      child: Text("Push Notifications",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomSwitch(
                      margin: EdgeInsets.symmetric(vertical: 10.v),
                      value: isSelectedSwitch,
                      onChange: (value) {
                        isSelectedSwitch = value;
                      })
                ])),
            Padding(
                padding: EdgeInsets.only(left: 24.h, top: 20.v, right: 24.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomIconButton(
                      height: 44.adaptSize,
                      width: 44.adaptSize,
                      padding: EdgeInsets.all(12.h),
                      decoration: IconButtonStyleHelper.gradientCyanToGreenTL16,
                      child: CustomImageView(
                          svgPath: ImageConstant.imgOutlinechat)),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 16.h, top: 11.v, bottom: 11.v),
                      child: Text("SMS Notifications",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomSwitch(
                      margin: EdgeInsets.symmetric(vertical: 10.v),
                      value: isSelectedSwitch1,
                      onChange: (value) {
                        isSelectedSwitch1 = value;
                      })
                ])),
            Padding(
                padding: EdgeInsets.fromLTRB(24.h, 20.v, 24.h, 24.v),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomIconButton(
                      height: 44.adaptSize,
                      width: 44.adaptSize,
                      padding: EdgeInsets.all(12.h),
                      decoration: IconButtonStyleHelper.gradientCyanToGreenTL16,
                      child: CustomImageView(
                          svgPath: ImageConstant.imgMailPrimary)),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 16.h, top: 11.v, bottom: 11.v),
                      child: Text("Email Notifications",
                          style: CustomTextStyles.bodyMediumOnPrimary_3)),
                  Spacer(),
                  CustomSwitch(
                      margin: EdgeInsets.symmetric(vertical: 10.v),
                      value: isSelectedSwitch2,
                      onChange: (value) {
                        isSelectedSwitch2 = value;
                      })
                ]))
          ])),
    );
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the taskScheduleOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the taskScheduleOneScreen.
  onTapRowoutlineactiv(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
