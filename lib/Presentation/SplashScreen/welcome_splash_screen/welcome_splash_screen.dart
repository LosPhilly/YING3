import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/user_state.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeSplashScreen extends StatefulWidget {
  const WelcomeSplashScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<WelcomeSplashScreen> createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UserState()));
    }); */
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    /* SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); */
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return AnimatedSplashScreen(
        duration: 5000,
        splashIconSize: 255,
        splash: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 195.v,
                width: 180.h,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgSplashYingLogo,
                        height: 355.v,
                        width: 374.h,
                        alignment: Alignment.topCenter),
                  ],
                ),
              ),
              SizedBox(height: 15.v),
              const Text(
                "YING",
                style: TextStyle(
                    fontSize: 30.0, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ),
        nextScreen: const UserState(),
        splashTransition: SplashTransition.fadeTransition,
        //pageTransitionType: PageTransitionType.scale,
        backgroundColor: theme.colorScheme.primary);
  }
}
