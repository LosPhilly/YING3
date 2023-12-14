import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_3.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_floating_text_field.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/core/utils/openai/api_key.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ying_3_3/core/constants/global_variables.dart';

// ignore_for_file: must_be_immutable

class PostATaskOneScreen extends StatefulWidget {
  const PostATaskOneScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostATaskOneScreenState createState() => _PostATaskOneScreenState();
}

class _PostATaskOneScreenState extends State<PostATaskOneScreen> {
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskAiTitleControler = TextEditingController();

  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController taskAiDescriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  TextEditingController locationController = TextEditingController();
  String locationPicked = '';
  TextEditingController peopleNeededController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String taskNameLabel = "Task Name";

  DateTime? startDate;
  DateTime? endDate;
  String startDateString = '';
  List<DateTime>? startEndDateList = [];

  late GoogleMapController mapController;

  bool selectedPostContainer = true;
  bool selectedRequestContainer = false;

// POST A TASK SUBMIT //
  Future<void> _uploadTask() async {
    final taskId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    int peopleNeededValue = int.parse(peopleNeededController.text);

    if (isValid) {
      if (taskTitleController.text.isEmpty ||
          taskDescriptionController.text.isEmpty ||
          locationController.text.isEmpty ||
          peopleNeededController.text.isEmpty) {
        GlobalMethod.showErrorDialog(
            error: 'Please fill in the fields', ctx: context);
        return;
      }
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).set({
          'taskId': taskId,
          'uploadedBy': _uid,
          'email': user.email,
          'taskTitle': taskTitleController.text,
          'taskDescription': taskDescriptionController.text,
          'taskStartDate': startDate,
          'taskEndDate': endDate,
          'createAt': Timestamp.now(),
          'userName': userName,
          'userImage': userImage,
          'applicantsNeeded': peopleNeededValue,
          'applicants': 0,
          'applicantsList': [],
          'skillsNeeded': [],
          'invites': [],
          'likes': [],
          'taskCompleationTime': '',
          'location': locationController.text,
          'recruitment': true,
          'taskCategory': '',
          'taskComments': [],
        });

        await Fluttertoast.showToast(
          msg: 'Task uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          fontSize: 18,
        );

        setState(() {
          taskIdGlobal = taskId;
        });
        startDateString = "";
        taskAiDescriptionController.clear();
        taskAiTitleControler.clear();
        taskTitleController.clear();
        taskDescriptionController.clear();
        startDateController.clear();
        locationController.clear();
        peopleNeededController.clear();
        onTapContinue();
      } catch (error) {
        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    } else {
      print('Is not valid');
    }
  }

// POST A TASK SUBMIT END //

// GET USER DATA END //

