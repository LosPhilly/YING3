import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:super_tag_editor/widgets/rich_text_widget.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/constants/global_variables.dart';
import 'package:ying_3_3/core/constants/persistant.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import 'skillsList.dart' as skillsList;

// ignore_for_file: must_be_immutable
class PostATaskTwoScreen extends StatefulWidget {
  const PostATaskTwoScreen({Key? key}) : super(key: key);

  @override
  State<PostATaskTwoScreen> createState() => _PostATaskTwoScreenState();
}

class _PostATaskTwoScreenState extends State<PostATaskTwoScreen> {
  final TextEditingController _skillsController = TextEditingController();
  List<String> skills = skillsList.skills;

  final TextEditingController _jobCategoryController =
      TextEditingController(text: 'Select Task Category');

  bool focusTagEnabled = false;

  TextEditingController outlinedownarroController = TextEditingController();

  final List<String> _values = [];

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _jobCategoryController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  //WIDGET FORM FIELDS//

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 98, 54, 255),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 98, 54, 255).withOpacity(0.5),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  //WIDGET FORM FIELDS END//

  /// SHOW CATEGORIES FIELDS ///
  _showTaskCategoriesDialog({required final width}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor:
                const Color.fromARGB(255, 98, 54, 255).withOpacity(0.8),
            title: const Text(
              'Task Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: Container(
              width: width > webScreenSize ? width * 0.2 : width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.taskCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _jobCategoryController.text =
                              Persistent.taskCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.green,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.taskCategoryList[index],
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ))
            ],
          );
        });
  }

  /// SHOW CATEGORIES FIELDS END ///

// Create an onTap function that creates a popup that shows a set of instructions
  void showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'What skills are needed for your task? Just start typing to see a list of task that you can add.'),
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

  //SUBMIT SKILLS START//
  void onTapContinue(BuildContext context) async {
    try {
      List<String> skills = [];
// ignore: prefer_is_empty
      if (_values.length >= 0) {
        for (int i = 0; i < _values.length; i++) {
          skills.add(_values[i]);
        }
      }
      if (_jobCategoryController.text == 'Select Task Category') {
        GlobalMethod.showErrorDialog(
            error: 'Please choose a task category', ctx: context);
        return;
      }

      FirebaseFirestore.instance.collection('tasks').doc(taskIdGlobal).update({
        'skillsNeeded': skills,
        'taskCategory': _jobCategoryController.text,
      });

      Navigator.pushNamed(context, AppRoutes.userState);
    } catch (e) {
      // ignore: avoid_print
      print('Error on set up: $e');

      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      Navigator.pushNamed(context, AppRoutes.postATaskTwoScreen);
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            leadingWidth: double.maxFinite,
            leading: AppbarIconbutton(
                svgPath: ImageConstant.imgArrowleftOnprimary,
                margin: EdgeInsets.fromLTRB(28.h, 8.v, 307.h, 8.v),
                onTap: () {
                  onTapArrowleftone(context);
                })),
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
                  width: 101.h,
                  text: "Post a Task",
                  buttonStyle: CustomButtonStyles.fillOrange,
                  buttonTextStyle: CustomTextStyles.labelLargeDeeporange600),
              Container(
                  width: 257.h,
                  margin: EdgeInsets.only(top: 8.v, right: 61.h),
                  child: Text("What kind of\nskills are needed?",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium!
                          .copyWith(height: 1.50))),
              Container(
                  width: 286.h,
                  margin: EdgeInsets.only(top: 8.v, right: 32.h),
                  child: Text("Type at least one skill, separate with comma.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          theme.textTheme.bodyLarge!.copyWith(height: 1.64))),
              SizedBox(height: 34.v),
              SizedBox(height: 18.v),
              Wrap(
                children: [
                  _textTitles(label: 'Task Category :'),
                  _textFormFields(
                      valueKey: 'TaskCategory',
                      controller: _jobCategoryController,
                      enabled: false,
                      fct: () {
                        _showTaskCategoriesDialog(
                            width: width > webScreenSize
                                ? width * 0.2
                                : width * 0.9);
                      },
                      maxLength: 100),
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
                            color:
                                focusTagEnabled && index == _values.length - 1
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
                          suggestionBuilder: (context, state, data, index,
                              length, highlight, suggestionValid) {
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
                                        color: theme.focusColor,
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
                                    .compareTo(b
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)));
                            }
                            return [];
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.v),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 6.v,
                      child: AnimatedSmoothIndicator(
                          activeIndex: 1,
                          count: 3,
                          axisDirection: Axis.horizontal,
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
            buttonStyle: CustomButtonStyles.fillPrimary,
            margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 66.v),
            rightIcon: Container(
                margin: EdgeInsets.only(left: 8.h),
                child: CustomImageView(
                    svgPath: ImageConstant.imgOutlineRightarrow)),
            onTap: () {
              onTapContinue(context);
            }));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  /// Navigates to the postATaskThreeScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the postATaskThreeScreen.
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
