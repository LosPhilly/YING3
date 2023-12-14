import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class SetupGAccountGUploadProfilePicScreen extends StatefulWidget {
  const SetupGAccountGUploadProfilePicScreen({Key? key}) : super(key: key);

  @override
  State<SetupGAccountGUploadProfilePicScreen> createState() =>
      _SetupGAccountGUploadProfilePicScreenState();
}

class GroupData {
  final String? groupInformation;

  GroupData({this.groupInformation});
}

class _SetupGAccountGUploadProfilePicScreenState
    extends State<SetupGAccountGUploadProfilePicScreen> {
  String? groupDisplayName = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;
  String? imageURL;

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

  /// GET USER DATA
  Future<GroupData?> getGroupData() async {
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
        var groupData = userDocSnapshot.data() as Map<String, dynamic>;

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

//SHOW DIALOG BOX FOR IMAGE START//

  // ignore: non_constant_identifier_names
  void _ShowImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(' Please Choose an Option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Color.fromARGB(255, 98, 54, 255),
                        ),
                      ),
                      Text(
                        'Camera',
                        style:
                            TextStyle(color: Color.fromARGB(255, 98, 54, 255)),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Color.fromARGB(255, 98, 54, 255),
                        ),
                      ),
                      Text(
                        'Gallery',
                        style:
                            TextStyle(color: Color.fromARGB(255, 98, 54, 255)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

//SHOW DIALOG BOX FOR IMAGE END//

//CAMERA AND GALLERY, CROP IMAGES FUNCTIONS START //
  // ignore: unused_element
  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  // ignore: unused_element
  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    // ignore: use_build_context_synchronously
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (mounted && croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

//CAMERA AND GALLERY, CROP IMAGES FUNCTIONS START //

  void continueToGigFeed(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

//SUBMIT SIGN UP FORM START//

  void onTapFinish(BuildContext context) async {
    if (imageFile == null) {
      GlobalMethod.showErrorDialog(
        error: 'Please pick an image',
        ctx: context,
      );
      return;
    }

    try {
      final User? user = _auth.currentUser;
      final uid = user!.uid;

      final ref =
          FirebaseStorage.instance.ref().child('userImages').child('$uid.jpg');

      final refGroup =
          FirebaseStorage.instance.ref().child('groupImages').child('$uid.jpg');

      await ref.putFile(imageFile!);
      await refGroup.putFile(imageFile!);

      var imageUrl = await ref.getDownloadURL();
      var imageUrlGroup = await refGroup.getDownloadURL();

      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userImage': imageUrl,
      });

      FirebaseFirestore.instance.collection('groups').doc(uid).update({
        'groupImage': imageUrlGroup,
      });

      // ignore: use_build_context_synchronously
      continueToGigFeed(context);
    } catch (error) {
      // ignore: use_build_context_synchronously
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }

//SUBMIT SIGN UP FORM END//

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomElevatedButton(
                  height: 32.v,
                  width: 97.h,
                  text: "Finishing...",
                  buttonStyle: CustomButtonStyles.fillGreen,
                  buttonTextStyle: CustomTextStyles.labelLargeGreen800),
              Container(
                  width: 311.h,
                  margin: EdgeInsets.only(top: 9.v, right: 7.h),
                  child: Text("Upload $groupDisplayName profile picture",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium!
                          .copyWith(height: 1.50))),
              Container(
                  width: 309.h,
                  margin: EdgeInsets.only(top: 5.v, right: 9.h),
                  child: Text(
                      "Select a photo that will politely present you and your group profile.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          theme.textTheme.bodyLarge!.copyWith(height: 1.64))),
              SizedBox(height: 77.v),
              GestureDetector(
                onTap: () {
                  _ShowImageDialog();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 109.v,
                    width: 95.h,
                    child: Container(
                      width: size.width * 0.35,
                      height: size.width * 0.35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: imageFile == null
                            ? const Icon(
                                Icons.camera_enhance_sharp,
                                color: Color.fromARGB(255, 98, 54, 255),
                                size: 30,
                              )
                            : Image.file(
                                imageFile!,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.v),
              Align(
                  alignment: Alignment.center,
                  child: Text("Tap on camera icon.",
                      style: theme.textTheme.bodyMedium)),
              SizedBox(height: 5.v)
            ])),
        bottomNavigationBar: CustomElevatedButton(
            text: "Finish",
            buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
            margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 66.v),
            rightIcon: Container(
                margin: EdgeInsets.only(left: 8.h),
                child: CustomImageView(
                    svgPath: ImageConstant.imgOutlineRightarrow)),
            onTap: () {
              onTapFinish(context);
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
    Navigator.pushNamed(context, AppRoutes.gigFeedOneScreen);
  }

  /// Navigates to the setupGAccountTwelveScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the setupGAccountTwelveScreen.
  /// onTapFinish(BuildContext context) {
  ///  Navigator.pushNamed(context, AppRoutes.setupGAccountTwelveScreen);
  /// }
}
