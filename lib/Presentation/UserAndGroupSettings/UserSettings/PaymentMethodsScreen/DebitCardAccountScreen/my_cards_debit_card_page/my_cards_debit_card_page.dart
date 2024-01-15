import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/routes/app_routes.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

import '../my_cards_debit_card_page/widgets/creditcard_item_widget.dart';
import 'package:flutter/material.dart';

class MyCardsDebitCardPage extends StatefulWidget {
  const MyCardsDebitCardPage({Key? key}) : super(key: key);

  @override
  MyCardsDebitCardPageState createState() => MyCardsDebitCardPageState();
}

class MyCardsDebitCardPageState extends State<MyCardsDebitCardPage>
    with AutomaticKeepAliveClientMixin<MyCardsDebitCardPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: mediaQueryData.size.width,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.v);
                        },
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return const CreditcardItemWidget();
                        },
                      ),
                    ),
                    Stack(
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: CustomImageView(
                              svgPath: ImageConstant.imgSlotmachineamico,
                              height: 226.v,
                              width: 269.h),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.v),
                    SizedBox(
                      height: 122.v,
                      width: double.maxFinite,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 98.v,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withOpacity(1),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24.h),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: appTheme.black900.withOpacity(0.05),
                                    spreadRadius: 2.h,
                                    blurRadius: 2.h,
                                    offset: Offset(0, -3),
                                  )
                                ],
                              ),
                            ),
                          ),
                          CustomElevatedButton(
                              width: 319.h,
                              text: "Add Debit Card",
                              leftIcon: Container(
                                  margin: EdgeInsets.only(right: 8.h),
                                  child: CustomImageView(
                                      svgPath: ImageConstant
                                          .imgOutlineaddPrimarycontainer)),
                              onTap: () {
                                onTapAdddebitcard(context);
                              },
                              alignment: Alignment.topCenter)
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

  /// Navigates to the myCardsDebitCardAddDebitCardThreeScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the myCardsDebitCardAddDebitCardThreeScreen.
  onTapAdddebitcard(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
