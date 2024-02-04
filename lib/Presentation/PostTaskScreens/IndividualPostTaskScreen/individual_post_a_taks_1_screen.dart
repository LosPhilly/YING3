import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class IndividualPostATask1Screen extends StatefulWidget {
  const IndividualPostATask1Screen({Key? key}) : super(key: key);

  @override
  State<IndividualPostATask1Screen> createState() =>
      _IndividualPostATask1ScreenState();
}

class _IndividualPostATask1ScreenState
    extends State<IndividualPostATask1Screen> {
  bool selectedPostContainer = true;
  bool selectedRequestContainer = false;

  // Create an onTap function that creates a popup that shows a set of instructions
  void showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'Post a task to a group or Request a skill from an individual.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          // Add a SingleChildScrollView to prevent overflow
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 180.v),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 27.h, vertical: 8.v),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: fs.Svg(ImageConstant.imgGroup47),
                                  fit: BoxFit.cover)),
                          child: Column(
                            children: [
                              CustomElevatedButton(
                                  onTap: () {
                                    showInstructionsPopup(context);
                                  },
                                  height: 32.v,
                                  width: 68.h,
                                  text: "Help",
                                  buttonStyle: CustomButtonStyles.fillOrange,
                                  buttonTextStyle:
                                      CustomTextStyles.labelLargeDeeporange600),
                              SizedBox(height: 30.v),
                              Text(
                                "Post or Request",
                                style: theme.textTheme.headlineSmall,
                              ),
                              Container(
                                width: 311.h,
                                margin: EdgeInsets.only(
                                    left: 5.h, top: 3.v, right: 4.h),
                                child: Text(
                                    "Post or Request. Start by choosing one of the options",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.bodyMediumOnPrimary
                                        .copyWith(height: 1.70)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 1.h, top: 39.v, right: 1.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    selectedPostContainer == true
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                onTapColumnOutline(context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 7.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.h,
                                                    vertical: 24.v),
                                                decoration: AppDecoration
                                                    .gradientCyanToGreen400014
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadiusStyle
                                                                .roundedBorder16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOutlineshoppingPrimary,
                                                        height: 32.adaptSize,
                                                        width: 32.adaptSize),
                                                    SizedBox(height: 7.v),
                                                    Text("Post Task",
                                                        style: CustomTextStyles
                                                            .titleMediumPrimary18),
                                                    SizedBox(height: 2.v)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                onTapColumnOutline(context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 7.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.h,
                                                    vertical: 24.v),
                                                decoration: AppDecoration
                                                    .outlineOnPrimary
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadiusStyle
                                                                .roundedBorder16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOutlineshoppingOnprimary,
                                                        height: 32.adaptSize,
                                                        width: 32.adaptSize),
                                                    SizedBox(height: 7.v),
                                                    Text("Post Task",
                                                        style: CustomTextStyles
                                                            .titleMediumOnPrimary18_1),
                                                    SizedBox(height: 2.v)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    selectedRequestContainer == true
                                        ? Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                onTapColumnOutline(context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 7.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.h,
                                                    vertical: 24.v),
                                                decoration: AppDecoration
                                                    .gradientCyanToGreen400014
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadiusStyle
                                                                .roundedBorder16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOutlineshoppingPrimary,
                                                        height: 32.adaptSize,
                                                        width: 32.adaptSize),
                                                    SizedBox(height: 7.v),
                                                    Text("Request Skill",
                                                        style: CustomTextStyles
                                                            .titleMediumPrimary18),
                                                    SizedBox(height: 2.v),
                                                    Text("(coming soon)",
                                                        style: CustomTextStyles
                                                            .titleSmallPrimary_1)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                onTapColumnOutline(context);
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 7.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.h,
                                                    vertical: 24.v),
                                                decoration: AppDecoration
                                                    .outlineOnPrimary
                                                    .copyWith(
                                                        borderRadius:
                                                            BorderRadiusStyle
                                                                .roundedBorder16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgOutlineshoppingOnprimary,
                                                        height: 32.adaptSize,
                                                        width: 32.adaptSize),
                                                    SizedBox(height: 7.v),
                                                    Text("Request Skill",
                                                        style: CustomTextStyles
                                                            .titleMediumOnPrimary18_1),
                                                    SizedBox(height: 2.v),
                                                    Text("(coming soon)",
                                                        style: CustomTextStyles
                                                            .titleSmallPrimary),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 33.v),
                              CustomElevatedButton(
                                  height: 48.v,
                                  text: "Proceed",
                                  rightIcon: Container(
                                    margin: EdgeInsets.only(left: 8.h),
                                    child: CustomImageView(
                                        svgPath:
                                            ImageConstant.imgOutlineRightarrow),
                                  ),
                                  buttonStyle:
                                      CustomButtonStyles.fillPrimaryTL12,
                                  onTap: () {
                                    onTapProceed(context);
                                  }),
                              SizedBox(height: 42.v)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the chatsListScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the chatsListScreen.
  onTapSearchone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.gigFeedOneScreen);
  }

  /// Navigates to the taskManagementThreeScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the taskManagementThreeScreen.

  void onTapColumnOutline(BuildContext context) {
    setState(() {
      if (selectedPostContainer) {
        selectedPostContainer = false;
        selectedRequestContainer = !selectedRequestContainer;
      } else {
        selectedPostContainer = !selectedPostContainer;
        selectedRequestContainer = false;
      }
    });
  }

  /// Navigates to the postATaskOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the postATaskOneScreen.
  onTapProceed(BuildContext context) {
    if (selectedPostContainer) {
      Navigator.pushNamed(context, AppRoutes.postATaskOneScreen);
    } else {
      Navigator.pushNamed(context, AppRoutes.userState);
    }
  }
}
