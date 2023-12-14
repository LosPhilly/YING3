import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore_for_file: must_be_immutable
class RegisterSetupIndividualAccountAvailabilityScreen extends StatefulWidget {
  const RegisterSetupIndividualAccountAvailabilityScreen({Key? key})
      : super(key: key);

  @override
  State<RegisterSetupIndividualAccountAvailabilityScreen> createState() =>
      _RegisterSetupIndividualAccountAvailabilityScreenState();
}

class UserData {
  final String? userName;

  UserData({this.userName});
}

class _RegisterSetupIndividualAccountAvailabilityScreenState
    extends State<RegisterSetupIndividualAccountAvailabilityScreen> {
  TextEditingController weekdayController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  TextEditingController locationController = TextEditingController();
  String? userDisplayName = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserData?> getUserData() async {
    try {
      final User? user = _auth.currentUser;
      String uid = user!.uid;

      // Reference to the "users" collection and a specific user document
      var userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Get the user document snapshot
      var userDocSnapshot = await userDocRef.get();

      // Check if the user document exists
      if (userDocSnapshot.exists) {
        // Access the data within the document
        var userData = userDocSnapshot.data() as Map<String, dynamic>;

        // Check if the "imageUrl" and "name" fields exist in the user document

        var userNameVar = userData['name'] as String?;

        if (userNameVar != null) {
          setState(() {
            userDisplayName = userNameVar;
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

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    weekdayController.dispose();
    timeController.dispose();
    locationController.dispose();
    getUserData();
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
        'daysAvailable': values,
        'timesAvailable': timesAvailable,
        'locationPreference': locationAvailable,
      });

      continueToUploadPhoto(context);
    } catch (e) {
      // ignore: avoid_print
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
                  height: 32.v,
                  width: 68.h,
                  text: "Setup",
                  buttonStyle: CustomButtonStyles.fillOrange,
                  buttonTextStyle: CustomTextStyles.labelLargeDeeporange600),
              SizedBox(height: 10.v),
              Text("$userDisplayName set your availability",
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
              Text("Choose the days you are available:",
                  style: theme.textTheme.labelLarge),
              SizedBox(height: 10.v),
              WeekdaySelector(
                // add in the days  displayedDays:
                color: theme.colorScheme.primary,
                firstDayOfWeek: DateTime.sunday,
                selectedFillColor: theme.colorScheme.primary,
                onChanged: (int day) {
                  setState(() {
                    // Use module % 7 as Sunday's index in the array is 0 and
                    // DateTime.sunday constant integer value is 7.
                    final index = day % 7;
                    // We "flip" the value in this example, but you may also
                    // perform validation, a DB write, an HTTP call or anything
                    // else before you actually flip the value,
                    // it's up to your app's needs.
                    values[index] = !values[index];
                  });
                },
                values: values,
              ),
              SizedBox(height: 20.v),

              // SELECT TIME START //

              // Notes:
              // Make the time more specific, actual times

              Text("Choose the times you are available:",
                  style: theme.textTheme.labelLarge),
              SizedBox(height: 10.v),
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Times',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: timesAvailable.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        //disable default onTap to avoid closing menu when selecting an item
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, menuSetState) {
                            final isSelected = selectedTimes.contains(item);
                            return InkWell(
                              onTap: () {
                                isSelected
                                    ? selectedTimes.remove(item)
                                    : selectedTimes.add(item);
                                //This rebuilds the StatefulWidget to update the button's text
                                setState(() {});
                                //This rebuilds the dropdownMenu Widget to update the check mark
                                menuSetState(() {});
                              },
                              child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(Icons.check_box_outlined)
                                    else
                                      const Icon(Icons.check_box_outline_blank),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                    value: selectedTimes.isEmpty ? null : selectedTimes.last,
                    onChanged: (value) {},
                    selectedItemBuilder: (context) {
                      return timesAvailable.map(
                        (item) {
                          return Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              selectedTimes.join(', '),
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black),
                              maxLines: 5,
                            ),
                          );
                        },
                      ).toList();
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      height: 50,
                      width: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.h),
                        ),
                        border: Border.all(color: theme.colorScheme.primary),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                          theme.colorScheme.primary),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              // SELECT TIME END //
              SizedBox(height: 20.v),

              // LOCATION PREFERENCE START //

              Text("Choose your location preference:",
                  style: theme.textTheme.labelLarge),
              SizedBox(height: 10.v),

              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Location Preference',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: locationPreference.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        //disable default onTap to avoid closing menu when selecting an item
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, menuSetState) {
                            final isSelected = selectedLocation.contains(item);
                            return InkWell(
                              onTap: () {
                                isSelected
                                    ? selectedLocation.remove(item)
                                    : selectedLocation.add(item);
                                //This rebuilds the StatefulWidget to update the button's text
                                setState(() {});
                                //This rebuilds the dropdownMenu Widget to update the check mark
                                menuSetState(() {});
                              },
                              child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      const Icon(Icons.check_box_outlined)
                                    else
                                      const Icon(Icons.check_box_outline_blank),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                    value:
                        selectedLocation.isEmpty ? null : selectedLocation.last,
                    onChanged: (value) {},
                    selectedItemBuilder: (context) {
                      return locationPreference.map(
                        (item) {
                          return Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              selectedLocation.join(', '),
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black),
                              maxLines: 5,
                            ),
                          );
                        },
                      ).toList();
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      height: 50,
                      width: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.h),
                        ),
                        border: Border.all(color: theme.colorScheme.primary),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                          theme.colorScheme.primary),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),

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
    Navigator.pushNamed(context, AppRoutes.registerIndividualSkillsScreen);
  }

  /// Navigates to the gigFeed1FeedScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed1FeedScreen.
  onTapSkip(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.registerIndividualUploadPictureScreen);
  }

  continueToUploadPhoto(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.registerIndividualUploadPictureScreen);
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
