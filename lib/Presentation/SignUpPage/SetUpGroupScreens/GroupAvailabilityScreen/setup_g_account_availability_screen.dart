// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import '../../../../widgets/calender.dart';
import '../../../../widgets/calenderHeader.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../GroupSetUpSkillsAvaiable/setup_g_account_skills_screen.dart';

class SetupGAccountAvailabilityScreen extends StatefulWidget {
  const SetupGAccountAvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<SetupGAccountAvailabilityScreen> createState() =>
      _SetupGAccountAvailabilityScreenState();
}

class UserData {
  final String? userName;

  UserData({this.userName});
}

class _SetupGAccountAvailabilityScreenState
    extends State<SetupGAccountAvailabilityScreen> {
  TextEditingController weekdayController = TextEditingController();
  TextEditingController availableDaysController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  TextEditingController locationController = TextEditingController();
  String? groupDisplayName = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// GET USER DATA
  Future<GroupData?> getGroupData() async {
    try {
      final User? user = _auth.currentUser;
      String uid = user!.uid;

      var userDocRef = FirebaseFirestore.instance.collection('groups').doc(uid);

      var groupDocSnapshot = await userDocRef.get();

      if (groupDocSnapshot.exists) {
        var groupData = groupDocSnapshot.data() as Map<String, dynamic>;

        var groupNameVar = groupData['groupName'] as String?;

        if (groupNameVar != null) {
          setState(() {
            groupDisplayName = groupNameVar;
          });
        } else {
          print('User does not have an name.');
        }
      } else {
        print('User document not found.');
      }
    } catch (error) {
      print('Error getting user document: $error');
    }
    return null;
  }

  @override
  void initState() {
    getGroupData();
    super.initState();
  }

  @override
  void dispose() {
    weekdayController.dispose();
    timeController.dispose();
    locationController.dispose();
    getGroupData();
    super.dispose();
  }

// We start with all days selected.
  final values = List.filled(7, false);

  final List<String> timesAvailable = [
    'Early Morning',
    'Late Morning',
    'Early Afternoon',
    'Late Afternoon',
    'Early Evening',
    'Late Evening',
    'Flexible',
  ];

  final List<String> locationPreference = [
    'I can Travel',
    'Video calls only',
    'Flexible',
  ];

  List<String> selectedTimes = [];
  List<String> selectedLocation = [];

//SUBMIT SKILLS START//
  void onTapContinue(BuildContext context) async {
    try {
      final User? user = _auth.currentUser;
      final uid = user!.uid;

      List<String> timesAvailable = [];
      for (var i = 0; i < selectedTimes.length && i < 7; i++) {
        timesAvailable.add(selectedTimes[i]);
      }

      List<String> locationAvailable = [];
      int maxLocations = 3;
      int selectedLocationLength = selectedLocation.length;

      for (int i = 0; i < maxLocations && i < selectedLocationLength; i++) {
        locationAvailable.add(selectedLocation[i]);
      }

      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'daysAvailable': availableDaysController.text,
        'timesAvailable': timeController.text,
        'locationPreference': locationController.text,
      });

      continueToGroupPhotoUpload(context);
    } catch (e) {
      print('Error on set up: $e');

      GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      Navigator.pushNamed(context, AppRoutes.welcomeMainScreen);
    }
  }

