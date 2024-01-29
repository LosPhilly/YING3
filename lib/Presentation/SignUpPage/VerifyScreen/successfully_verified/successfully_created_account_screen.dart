// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpGroupScreens/GroupSetUpSkillsOffering/setup_g_account_offering_screen.dart';

import '../../../../widgets/custom_image_view.dart';

class SuccessfullyCreatedAccountScreen extends StatefulWidget {
  const SuccessfullyCreatedAccountScreen({Key? key}) : super(key: key);

  @override
  State<SuccessfullyCreatedAccountScreen> createState() =>
      _SuccessfullyCreatedAccountScreenState();
}

class _SuccessfullyCreatedAccountScreenState
    extends State<SuccessfullyCreatedAccountScreen> {
  String groupDisplayName = '';

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

  void continueToGigFeed(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.userState, (Route<dynamic> route) => false);
  }

  openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isindividual == true
                            ? Colors.green.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                      ),
                      child: isindividual == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.blue,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isindividual == true
                              ? 'Please confirm'
                              : "YING Alert",
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          isindividual == true
                              ? 'To finish the process, please confirm that you agree with our Legal Disclaimer.'
                              : "When a Gig is published, it will be sent to the entire community. We recommend keeping this on.",
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 20.v,
                        ),
                        if (isindividual == true)
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Legal Disclaimer',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.info_outline,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => continueToGigFeed(context),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: isindividual == true
                                ? Colors.green
                                : appTheme.blueA200,
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Yes, I agree",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => continueToGigFeed(context),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        alignment: Alignment.center,
                        child: Text(
                          isindividual == true ? 'Cancle' : "Turn Off",
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        );
      },
    );
  }

  var isindividual = false;
  @override
  void initState() {
    getGroupData();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        openBottomSheet(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    print(arguments['isindividual']);
    isindividual = arguments['isindividual'];
    return Scaffold(
      body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 45.v,
          ),
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                child: CustomImageView(
                  svgPath: ImageConstant.imgIcon,
                  height: 164.adaptSize,
                  width: 164.adaptSize,
                ),
              ),
              SizedBox(height: 35.v),
              SizedBox(
                width: 295.h,
                child: Text(
                  "Congratulations!",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.headlineMediumPrimary.copyWith(
                    fontFamily: 'Poppins',
                    height: 1.50,
                  ),
                ),
              ),
              SizedBox(height: 13.v),
              SizedBox(
                // width: 170.h,
                child: Text(
                  isindividual == true
                      ? 'Your account has been created successfully.'
                      : "$groupDisplayName account has been created successfully.",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontFamily: 'Poppins',
                    height: 1.64,
                  ),
                ),
              ),
              SizedBox(height: 35.v),
              CustomImageView(
                svgPath: ImageConstant.imgConfetti,
                height: 155.v,
                width: 185.h,
              ),
            ],
          )),
    );
  }
}
