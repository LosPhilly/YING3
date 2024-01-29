import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:super_tag_editor/widgets/rich_text_widget.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
// ignore: library_prefixes
import '../../../../widgets/custom_text_form_field.dart';
import 'skillsList.dart' as skillsList;

// ignore_for_file: must_be_immutable
class RegisterSetupIndividualAccountSkillsScreen extends StatefulWidget {
  const RegisterSetupIndividualAccountSkillsScreen({Key? key})
      : super(key: key);

  @override
  State<RegisterSetupIndividualAccountSkillsScreen> createState() =>
      _RegisterSetupIndividualAccountSkillsScreenState();
}

class _RegisterSetupIndividualAccountSkillsScreenState
    extends State<RegisterSetupIndividualAccountSkillsScreen> {
  final TextEditingController _skillsController = TextEditingController();
  List<String> skills = skillsList.skills;

  bool focusTagEnabled = false;

  TextEditingController outlinedownarroController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  final List<String> _values = ["Other"];

  final FocusNode _focusNode = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _focusNode.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  //SUBMIT SKILLS START//
  void onTapContinue(BuildContext context) async {
    try {
      final User? user = _auth.currentUser;
      final uid = user!.uid;

      List<String> skills = [];
// ignore: prefer_is_empty
      if (_values.length >= 0) {
        for (int i = 0; i < _values.length; i++) {
          skills.add(_values[i]);
        }
      }
      if (skills.isNotEmpty) skills.removeLast();

      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'skills': skills,
      });

      continueToAvailability(context);
    } catch (e) {
      // ignore: avoid_print
      print('Error on set up: $e');

      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      Navigator.pushNamed(context, AppRoutes.welcomeMainScreen);
    }
  }

//SUBMIT SKILLS END//

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  bool othervisible = false;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomElevatedButton(
              height: 32.v,
              width: 68.h,
              text: "Setup",
              buttonStyle: CustomButtonStyles.fillOrange,
              buttonTextStyle: CustomTextStyles.labelLargeDeeporange600),
          SizedBox(height: 1.v),
          SizedBox(
            height: 132.v,
            width: 286.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 277.h,
                    child: Text(
                      "What skills would you like to share?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium!
                          .copyWith(height: 1.50),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 286.h,
                    child: Text(
                      "Type at least one skill, separate with comma.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge!.copyWith(height: 1.64),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 34.v),
          DropDownSearchField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _skillsController,
                minLines: 1,
                autofocus: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: 17.v, right: 15.h, left: 15.h, bottom: 17.v),
                  label: Text(
                    "Add SKills",
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: appTheme.indigoA200,
                        fontWeight: FontWeight.w600),
                  ),
                  border: TextFormFieldStyleHelper.outlineOnindigo,
                  enabledBorder: TextFormFieldStyleHelper.outlineOnindigo,
                  focusedBorder: TextFormFieldStyleHelper.outlineOnindigo,
                )),
            suggestionsCallback: (pattern) async {
              return await _filterSearchResults(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                // leading: Icon(Icons.shopping_cart),
                title: Text(suggestion.toString()),
                // subtitle: Text('\$${suggestion['price']}'),
              );
            },
            onSuggestionSelected: (suggestion) {
              _values.insert(0, suggestion.toString());
              _skillsController.clear();
            },
            displayAllSuggestionWhenTap: false,
          ),
          SizedBox(height: 20.v),
          Wrap(
            runSpacing: 5.0,
            spacing: 8.0,
            clipBehavior: Clip.hardEdge,
            children: [
              for (var i in _values)
                Container(
                  color: i.toString() == "Other"
                      ? appTheme.gray300
                      : appTheme.green40001.withOpacity(.10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          i.toString(),
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontSize: 12,
                            color: appTheme.black900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (i.toString() == "Other") {
                              setState(() {
                                othervisible = true;
                              });
                            } else {
                              setState(() {
                                _values.remove(i.toString());
                              });
                            }
                          },
                          child: i.toString() == "Other"
                              ? const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 20,
                                )
                              : Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appTheme.green800),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.v),
          othervisible
              ? CustomTextFormField(
                  textStyle: const TextStyle(color: Colors.black),
                  autofocus: true,
                  controller: _otherController,
                  // hintText: "Full name",
                  hintStyle: theme.textTheme.bodyMedium!,
                  label: "Other",
                  lableStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: appTheme.indigoA200, fontWeight: FontWeight.w600),
                  prefixConstraints: BoxConstraints(maxHeight: 56.v),
                  contentPadding: EdgeInsets.only(
                      top: 17.v, right: 15.h, left: 15.h, bottom: 17.v),
                  borderDecoration: TextFormFieldStyleHelper.outlineOnindigo,
                  suffix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _values.insert(0, _otherController.text);
                            _otherController.clear();
                          });
                        },
                        child: Text(
                          "Add",
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: appTheme.indigoA200,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),

                  onchange: (val) {
                    _filterSearchResults(val);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field Missing';
                    } else {
                      return null;
                    }
                  },
                )
              : Container(),
        ]),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 36.v),
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                  height: 6.v,
                  child: AnimatedSmoothIndicator(
                      activeIndex: 1,
                      count: 3,
                      effect: ScrollingDotsEffect(
                          spacing: 8,
                          activeDotColor: theme.colorScheme.primary,
                          dotColor: appTheme.cyan700.withOpacity(0.5),
                          dotHeight: 6.v,
                          dotWidth: 6.h)))),
          SizedBox(height: 15.v),
          CustomElevatedButton(
              text: "Continue",
              buttonStyle: CustomButtonStyles.fillPrimary,
              margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 10.v),
              rightIcon: Container(
                  margin: EdgeInsets.only(left: 8.h),
                  child: CustomImageView(
                      svgPath: ImageConstant.imgOutlineRightarrow)),
              onTap: () {
                onTapContinue(context);
              }),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 71.h, vertical: 15.v),
            decoration: AppDecoration.outlineOnPrimary3
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                    svgPath: ImageConstant.imgOutlineinfocrfrOnprimary,
                    height: 24.adaptSize,
                    width: 24.adaptSize),
                SizedBox(
                  width: 5.v,
                ),
                Text("Skills Assessment",
                    style: CustomTextStyles.titleMediumOnPrimary_1)
              ],
            ),
          ),
          SizedBox(height: 15.v)
        ],
      ),
    );
  }

  _filterSearchResults(query) {
    if (query.isNotEmpty) {
      var lowercaseQuery = query.toLowerCase();
      return skills.where((profile) {
        return profile.toLowerCase().contains(query.toLowerCase()) ||
            profile.toLowerCase().contains(query.toLowerCase());
      }).toList(growable: false)
        ..sort((a, b) => a
            .toLowerCase()
            .indexOf(lowercaseQuery)
            .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
    }

    return [];
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.registerIndividualOneScreen);
    deleteUserAndDocument();
  }

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

  /// Navigates to the gigFeed1FeedScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed1FeedScreen.
  onTapSkip(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.registerIndividualAvailabilityScreen);
  }

  continueToAvailability(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.registerIndividualAvailabilityScreen);
  }

  /// Navigates to the registerSetupIndividualAccountSixScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the registerSetupIndividualAccountSixScreen.
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
