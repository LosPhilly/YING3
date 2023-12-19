import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:super_tag_editor/tag_editor.dart';
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
import 'package:ying_3_3/widgets/custom_image_view.dart';
// ignore: library_prefixes
import 'skillsList.dart' as skillsList;

// ignore_for_file: must_be_immutable
class SetupGAccountSkillsListScreen extends StatefulWidget {
  const SetupGAccountSkillsListScreen({Key? key}) : super(key: key);

  @override
  State<SetupGAccountSkillsListScreen> createState() =>
      _SetupGAccountSkillsListScreenState();
}

class GroupData {
  final String? groupInformation;

  GroupData({this.groupInformation});
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

class _SetupGAccountSkillsListScreenState
    extends State<SetupGAccountSkillsListScreen> {
  TextEditingController addskillsvalueController = TextEditingController();

  TextEditingController otherTwoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String groupDisplayName = '';

  final List<String> _values = [];
  bool focusTagEnabled = false;
  final TextEditingController _skillsController = TextEditingController();
  List<String> skills = skillsList.skills;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    getGroupData();
    super.initState();
  }

  @override
  void dispose() {
    getGroupData();
    super.dispose();
  }

// Create an onTap function that creates a popup that shows a set of instructions
  void showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Setup Instructions'),
          content: const Text('Choose some skills that your group offers.'),
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

  void continueToGroupPhotoUpload(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.setupGAccountUploadProfilePictureScreen);
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

      FirebaseFirestore.instance.collection('groups').doc(uid).update({
        'groupSkills': skills,
      });

      continueToGroupPhotoUpload(context);
    } catch (e) {
      // ignore: avoid_print
      print('Error on set up: $e');

      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
    }
  }

//SUBMIT SKILLS END//

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

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
              },
            )
          ]),
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 20.v),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomElevatedButton(
                onTap: () {
                  showInstructionsPopup(context);
                },
                height: 32.v,
                width: 68.h,
                text: "Setup",
                buttonStyle: CustomButtonStyles.fillOrange,
                buttonTextStyle: CustomTextStyles.labelLargeDeeporange600),
            Container(
              width: 444.h,
              margin: EdgeInsets.only(top: 9.v, right: 74.h),
              child: Text(
                "What skills does $groupDisplayName offer?",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium!.copyWith(height: 1.50),
              ),
            ),
            Container(
                width: 326.h,
                margin: EdgeInsets.only(top: 8.v, right: 32.h),
                child: Text("Type at least one skill, separate with comma.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge!.copyWith(height: 1.64))),
            SizedBox(height: 34.v),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true, // Set shrinkWrap to true
                    children: <Widget>[
                      TagEditor<String>(
                        length: _values.length,
                        controller: _skillsController,
                        focusNode: _focusNode,
                        delimiters: const [',', ' '],
                        hasAddButton: true,
                        resetTextOnSubmitted: true,
                        textStyle: const TextStyle(color: Colors.grey),
                        onSubmitted: (outstandingValue) {
                          setState(() {
                            _values.add(outstandingValue);
                          });
                        },
                        inputDecoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add Skills...',
                        ),
                        onTagChanged: (newValue) {
                          setState(() {
                            _values.add(newValue);
                          });
                        },
                        tagBuilder: (context, index) => Container(
                          color: focusTagEnabled && index == _values.length - 1
                              ? Colors.redAccent
                              : Colors.white,
                          child: _Chip(
                            index: index,
                            label: _values[index],
                            onDeleted: _onDelete,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                        ],
                        useDefaultHighlight: false,
                        suggestionBuilder: (context, state, data, index, length,
                            highlight, suggestionValid) {
                          var borderRadius =
                              const BorderRadius.all(Radius.circular(20));
                          if (index == 0) {
                            borderRadius = const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            );
                          } else if (index == length - 1) {
                            borderRadius = const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _values.add(data);
                              });
                              state.resetTextField();
                              state.closeSuggestionBox();
                            },
                            child: Container(
                              decoration: highlight
                                  ? BoxDecoration(
                                      color: Theme.of(context).focusColor,
                                      borderRadius: borderRadius)
                                  : null,
                              padding: const EdgeInsets.all(16),
                              child: RichTextWidget(
                                wordSearched: suggestionValid ?? '',
                                textOrigin: data,
                              ),
                            ),
                          );
                        },
                        onFocusTagAction: (focused) {
                          setState(() {
                            focusTagEnabled = focused;
                          });
                        },
                        onDeleteTagAction: () {
                          if (_values.isNotEmpty) {
                            setState(() {
                              _values.removeLast();
                            });
                          }
                        },
                        onSelectOptionAction: (item) {
                          setState(() {
                            _values.add(item);
                          });
                        },
                        suggestionsBoxElevation: 10,
                        findSuggestions: (String query) {
                          if (query.isNotEmpty) {
                            var lowercaseQuery = query.toLowerCase();
                            return skills.where((profile) {
                              return profile
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  profile
                                      .toLowerCase()
                                      .contains(query.toLowerCase());
                            }).toList(growable: false)
                              ..sort((a, b) => a
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)
                                  .compareTo(
                                      b.toLowerCase().indexOf(lowercaseQuery)));
                          }
                          return [];
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            SizedBox(height: 5.v)
          ])),
      bottomNavigationBar: CustomElevatedButton(
        text: "Continue",
        margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 66.v),
        buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
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
  onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.setupGAccountOfferingScreen);
  }

  /// Navigates to the gigFeed1FeedScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed1FeedScreen.
  onTapSkip(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.setupGAccountUploadProfilePictureScreen);
  }

  /// Navigates to the setupGAccountSixScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the setupGAccountSixScreen.
  //onTapContinue(BuildContext context) {
  //   Navigator.pushNamed(context, AppRoutes.setupGAccountSixScreen);
  // }
}
