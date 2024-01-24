import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/search_screen.dart';
import 'package:ying_3_3/Presentation/ChatScreens/main_chat_screen.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_page.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';

// ignore_for_file: must_be_immutable
class SearchContainerScreen extends StatefulWidget {
  SearchContainerScreen({Key? key}) : super(key: key);

  @override
  State<SearchContainerScreen> createState() => _SearchContainerScreenState();
}

class _SearchContainerScreenState extends State<SearchContainerScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool newMessage = false;
  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  onTapOutlineburgerme(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  onTapOutlinegridfour(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }

  void onClickNewMessage() {
    if (newMessage == false) {
      setState(() {
        newMessage = true;
      });
    } else if (newMessage == true) {
      setState(() {
        newMessage = false;
      });
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ChatScreenMain())); // Replace YourNewPage with the actual page you want to navigate to
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Adjust the height to your preference
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.userState),
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        title: const Align(
          alignment: Alignment.bottomCenter, // Align the text to the bottom
          child: Text(
            'Search',
            style: TextStyle(
              fontSize: 24.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          const SizedBox(width: 20), // Add spacing between icons and text
          IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UsersSearchScreen())),
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          const SizedBox(width: 10), // Add spacing between icons
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0), // Adjust the radius as needed
            bottomRight: Radius.circular(20.0),
          ),
        ),
      ),
      /* appBar: CustomAppBar(
        height: 89.v,
        actions: [
          Stack(
            children: [
              AppbarImage(
                onTap: onClickNewMessage,
                svgPath: ImageConstant.imgOutlinechattext,
                margin: EdgeInsets.fromLTRB(28.h, 48.v, 28.h, 2.v),
              ),
              if (newMessage)
                Positioned(
                  top: 45.v,
                  left: 30.h,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          )
        ],
      ), */
      body: const SearchPage(),
    );
  }
}