//SUBMIT SKILLS END//

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomElevatedButton(
                  onTap: () {},
                  height: 32.v,
                  width: 68.h,
                  text: "Setup",
                  buttonStyle: CustomButtonStyles.fillOrange,
                  buttonTextStyle: CustomTextStyles.labelLargeDeeporange600),
              SizedBox(height: 10.v),
              Text("Set $groupDisplayName availability",
                  style: theme.textTheme.headlineMedium),
              Container(
                width: 301.h,
                margin: EdgeInsets.only(top: 7.v, right: 17.h),
                child: Text(
                  "This will inform people the specifics of your availability to help.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge!.copyWith(height: 1.64),
                ),
              ),
              SizedBox(height: 30.v),
              // Text("Choose the days you are available:",
              //     style: theme.textTheme.labelLarge),
              // SizedBox(height: 10.v),
              // WeekdaySelector(
              //   // add in the days  displayedDays:
              //   color: theme.colorScheme.primary,
              //   firstDayOfWeek: DateTime.sunday,
              //   selectedFillColor: theme.colorScheme.primary,
              //   onChanged: (int day) {
              //     setState(() {
              //       // Use module % 7 as Sunday's index in the array is 0 and
              //       // DateTime.sunday constant integer value is 7.
              //       final index = day % 7;
              //       // We "flip" the value in this example, but you may also
              //       // perform validation, a DB write, an HTTP call or anything
              //       // else before you actually flip the value,
              //       // it's up to your app's needs.
              //       values[index] = !values[index];
              //     });
              //   },
              //   values: values,
              // ),
              // SizedBox(height: 20.v),
              CustomTextFormField(
                textStyle: const TextStyle(color: Colors.black),
                autofocus: true,
                readOnly: true,
                onTap: () {
                  onAvailableDaysTap();
                },
                controller: availableDaysController,
                // hintText: "Full name",
                hintStyle: theme.textTheme.bodyMedium!,
                label: "Available Days",
                lableStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.indigoA200, fontWeight: FontWeight.w600),
                prefixConstraints: BoxConstraints(maxHeight: 56.v),
                contentPadding: EdgeInsets.only(
                    top: 17.v, right: 15.h, left: 15.h, bottom: 17.v),
                borderDecoration: TextFormFieldStyleHelper.outlineOnindigo,

                onchange: (val) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field Missing';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20.v),

              // SELECT TIME START //

              // Notes:
              // Make the time more specific, actual times

              // Text("Choose the times you are available:",
              //     style: theme.textTheme.labelLarge),
              SizedBox(height: 10.v),
              CustomTextFormField(
                textStyle: const TextStyle(color: Colors.black),
                autofocus: true,
                readOnly: true,
                onTap: () {
                  onDateTap();
                },
                controller: timeController,
                // hintText: "Full name",
                hintStyle: theme.textTheme.bodyMedium!,
                label: "Available Times",
                lableStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.indigoA200, fontWeight: FontWeight.w600),
                prefixConstraints: BoxConstraints(maxHeight: 56.v),
                contentPadding: EdgeInsets.only(
                    top: 17.v, right: 15.h, left: 15.h, bottom: 17.v),
                borderDecoration: TextFormFieldStyleHelper.outlineOnindigo,

                onchange: (val) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field Missing';
                  } else {
                    return null;
                  }
                },
              ),
              // Center(
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton2<String>(
              //       isExpanded: true,
              //       hint: Text(
              //         'Select Times',
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Theme.of(context).hintColor,
              //         ),
              //       ),
              //       items: timesAvailable.map((item) {
              //         return DropdownMenuItem(
              //           value: item,
              //           //disable default onTap to avoid closing menu when selecting an item
              //           enabled: false,
              //           child: StatefulBuilder(
              //             builder: (context, menuSetState) {
              //               final isSelected = selectedTimes.contains(item);
              //               return InkWell(
              //                 onTap: () {
              //                   isSelected
              //                       ? selectedTimes.remove(item)
              //                       : selectedTimes.add(item);
              //                   //This rebuilds the StatefulWidget to update the button's text
              //                   setState(() {});
              //                   //This rebuilds the dropdownMenu Widget to update the check mark
              //                   menuSetState(() {});
              //                 },
              //                 child: Container(
              //                   height: double.infinity,
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 16.0),
              //                   child: Row(
              //                     children: [
              //                       if (isSelected)
              //                         const Icon(Icons.check_box_outlined)
              //                       else
              //                         const Icon(Icons.check_box_outline_blank),
              //                       const SizedBox(width: 16),
              //                       Expanded(
              //                         child: Text(
              //                           item,
              //                           style: const TextStyle(
              //                               fontSize: 14, color: Colors.black),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         );
              //       }).toList(),
              //       //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
              //       value: selectedTimes.isEmpty ? null : selectedTimes.last,
              //       onChanged: (value) {},
              //       selectedItemBuilder: (context) {
              //         return timesAvailable.map(
              //           (item) {
              //             return Container(
              //               alignment: AlignmentDirectional.center,
              //               child: Text(
              //                 selectedTimes.join(', '),
              //                 style: const TextStyle(
              //                     fontSize: 14,
              //                     overflow: TextOverflow.ellipsis,
              //                     color: Colors.black),
              //                 maxLines: 5,
              //               ),
              //             );
              //           },
              //         ).toList();
              //       },
              //       buttonStyleData: ButtonStyleData(
              //         padding: const EdgeInsets.only(left: 10, right: 5),
              //         height: 50,
              //         width: 340,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(12.h),
              //           ),
              //           border: Border.all(color: theme.colorScheme.primary),
              //         ),
              //         overlayColor: MaterialStateProperty.all<Color>(
              //             theme.colorScheme.primary),
              //       ),
              //       menuItemStyleData: const MenuItemStyleData(
              //         height: 40,
              //         padding: EdgeInsets.zero,
              //       ),
              //     ),
              //   ),
              // ),
              // SELECT TIME END //
              SizedBox(height: 20.v),

              // LOCATION PREFERENCE START //

              // Text("Choose your location preference:",
              //     style: theme.textTheme.labelLarge),
              SizedBox(height: 10.v),
              CustomTextFormField(
                textStyle: const TextStyle(color: Colors.black),
                autofocus: true,
                readOnly: true,
                onTap: () {
                  onLocationap();
                },
                controller: locationController,
                // hintText: "Full name",
                hintStyle: theme.textTheme.bodyMedium!,
                label: "Locations",
                lableStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.indigoA200, fontWeight: FontWeight.w600),
                prefixConstraints: BoxConstraints(maxHeight: 56.v),
                contentPadding: EdgeInsets.only(
                    top: 17.v, right: 15.h, left: 15.h, bottom: 17.v),
                borderDecoration: TextFormFieldStyleHelper.outlineOnindigo,

                onchange: (val) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field Missing';
                  } else {
                    return null;
                  }
                },
              ),
              // Center(
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton2<String>(
              //       isExpanded: true,
              //       hint: Text(
              //         'Location Preference',
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Theme.of(context).hintColor,
              //         ),
              //       ),
              //       items: locationPreference.map((item) {
              //         return DropdownMenuItem(
              //           value: item,
              //           //disable default onTap to avoid closing menu when selecting an item
              //           enabled: false,
              //           child: StatefulBuilder(
              //             builder: (context, menuSetState) {
              //               final isSelected = selectedLocation.contains(item);
              //               return InkWell(
              //                 onTap: () {
              //                   isSelected
              //                       ? selectedLocation.remove(item)
              //                       : selectedLocation.add(item);
              //                   //This rebuilds the StatefulWidget to update the button's text
              //                   setState(() {});
              //                   //This rebuilds the dropdownMenu Widget to update the check mark
              //                   menuSetState(() {});
              //                 },
              //                 child: Container(
              //                   height: double.infinity,
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 16.0),
              //                   child: Row(
              //                     children: [
              //                       if (isSelected)
              //                         const Icon(Icons.check_box_outlined)
              //                       else
              //                         const Icon(Icons.check_box_outline_blank),
              //                       const SizedBox(width: 16),
              //                       Expanded(
              //                         child: Text(
              //                           item,
              //                           style: const TextStyle(
              //                               fontSize: 14, color: Colors.black),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         );
              //       }).toList(),
              //       //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
              //       value:
              //           selectedLocation.isEmpty ? null : selectedLocation.last,
              //       onChanged: (value) {},
              //       selectedItemBuilder: (context) {
              //         return locationPreference.map(
              //           (item) {
              //             return Container(
              //               alignment: AlignmentDirectional.center,
              //               child: Text(
              //                 selectedLocation.join(', '),
              //                 style: const TextStyle(
              //                     fontSize: 14,
              //                     overflow: TextOverflow.ellipsis,
              //                     color: Colors.black),
              //                 maxLines: 5,
              //               ),
              //             );
              //           },
              //         ).toList();
              //       },
              //       buttonStyleData: ButtonStyleData(
              //         padding: const EdgeInsets.only(left: 10, right: 5),
              //         height: 50,
              //         width: 340,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(12.h),
              //           ),
              //           border: Border.all(color: theme.colorScheme.primary),
              //         ),
              //         overlayColor: MaterialStateProperty.all<Color>(
              //             theme.colorScheme.primary),
              //       ),
              //       menuItemStyleData: const MenuItemStyleData(
              //         height: 40,
              //         padding: EdgeInsets.zero,
              //       ),
              //     ),
              //   ),
              // ),

              // LOCATION PREFERENCE END //
              const Spacer(),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 6.v,
                      child: AnimatedSmoothIndicator(
                          activeIndex: 2,
                          count: 4,
                          effect: ScrollingDotsEffect(
                              spacing: 8,
                              activeDotColor: theme.colorScheme.primary,
                              dotColor: appTheme.cyan700.withOpacity(0.5),
                              dotHeight: 6.v,
                              dotWidth: 6.h))))
            ])),
        bottomNavigationBar: CustomElevatedButton(
            text: "Continue",
            margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 66.v),
            rightIcon: Container(
                margin: EdgeInsets.only(left: 8.h),
                child: CustomImageView(
                    svgPath: ImageConstant.imgOutlineRightarrow)),
            buttonStyle: CustomButtonStyles.fillPrimary,
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

  /// Navigates to the gigFeed1FeedScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed1FeedScreen.
  onTapSkip(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.setupGAccountUploadProfilePictureScreen);
  }

  void continueToGroupPhotoUpload(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.setupGAccountUploadProfilePictureScreen);
  }

  bool isSelectCheckBox = true;
  List<String> weekList = [
    "Sat",
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "All",
  ];
  List<bool> isSelectedWeekList = List.generate(8, (index) => false);
  String getSelectedDaysText() {
    List<String> selectedDays = [];

    for (int i = 0; i < isSelectedWeekList.length; i++) {
      if (isSelectedWeekList[i]) {
        selectedDays.add(weekList[i]);
      }
    }

    return selectedDays.join(', ');
  }

  void onAvailableDaysTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(height: 17),
                  const Text(
                    "Choose Days Available",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 17),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "People will be able to request your group on the days you mark open.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 130,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 1.5),
                      itemCount: 8,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (!isSelectCheckBox) {
                                isSelectedWeekList[index] =
                                    !isSelectedWeekList[index];
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isSelectedWeekList[index]
                                  ? const Color(0xFF6236FF)
                                  : const Color(0xFF0BA9A7).withOpacity(0.2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              weekList[index],
                              style: TextStyle(
                                  color: isSelectedWeekList[index]
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "OR",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            flex: 5,
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (!isSelectCheckBox) {
                                  isSelectedWeekList =
                                      List.generate(8, (index) => false);
                                }
                                isSelectCheckBox = !isSelectCheckBox;
                              });
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: isSelectCheckBox
                                    ? BoxDecoration(
                                        color: const Color(0xFF6236FF),
                                        borderRadius: BorderRadius.circular(8))
                                    : BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                child: isSelectCheckBox
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : const SizedBox()),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text(
                            "Flexible",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 37),
                  ElevatedButton(
                    onPressed: () {
                      if (!isSelectCheckBox) {
                        availableDaysController.text = getSelectedDaysText();
                      } else {
                        availableDaysController.text = "Flexible";
                      }
                      Navigator.pop(context);
                      onDateTap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6236FF),
                      minimumSize: const Size(double.infinity, 56),
                      maximumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool isSelectCheckBoxDate = true;
  // CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime firstDay = DateTime.utc(DateTime.now().year, 1, 1);
  DateTime lastDay = DateTime.utc(DateTime.now().year, 12, 31);
  DateTime? selectedDay;
  void onDateTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Choose group open days",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 17),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "People will be able to request your group on the days you mark open.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0BA9A7).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: TableCalendar(
                      rowHeight: 35,
                      // calendarFormat: calendarFormat,
                      focusedDay: focusedDay,
                      firstDay: firstDay,
                      lastDay: lastDay,

                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },
                      onDaySelected: (selecteDay, focusedDay) {
                        if (!isSelectCheckBoxDate) {
                          setState(() {
                            selectedDay = selecteDay;
                            focusedDay = focusedDay;
                          });
                        }
                      },
                      calendarStyle: const CalendarStyle(
                        todayTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                        selectedDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6236FF),
                        ),
                        selectedTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isSelectCheckBoxDate = !isSelectCheckBoxDate;
                              });
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: isSelectCheckBoxDate
                                    ? BoxDecoration(
                                        color: const Color(0xFF6236FF),
                                        borderRadius: BorderRadius.circular(8))
                                    : BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                child: isSelectCheckBoxDate
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : const SizedBox()),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text(
                            "Flexible",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 37),
                  ElevatedButton(
                    onPressed: () {
                      // timeController.text = DateFormat('dd MMM')
                      //     .format(selectedDay ?? DateTime.now());

                      Navigator.pop(context);
                      onTimeTap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6236FF),
                      minimumSize: const Size(double.infinity, 56),
                      maximumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool isSelectCheckBoxTime = true;
  int selectedIndexFirstList = -1;
  int selectedIndexSecondList = -1;
  List<String> firstList = [
    "8AM - 9AM",
    "9AM - 10AM",
    "10AM - 11AM",
    "11AM - 12AM",
    "12AM - 1PM",
    "1PM - 2PM",
    "2PM - 3PM",
  ];
  List<String> secondList = [
    "3PM - 4PM",
    "4PM - 5PM",
    "5PM - 6PM",
    "6PM - 7PM",
    "7PM - 8PM",
    "8PM - 9PM",
    "9PM - 10PM",
  ];
  void onTimeTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Choose group open hours",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "People will be able to request your group during these hours on your open days.",
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      height: 385,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: ListView.builder(
                                itemCount: firstList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (isSelectCheckBoxTime) return;
                                            setState(() {
                                              selectedIndexSecondList = -1;
                                              selectedIndexFirstList = index;
                                            });
                                          },
                                          child: Text(
                                            firstList[index],
                                            style: TextStyle(
                                                color: index ==
                                                        selectedIndexFirstList
                                                    ? const Color(0xFF0BA9A7)
                                                    : Colors.grey,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Divider(
                                            height: 1,
                                            thickness: 1,
                                            color:
                                                index == selectedIndexFirstList
                                                    ? const Color(0xFF6236FF)
                                                    : Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: secondList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (isSelectCheckBoxTime) return;
                                        setState(() {
                                          selectedIndexFirstList = -1;
                                          selectedIndexSecondList = index;
                                          print(
                                              "Selected Time Slot SECOND: ${firstList[index]}");
                                        });
                                      },
                                      child: Text(
                                        secondList[index],
                                        style: TextStyle(
                                            color:
                                                index == selectedIndexSecondList
                                                    ? const Color(0xFF0BA9A7)
                                                    : Colors.grey,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: index == selectedIndexSecondList
                                            ? const Color(0xFF6236FF)
                                            : Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                    ),
                    Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (!isSelectCheckBoxTime) {
                                    selectedIndexFirstList = -1;
                                    selectedIndexSecondList = -1;
                                  }
                                  isSelectCheckBoxTime = !isSelectCheckBoxTime;
                                });
                              },
                              child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: isSelectCheckBoxTime
                                      ? BoxDecoration(
                                          color: const Color(0xFF6236FF),
                                          borderRadius:
                                              BorderRadius.circular(8))
                                      : BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                  child: isSelectCheckBoxTime
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 15,
                                        )
                                      : const SizedBox()),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              "Flexible",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 37),
                    ElevatedButton(
                      onPressed: () {
                        String updatedValue = "Flexible";
                        String updatedTime = "Flexible";

                        if (selectedIndexFirstList != -1) {
                          updatedTime = firstList[selectedIndexFirstList];
                        } else if (selectedIndexSecondList != -1) {
                          updatedTime = secondList[selectedIndexSecondList];
                        }

                        if (isSelectCheckBoxDate && isSelectCheckBoxTime) {
                          updatedValue = "Flexible : Flexible";
                        } else if (isSelectCheckBoxDate &&
                            !isSelectCheckBoxTime) {
                          updatedValue = "Flexible : $updatedTime";
                        } else if (!isSelectCheckBoxDate &&
                            isSelectCheckBoxTime) {
                          updatedValue =
                              "${DateFormat('dd MMM').format(selectedDay ?? DateTime.now())} : Flexible";
                        } else {
                          updatedValue =
                              "${DateFormat('dd MMM').format(selectedDay ?? DateTime.now())} : $updatedTime";
                        }

                        // timeController.text =
                        //     "${DateFormat('dd MMM').format(selectedDay ?? DateTime.now())} : ${firstList[index ?? 0]} to ${secondList[index ?? 0]}";

                        timeController.text = updatedValue;
                        Navigator.pop(context);

                        onLocationap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6236FF),
                        minimumSize: const Size(double.infinity, 56),
                        maximumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool isSelectCheckBoxLocation = true;
  int isVideoCallOnly = -1;

  void onLocationap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.98,
              width: double.infinity,
              padding: MediaQuery.of(context).viewInsets,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 66),
                    child: Text(
                      "Choose group location preference",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 17),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "People will be able to request your group during these hours on your open days.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GestureDetector(
                      onTap: () {
                        if (isSelectCheckBoxLocation) return;
                        setState(() => isVideoCallOnly = 0);
                      },
                      child: Container(
                        height: 124,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isVideoCallOnly == 0
                                ? theme.colorScheme.primary
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFF4E6),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: const Icon(
                                    Icons.login_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Flexible(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "I can go where needed",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Text(
                                        "People can enter custom places for you to meet",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: GestureDetector(
                      onTap: () {
                        if (isSelectCheckBoxLocation) return;
                        setState(() => isVideoCallOnly = 1);
                      },
                      child: Container(
                        height: 124,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: isVideoCallOnly == 1
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFF4E6),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Flexible(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Video calls only",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Text(
                                        "People will only be able to book video sessions with you",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "OR",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            flex: 5,
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: TextField(
                      readOnly: !isSelectCheckBoxLocation,
                      controller: locationController,
                      decoration: InputDecoration(
                          constraints: const BoxConstraints(maxHeight: 56),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6236FF))),
                          hintText: "Los Angeles, California",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          labelText: 'Set Specific Location',
                          labelStyle: const TextStyle(
                              color: Color(0xFF6236FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (!isSelectCheckBoxLocation) {
                                    isVideoCallOnly = -1;
                                  } else {
                                    isVideoCallOnly = 0;
                                  }
                                  isSelectCheckBoxLocation =
                                      !isSelectCheckBoxLocation;
                                });
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: isSelectCheckBoxLocation
                                    ? BoxDecoration(
                                        color: const Color(0xFF6236FF),
                                        borderRadius: BorderRadius.circular(8))
                                    : BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                child: isSelectCheckBoxLocation
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              "Flexible",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: () {
                        if (isSelectCheckBoxLocation) {
                          if (locationController.text.isEmpty) {
                            locationController.text = 'Flexible';
                          }
                          locationController.text;
                        } else {
                          if (isVideoCallOnly == 0) {
                            locationController.text = "I can go where needed";
                          } else if (isVideoCallOnly == 1) {
                            locationController.text = "Video calls only";
                          }
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6236FF),
                        minimumSize: const Size(double.infinity, 56),
                        maximumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Shows a modal bottom sheet with [RegisterSetupIndividualAccount7AvailableDaysOneBottomsheet]
  /// widget content.
  /// The sheet is displayed on top of the current view with scrolling enabled if
  /// content exceeds viewport height.
  /// onTapContinue(BuildContext context) {
  /// showModalBottomSheet(
  ///    context: context,
  ///    builder: (_) =>
  ///         RegisterSetupIndividualAccount7AvailableDaysOneBottomsheet(),
  ///       isScrollControlled: true);
  /// }///
}
