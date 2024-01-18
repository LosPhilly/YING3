import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/chats_list_screen/ChatListScreen/widgets/custom_text_form_field.dart';
import 'package:ying_3_3/core/app_export.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();

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
            onPressed: () {},
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ),
        const SizedBox(width: 5),
        CircleAvatar(
          backgroundColor: mainColor,
          radius: 20,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        )
      ],
    );
  }
}
