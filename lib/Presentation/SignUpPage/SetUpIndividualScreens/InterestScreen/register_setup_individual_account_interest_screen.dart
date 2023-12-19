import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import '../InterestScreen/widgets/checkbox_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';

class RegisterSetupIndividualAccountInterestScreen extends StatefulWidget {
  const RegisterSetupIndividualAccountInterestScreen({Key? key})
      : super(key: key);

  @override
  State<RegisterSetupIndividualAccountInterestScreen> createState() =>
      _RegisterSetupIndividualAccountInterestScreenState();
}

class _RegisterSetupIndividualAccountInterestScreenState
    extends State<RegisterSetupIndividualAccountInterestScreen> {
  List<String> checkedItems = [];

  Future<void> deleteUserAndDocument() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;

      // Delete user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Delete user from Firebase Authentication
      await user.delete();

      // ignore: avoid_print
      print('User and document deleted successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to delete user and document: $e');
    }
  }

  List<String> generateRandomSkills() {
    List<String> skills = [
      "Graphic Design",
      "Web Development",
      "Data Science",
      "Mobile App Development"
    ];
    // Shuffle the list to get a random order
    return skills;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void continueToSkills(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerIndividualSkillsScreen);
  }

//SUBMIT SKILLS START//
  void onTapContinue(BuildContext context) async {
    try {
      final User? user = _auth.currentUser;
      final uid = user!.uid;

      List<dynamic> interests = [];

      // ignore: prefer_is_empty
      if (checkedItems.length >= 0) {
        for (int i = 0; i < checkedItems.length; i++) {
          interests.add(checkedItems[i]);
        }
      }

      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'interest': interests, // Add the skills list to Firestore
      });

      continueToSkills(context);
    } catch (e) {
      // ignore: avoid_print
      print('Error on set up: $e');
      deleteUserAndDocument();
      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      Navigator.pushNamed(context, AppRoutes.welcomeMainScreen);
    }
  }

//SUBMIT SKILLS END//

  @override
  Widget build(BuildContext context) {
    List<String> randomSkills = generateRandomSkills();
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
          leadingWidth: 68.h,
          leading: AppbarIconbutton(
              svgPath: ImageConstant.imgArrowleftOnprimary,
              margin: EdgeInsets.only(left: 28.h, top: 8.v, bottom: 8.v),
              onTap: () {
                onTapArrowleftone(context);
              }),
          actions: [
            AppbarButton(
                margin: EdgeInsets.symmetric(horizontal: 28.h, vertical: 8.v),
                onTap: () {
                  onTapSkip(context);
                })
          ]),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 20.v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomElevatedButton(
                height: 32.v,
                width: 68.h,
                text: "Setup",
                buttonStyle: CustomButtonStyles.fillOrange,
                buttonTextStyle: CustomTextStyles.labelLargeDeeporange600),
            SizedBox(height: 9.v),
            SizedBox(
                width: 197.h,
                child: Text("What are you interested in?",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineMedium!
                        .copyWith(height: 1.50))),
            Container(
              width: 286.h,
              margin: EdgeInsets.only(top: 8.v, right: 32.h),
              child: Text(
                "Please choose at least one from the following items to get started.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge!.copyWith(height: 1.64),
              ),
            ),
            SizedBox(height: 29.v),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20.v);
                },
                itemCount: randomSkills.length,
                itemBuilder: (context, index) {
                  return CheckboxItemWidget(
                    skill: randomSkills[index],
                    onChecked: (isChecked, itemText) {
                      setState(() {
                        if (isChecked) {
                          if (checkedItems.length < 3) {
                            checkedItems.add(itemText);
                          } else {
                            // Display a message when the user tries to check more than 3 items
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('You can only check up to 3 items.'),
                              ),
                            );
                          }
                        } else {
                          checkedItems.remove(itemText);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            // Access checkedItems list here or use it in other parts of your widget
            SizedBox(height: 26.v),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 6.v,
                child: AnimatedSmoothIndicator(
                  activeIndex: 0,
                  count: 4,
                  effect: ScrollingDotsEffect(
                      spacing: 8,
                      activeDotColor: theme.colorScheme.primary,
                      dotColor: appTheme.cyan700.withOpacity(0.5),
                      dotHeight: 6.v,
                      dotWidth: 6.h),
                ),
              ),
            ),
            SizedBox(height: 5.v)
          ],
        ),
      ),
      bottomNavigationBar: CustomElevatedButton(
        buttonStyle: CustomButtonStyles.fillPrimary,
        text: "Continue",
        margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 36.v),
        rightIcon: Container(
            margin: EdgeInsets.only(left: 8.h),
            child:
                CustomImageView(svgPath: ImageConstant.imgOutlineRightarrow)),
        onTap: () {
          onTapContinue(context);
        },
      ),
    );
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerIndividualOneScreen);
    deleteUserAndDocument();
  }

  /// Navigates to the gigFeed1FeedScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed1FeedScreen.
  void onTapSkip(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  /// Navigates to the registerSetupIndividualAccountFiveScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the registerSetupIndividualAccountFiveScreen.
}
