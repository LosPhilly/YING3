import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/MainUserSettingsScreen/user_profile_settings_main_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_4.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_floating_text_field.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_outlined_button.dart';

// ignore_for_file: must_be_immutable
class UserProfileSettingsDataScreen extends StatefulWidget {
  final String userId;
  const UserProfileSettingsDataScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  State<UserProfileSettingsDataScreen> createState() =>
      _UserProfileSettingsDataScreenState();
}

class _UserProfileSettingsDataScreenState
    extends State<UserProfileSettingsDataScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();

  TextEditingController yourJobController = TextEditingController();

  TextEditingController availabilityvalController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;
  String? imageURL;

  late FocusNode _focusNode;

  String? name;
  String email = '';
  List<List> intrestList = [];
  String imageUrl = '';
  String uid = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc == null) {
        return CircularProgressIndicator();
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          imageUrl = userDoc.get('userImage');
          uid = userDoc.get('id');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');

          dynamic intrestData = userDoc.get('interest');
          intrestList.add(intrestData);

          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt =
              '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
      // ignore: empty_catches
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

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

  onTapSave(BuildContext context) async {
    if (imageFile == null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserProfileSettingsMainScreen(
            userId:
                uid), // Replace YourNewPage with the actual page you want to navigate to
      ));
      return;
    }

    try {
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
      onTapContinue(context);
    } catch (error) {
      // ignore: use_build_context_synchronously
      GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    }
  }

  onTapContinue(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UserProfileSettingsMainScreen(
          userId:
              uid), // Replace YourNewPage with the actual page you want to navigate to
    ));
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Remove focus when tapping outside of text fields
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            height: 48.v,
            leadingWidth: 52.h,
            leading: AppbarImage1(
                svgPath: ImageConstant.imgArrowleft,
                margin: EdgeInsets.only(left: 28.h, top: 12.v, bottom: 12.v),
                onTap: () {
                  onTapArrowleftone(context);
                }),
            centerTitle: true,
            title: AppbarSubtitle4(text: "Personal Data")),
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(27.h),
            child: Column(
              children: [
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
                SizedBox(height: 16.v),
                CustomOutlinedButton(
                    onTap: () {
                      _ShowImageDialog();
                    },
                    width: 143.h,
                    text: "Change Picture"),
                SizedBox(height: 40.v),
                CustomFloatingTextField(
                    autofocus: false,
                    controller: nameController,
                    labelText: "Your Name",
                    labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                    hintText: "Your Name"),
                SizedBox(height: 24.v),
                CustomFloatingTextField(
                    autofocus: false,
                    controller: dateOfBirthController,
                    labelText: "Date of Birth",
                    labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                    hintText: "Date of Birth",
                    suffix: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.h),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgOutlineDownarrow)),
                    suffixConstraints: BoxConstraints(maxHeight: 66.v)),
                SizedBox(height: 24.v),
                CustomFloatingTextField(
                    autofocus: false,
                    controller: yourJobController,
                    labelText: "Your Job",
                    labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                    hintText: "Your Job"),
                SizedBox(height: 24.v),
                CustomFloatingTextField(
                    autofocus: false,
                    controller: availabilityvalController,
                    labelText: "Availability",
                    labelStyle: CustomTextStyles.bodyMediumOnPrimary_3,
                    hintText: "Availability",
                    textInputAction: TextInputAction.done,
                    suffix: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.h),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgOutlineDownarrow)),
                    suffixConstraints: BoxConstraints(maxHeight: 66.v)),
                CustomElevatedButton(
                    height: 48.v,
                    text: "Save ",
                    margin:
                        EdgeInsets.only(top: 37.v, right: 10.h, bottom: 5.v),
                    buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                    onTap: () {
                      onTapSave(context);
                    },
                    alignment: Alignment.centerLeft)
              ],
            ),
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

  /// Navigates to the userProfileSettingsOneScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the userProfileSettingsOneScreen.
}