// Create an onTap function that creates a popup that shows a set of instructions
  void showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Text(
              'To get started create a task name, task description, choose your date and time, the location of the task and the number of people you will need.'),
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

  // DATE TIME PICKER//
  dateTimePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    setState(() {
      startDate = dateTimeList?[0];
      endDate = dateTimeList?[1];
      startDateString = startDate.toString();
      startEndDateList!.add(dateTimeList![0]);
      startEndDateList!.add(dateTimeList[1]);
    });

    print("Start dateTime: ${dateTimeList?[0]}");
    print("End dateTime: ${dateTimeList?[1]}");
    print("Controller dateTime: $startDateString");
  }

  // DATE TIME PICKER END //

  onTapGetLocation(BuildContext context) {
    // Call the function to update the location controller

    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (_) => FlutterLocationPicker(
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              trackMyPosition: true,
              searchBarBackgroundColor: Colors.white,
              selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
              mapLanguage: 'en',
              onError: (e) => print(e),
              selectLocationButtonLeadingIcon: const Icon(Icons.check),
              onPicked: (pickedData) {
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData.address);
                print(pickedData.addressData);

                setState(() {
                  locationPicked = pickedData.address;
                  locationController.text = pickedData.address;
                });

                Navigator.pop(context);
              },
              onChanged: (pickedData) {
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData.address);
                print(pickedData.addressData);
              },
              showContributorBadgeForOSM: true,
            ),
        isScrollControlled: true);
  }

  onTapContinue() {
    Navigator.pushNamed(context, AppRoutes.postATaskTwoScreen);
  }

  @override
  Widget build(BuildContext context) {
    // Set the OpenAI API key from the .env file.
    OpenAI.apiKey = openAIApiKey;

    void createTitle(BuildContext context) async {
      final titleAi = await OpenAI.instance.completion.create(
        model: "text-davinci-003",
        maxTokens: 24,
        prompt:
            "create a gig title for someone looking for help using the example of \"Need Help to Setup Yoga Class\" or \"Need Design Animations for Event\" do not use quotes, and use the following: ${taskTitleController.text}",
      );
      setState(() {
        taskAiTitleControler.text = titleAi.choices[0].text.trim();

        taskTitleController = taskAiTitleControler;
      });
      print(taskAiTitleControler.text);
    }

    void createDescription(BuildContext context) async {
      final descriptionAi = await OpenAI.instance.completion.create(
        model: "text-davinci-003",
        maxTokens: 164,
        prompt:
            "create a gig description for someone looking for help using the example of \"Hey! I am putting on a yoga classes this S...\" or \"Hi, I want animations designed for fundrasing...\" do not use quotes: ${taskTitleController.text}",
      );
      setState(() {
        taskAiDescriptionController.text = descriptionAi.choices[0].text.trim();
        taskDescriptionController = taskAiDescriptionController;
      });
      print(taskAiDescriptionController.text);
    }

    void createDescriptionFromTitle(BuildContext context) async {
      final descriptionAi = await OpenAI.instance.completion.create(
        model: "text-davinci-003",
        maxTokens: 164,
        prompt:
            "create a gig description for someone looking for help using the example of \"Hey! I am putting on a yoga classes this S...\" or \"Hi, I want animations designed for fundrasing...\" do not use quotes: ${taskDescriptionController.text}",
      );
      setState(() {
        taskAiDescriptionController.text = descriptionAi.choices[0].text.trim();
        taskDescriptionController = taskAiDescriptionController;
      });
      print(taskAiDescriptionController.text);
    }

    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: 788.v,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.v),
                  decoration: AppDecoration.fillPrimary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAppBar(
                        height: 24.v,
                        leadingWidth: 52.h,
                        leading: AppbarImage1(
                            svgPath: ImageConstant.imgArrowleftPrimarycontainer,
                            margin: EdgeInsets.only(left: 28.h),
                            onTap: () {
                              onTapArrowleftone(context);
                            }),
                        centerTitle: true,
                        title: AppbarSubtitle3(text: "Post a Task"),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CustomElevatedButton(
                                onTap: () {
                                  showInstructionsPopup(context);
                                },
                                height: 32.v,
                                width: 58.h,
                                text: "Help",
                                buttonStyle: CustomButtonStyles.fillOrange,
                                buttonTextStyle:
                                    CustomTextStyles.labelLargeDeeporange600),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.h, vertical: 11.v),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.h, vertical: 4.v),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusStyle.roundedBorder12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 1.v),
                            SizedBox(
                              width: 323.h,
                              child: Text(
                                "Once posted, this request will live on the\nopportunities board on the group homepage.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: CustomTextStyles
                                    .titleSmallPrimaryContainer_1
                                    .copyWith(height: 1.70),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: fs.Svg(ImageConstant.imgGroup47),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomFloatingTextField(
                        maxLines: 1,
                        margin:
                            EdgeInsets.only(left: 28.h, top: 24.v, right: 28.h),
                        controller: taskTitleController,
                        suffix: GestureDetector(
                          onTap: () {
                            createTitle(context);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
                            child: const Icon(Icons.generating_tokens_sharp),
                          ),
                        ),
                        suffixConstraints: BoxConstraints(maxHeight: 56.v),
                        labelText: taskTitleController.text.isEmpty
                            ? "Task Name"
                            : taskAiTitleControler.text.isEmpty
                                ? taskNameLabel
                                : taskTitleController.text.trim(),
                        labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                      ),
                      CustomFloatingTextField(
                          autofocus: true,
                          maxLines: 3,
                          margin: EdgeInsets.only(
                              left: 28.h, top: 20.v, right: 28.h),
                          controller: taskDescriptionController,
                          labelText: taskDescriptionController.text.isEmpty
                              ? "Task Description"
                              : taskAiDescriptionController.text.isEmpty
                                  ? "Task Description"
                                  : taskDescriptionController.text,
                          labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                          hintText: "Task Description Hint",
                          hintStyle: theme.textTheme.bodyMedium!,
                          suffix: GestureDetector(
                            onTap: () {
                              taskDescriptionController.text.isEmpty
                                  ? createDescriptionFromTitle(context)
                                  : taskAiDescriptionController.text.isEmpty
                                      ? createDescriptionFromTitle(context)
                                      : createDescription(context);
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
                              child: const Icon(Icons.generating_tokens_sharp),
                            ),
                          ),
                          suffixConstraints: BoxConstraints(maxHeight: 56.v),
                          contentPadding:
                              EdgeInsets.fromLTRB(16.h, 19.v, 16.h, 64.v)),
                      CustomFloatingTextField(
                          maxLines: 1,
                          suffix: GestureDetector(
                            onTap: () {
                              dateTimePicker();
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
                              child: const Icon(Icons.calendar_month),
                            ),
                          ),
                          suffixConstraints: BoxConstraints(maxHeight: 56.v),
                          autofocus: true,
                          margin: EdgeInsets.only(
                              left: 28.h, top: 20.v, right: 28.h),
                          controller: startDateController,
                          labelText: startDateString.isEmpty
                              ? "Date and Time"
                              : startDateString,
                          labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                          hintText: "Date and Time Hint",
                          hintStyle: theme.textTheme.bodyMedium!),
                      CustomFloatingTextField(
                          margin: EdgeInsets.only(
                              left: 28.h, top: 20.v, right: 28.h),
                          controller: locationController,
                          suffix: GestureDetector(
                            onTap: () {
                              onTapGetLocation(context);
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 18.v, 16.h, 18.v),
                              child: const Icon(Icons.location_pin),
                            ),
                          ),
                          suffixConstraints: BoxConstraints(maxHeight: 56.v),
                          labelText: locationPicked.isEmpty
                              ? "Location"
                              : locationPicked,
                          labelStyle: theme.textTheme.bodyMedium!,
                          hintText: "Location",
                          hintStyle: theme.textTheme.bodyMedium!),
                      CustomFloatingTextField(
                          margin: EdgeInsets.only(
                              left: 28.h, top: 20.v, right: 28.h),
                          controller: peopleNeededController,
                          labelText: "Number of people needed",
                          labelStyle: theme.textTheme.bodyMedium!,
                          hintText: "Number of people needed",
                          hintStyle: theme.textTheme.bodyMedium!,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.number),
                      SizedBox(height: 31.v),
                      SizedBox(
                        height: 6.v,
                        child: AnimatedSmoothIndicator(
                          activeIndex: 0,
                          count: 3,
                          effect: ScrollingDotsEffect(
                              spacing: 8,
                              activeDotColor: theme.colorScheme.primary,
                              dotColor: appTheme.cyan700.withOpacity(0.5),
                              dotHeight: 6.v,
                              dotWidth: 6.h),
                        ),
                      ),
                      SizedBox(height: 15.v),
                      SizedBox(
                        height: 52.v,
                        width: double.maxFinite,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 98.v,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer
                                      .withOpacity(1),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24.h)),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            appTheme.black900.withOpacity(0.05),
                                        spreadRadius: 2.h,
                                        blurRadius: 2.h,
                                        offset: const Offset(0, -3))
                                  ],
                                ),
                              ),
                            ),
                            CustomElevatedButton(
                                width: 319.h,
                                text: "Continue",
                                buttonStyle: CustomButtonStyles.fillPrimary,
                                rightIcon: Container(
                                    margin: EdgeInsets.only(left: 8.h),
                                    child: CustomImageView(
                                        svgPath: ImageConstant
                                            .imgOutlineRightarrow)),
                                onTap: () {
                                  _uploadTask();
                                },
                                alignment: Alignment.topCenter)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
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

  /// Shows a modal bottom sheet with [PostATaskAvailableDaysOneBottomsheet]
  /// widget content.
  /// The sheet is displayed on top of the current view with scrolling enabled if
  /// content exceeds viewport height.
}
