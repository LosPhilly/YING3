import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/custom_text_form_field.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/services/firebase_firestore_service.dart';
import 'package:ying_3_3/services/media_service.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});
  final String? receiverId;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  Uint8List? file;
  File? imageFile;

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: widget.receiverId!,
        content: controller.text,
      );
      controller.clear();
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
    }
    // ignore: use_build_context_synchronously
    FocusScope.of(context).unfocus();
  }

  Future<void> _showPopupMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(90, 690, 0, 0),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'option1',
          child: Text('Gallery'),
        ),
        const PopupMenuItem(
          value: 'option2',
          child: Text('Camera'),
        ),
      ],
    ).then((value) async {
      if (value == 'option1') {
        // Handle Option 1
        final pickedImage = await MediaService.pickImage();
        setState(() => file = pickedImage);
        if (file != null) {
          await FirebaseFirestoreService.addImageMessage(
            receiverId: widget.receiverId!,
            file: file!,
          );
        }
      } else if (value == 'option2') {
        // Handle Option 2
        final pickedImage = await MediaService.cameraImage();
        setState(() => file = pickedImage);
        if (file != null) {
          await FirebaseFirestoreService.addImageMessage(
            receiverId: widget.receiverId!,
            file: file!,
          );
        }
      }
    });
  }

  Future<void> _sendImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.receiverId!,
        file: file!,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: controller,
            hintText: "Add Message...",
          ),
        ),
        const SizedBox(width: 5),
        CircleAvatar(
          backgroundColor: mainColor,
          radius: 20,
          child: IconButton(
            onPressed: () {
              _sendText(context);
            },
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ),
        const SizedBox(width: 5),
        CircleAvatar(
          backgroundColor: mainColor,
          radius: 20,
          child: IconButton(
            onPressed: () {
              _showPopupMenu(context); //_sendImage();
            },
            icon: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        )
      ],
    );
  }
}
