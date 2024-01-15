import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/DebitCardAccountScreen/my_cards_debit_card_page/my_cards_debit_card_page.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/my_cards_bank_account_page.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/core/app_export.dart';
//import 'package:ying_3_3/presentation/my_cards_bank_account_page/my_cards_bank_account_page.dart';
//import 'package:ying_3_3/presentation/my_cards_debit_card_page/my_cards_debit_card_page.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_3.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';

class MyCardsBankAccountTabScreen extends StatefulWidget {
  const MyCardsBankAccountTabScreen({Key? key}) : super(key: key);

  @override
  MyCardsBankAccountTabScreenState createState() =>
      MyCardsBankAccountTabScreenState();
}

// ignore_for_file: must_be_immutable
class MyCardsBankAccountTabScreenState
    extends State<MyCardsBankAccountTabScreen> with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        height: 768.v,
        width: double.maxFinite,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.v),
                    decoration: AppDecoration.fillPrimary,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CustomAppBar(
                          height: 26.v,
                          leadingWidth: 52.h,
                          leading: AppbarImage1(
                              svgPath:
                                  ImageConstant.imgArrowleftPrimarycontainer,
                              margin: EdgeInsets.only(left: 28.h, bottom: 2.v),
                              onTap: () {
                                onTapArrowleftone(context);
                              }),
                          centerTitle: true,
                          title: AppbarSubtitle3(text: "My Cards")),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.h, vertical: 10.v),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.h, vertical: 5.v),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusStyle.roundedBorder12),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 2.v),
                                SizedBox(
                                    width: 333.h,
                                    child: Text(
                                        "We use Stripe to make sure you get paid, and\nto keep your personal and bank details secure.",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyles
                                            .titleSmallPrimaryContainer_1
                                            .copyWith(height: 1.70)))
                              ]))
                    ]))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: fs.Svg(ImageConstant.imgGroup47),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: 44.v,
                        width: 296.h,
                        child: TabBar(
                            controller: tabviewController,
                            labelPadding: EdgeInsets.zero,
                            labelColor:
                                theme.colorScheme.onPrimary.withOpacity(0.42),
                            unselectedLabelColor:
                                appTheme.cyan700.withOpacity(0.5),
                            tabs: [
                              Tab(child: Text("Bank Account")),
                              Tab(child: Text("Debit Card"))
                            ])),
                    SizedBox(
                      height: 565.v,
                      child: TabBarView(
                        controller: tabviewController,
                        children: const [
                          MyCardsBankAccountPage(),
                          MyCardsDebitCardPage(), // MyCardsDebitCardPage()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
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
}
