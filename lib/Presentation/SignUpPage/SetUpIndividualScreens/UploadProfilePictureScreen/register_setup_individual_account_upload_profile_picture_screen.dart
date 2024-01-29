import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_button.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_iconbutton.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import '../../../../widgets/custom_loader.dart';

class RegisterSetupIndividualAccountUploadProfilePictureScreen
    extends StatefulWidget {
  const RegisterSetupIndividualAccountUploadProfilePictureScreen({Key? key})
      : super(key: key);

  @override
  State<RegisterSetupIndividualAccountUploadProfilePictureScreen>
      createState() =>
          _RegisterSetupIndividualAccountUploadProfilePictureScreenState();
}

class UserData {
  final String? userName;

  UserData({this.userName});
}

class _RegisterSetupIndividualAccountUploadProfilePictureScreenState
    extends State<RegisterSetupIndividualAccountUploadProfilePictureScreen> {
  File? imageFile;
  String? imageURL;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userDisplayName = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    getUserData();
    super.dispose();
  }

  /// GET USER DATA
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
                SizedBox(
                  height: 10.v,
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
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

//CAMERA AND GALLERY, CROP IMAGES FUNCTIONS START //
  void continueToSuccessfullyScreen(BuildContext context) {
    Navigator.popAndPushNamed(
        context, AppRoutes.successfullyCreatedAccountScreen,
        arguments: {"isindividual": true});
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
      CommonLoader().commonLoader(context);

      final User? user = _auth.currentUser;
      final uid = user!.uid;

      final ref =
          FirebaseStorage.instance.ref().child('userImages').child('$uid.jpg');
      await ref.putFile(imageFile!);
      var imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userImage': imageUrl,
      });

      // ignore: use_build_context_synchronously
      continueToSuccessfullyScreen(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomElevatedButton(
                  height: 32.v,
                  width: 97.h,
                  text: "Finishing...",
                  buttonStyle: CustomButtonStyles.fillGreen,
                  buttonTextStyle: CustomTextStyles.labelLargeGreen800),
              SizedBox(height: 10.v),
              Text("Upload profile picture",
                  style: theme.textTheme.headlineMedium),
              Container(
                width: 309.h,
                margin: EdgeInsets.only(top: 7.v, right: 9.h),
                child: Text(
                  "Select a photo that will politely present you and your profile.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge!.copyWith(height: 1.64),
                ),
              ),
              SizedBox(height: 77.v),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(10.0), // Border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 10, // Spread radius
                                blurRadius: 5, // Blur radius
                                // offset: Offset(0, 3), // Shadow offset
                              ),
                            ],
                            image: imageFile == null
                                ? DecorationImage(
                                    image: AssetImage(
                                        ImageConstant.etprofilefemale))
                                : DecorationImage(
                                    image: FileImage(
                                      imageFile!,
                                      // fit: BoxFit.fill,
                                    ),
                                    fit: BoxFit.fill)),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            _ShowImageDialog();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(10.0), // Border radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.2), // Shadow color
                                  spreadRadius: 10, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  // offset: Offset(0, 3), // Shadow offset
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(ImageConstant.camera),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.v),
              Align(
                  alignment: Alignment.center,
                  child: Text("Tap on camera icon.",
                      style: theme.textTheme.bodyMedium)),
              SizedBox(height: 5.v)
            ],
          ),
        ),
        bottomNavigationBar: CustomElevatedButton(
            text: "Finish",
            margin: EdgeInsets.only(left: 28.h, right: 28.h, bottom: 66.v),
            rightIcon: Container(
                margin: EdgeInsets.only(left: 8.h),
                child: CustomImageView(
                    svgPath: ImageConstant.imgOutlineRightarrow)),
            buttonStyle: CustomButtonStyles.outlineOnPrimaryTL121,
            onTap: () {
              onTapFinish(context);
            }));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pushNamed(
        context, AppRoutes.registerIndividualAvailabilityScreen);
  }

  /// Navigates to the gigFeed1FeedScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the gigFeed1FeedScreen.
  onTapSkip(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginOneScreen);
  }

  onTapContinue(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  /// Navigates to the registerSetupIndividualAccountTwelveScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the registerSetupIndividualAccountTwelveScreen.
  ///onTapFinish(BuildContext context) {
  ///Navigator.pushNamed(
  ///     context, AppRoutes.registerSetupIndividualAccountTwelveScreen);
  /// }
}
