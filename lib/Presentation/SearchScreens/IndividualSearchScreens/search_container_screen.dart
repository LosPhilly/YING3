import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/ChatScreens/IndividualChatScreens/search_screen.dart';
import 'package:ying_3_3/Presentation/ChatScreens/main_chat_screen.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_page.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
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
        toolbarHeight: 90, // Adjust the height to your preference
        backgroundColor: theme.colorScheme.primary,
        elevation: 8,
        leading: Align(
          alignment:
              Alignment.bottomLeft, // Align the leading icon to the bottom
          child: IconButton(
            onPressed: () => Navigator.pushNamed(
                context, AppRoutes.individualMainMenuScreen),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
        title: const Center(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '\n Search',
              maxLines: 2,
              style: TextStyle(
                fontSize: 30.0, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Align(
            alignment:
                Alignment.bottomRight, // Align the action icons to the bottom
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const UsersSearchScreen())),
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                const SizedBox(width: 1), // Add spacing between icons
                Stack(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            onClickNewMessage();
                          },
                          icon: const Icon(Icons.chat_rounded,
                              color: Colors.white),
                        ),
                        /* AppbarImage(
                          onTap: onClickNewMessage,
                          svgPath: ImageConstant.imgOutlinechattext,
                          margin: EdgeInsets.all(8.0),
                        ), */
                        if (newMessage)
                          Positioned(
                            top: 6.5.v,
                            left: 29.h,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
