import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Scaffold(
        appBar: CustomAppBar(
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
        ),
        body: const SearchPage(),
      ),
    );
  }
}
