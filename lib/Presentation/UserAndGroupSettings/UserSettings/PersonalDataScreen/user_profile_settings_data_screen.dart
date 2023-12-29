import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_4.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_floating_text_field.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_outlined_button.dart';

// ignore_for_file: must_be_immutable
class UserProfileSettingsDataScreen extends StatefulWidget {
  const UserProfileSettingsDataScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileSettingsDataScreen> createState() =>
      _UserProfileSettingsDataScreenState();
}

class _UserProfileSettingsDataScreenState
    extends State<UserProfileSettingsDataScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();

  TextEditingController yourJobController = TextEditingController();

  TextEditingController availabilityvalController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          height: 48.v,
          leadingWidth: 52.h,
          leading: AppbarImage1(
              svgPath: ImageConstant.imgArrowleft,
              margin: EdgeInsets.only(left: 28.h, top: 12.v, bottom: 12.v),
              onTap: () {
                onTapArrowleftone(context);
              }),
          centerTitle: true,
          title: AppbarSubtitle4(text: "Personal Data")),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(27.h),
          child: Column(
            children: [
              CustomImageView(
                  imagePath: ImageConstant.imgEllipse1596x96,
                  height: 96.adaptSize,
                  width: 96.adaptSize,
                  radius: BorderRadius.circular(48.h)),
              SizedBox(height: 16.v),
              CustomOutlinedButton(width: 143.h, text: "Change Picture"),
              SizedBox(height: 40.v),
              CustomFloatingTextField(
                  controller: nameController,
                  labelText: "Your Name",
                  labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                  hintText: "Your Name"),
              SizedBox(height: 24.v),
              CustomFloatingTextField(
                  controller: dateOfBirthController,
                  labelText: "Date of Birth",
                  labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                  hintText: "Date of Birth",
                  suffix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      child: CustomImageView(
                          svgPath: ImageConstant.imgOutlineDownarrow)),
                  suffixConstraints: BoxConstraints(maxHeight: 66.v)),
              SizedBox(height: 24.v),
              CustomFloatingTextField(
                  controller: yourJobController,
                  labelText: "Your Job",
                  labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                  hintText: "Your Job"),
              SizedBox(height: 24.v),
              CustomFloatingTextField(
                  controller: availabilityvalController,
                  labelText: "Availability",
                  labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                  hintText: "Availability",
                  textInputAction: TextInputAction.done,
                  suffix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      child: CustomImageView(
                          svgPath: ImageConstant.imgOutlineDownarrow)),
                  suffixConstraints: BoxConstraints(maxHeight: 66.v)),
              CustomElevatedButton(
                  height: 48.v,
                  text: "Save ",
                  margin: EdgeInsets.only(top: 37.v, right: 10.h, bottom: 5.v),
                  buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                  onTap: () {
                    onTapSave(context);
                  },
                  alignment: Alignment.centerLeft)
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the userProfileSettingsOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileSettingsOneScreen.
  onTapSave(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userProfileSettingsMainScreen);
  }
}
