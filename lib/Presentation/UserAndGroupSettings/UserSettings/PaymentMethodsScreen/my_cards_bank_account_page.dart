import 'package:flutter/material.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// CARD DETAILS PAGE FOR THE SETTING TO SEE WHAT CARDS ARE ON FILE

class MyCardsBankAccountPage extends StatefulWidget {
  const MyCardsBankAccountPage({Key? key}) : super(key: key);

  @override
  MyCardsBankAccountPageState createState() => MyCardsBankAccountPageState();
}

class MyCardsBankAccountPageState extends State<MyCardsBankAccountPage>
    with AutomaticKeepAliveClientMixin<MyCardsBankAccountPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: SizedBox(
            width: mediaQueryData.size.width,
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 28.v),
              Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.h),
                  padding: EdgeInsets.all(20.h),
                  decoration: AppDecoration.outlineOnPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconButton(
                          height: 40.adaptSize,
                          width: 40.adaptSize,
                          margin: EdgeInsets.only(bottom: 26.v),
                          padding: EdgeInsets.all(10.h),
                          decoration: IconButtonStyleHelper.fillPurpleTL20,
                          child: CustomImageView(
                              svgPath: ImageConstant.imgOutlinebank)),
                      Padding(
                          padding: EdgeInsets.only(left: 16.h, bottom: 2.v),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name of the Bank",
                                    style: theme.textTheme.titleSmall),
                                SizedBox(height: 5.v),
                                SizedBox(
                                    width: 161.h,
                                    child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "Routing No.",
                                              style: theme.textTheme.bodySmall),
                                          TextSpan(text: " "),
                                          TextSpan(
                                              text: "123456789\n",
                                              style: CustomTextStyles
                                                  .labelLargeOnPrimarySemiBold_2),
                                          TextSpan(
                                              text: "Account No.",
                                              style: theme.textTheme.bodySmall),
                                          TextSpan(text: " "),
                                          TextSpan(
                                              text: "000123456789",
                                              style: CustomTextStyles
                                                  .labelLargeOnPrimarySemiBold_2)
                                        ]),
                                        textAlign: TextAlign.left))
                              ])),
                      Spacer(),
                      CustomImageView(
                          svgPath: ImageConstant.imgCar,
                          height: 20.adaptSize,
                          width: 20.adaptSize,
                          margin: EdgeInsets.only(bottom: 46.v))
                    ],
                  ),
                ),
                SizedBox(height: 42.v),
                Opacity(
                    opacity: 0.25,
                    child: CustomImageView(
                        svgPath: ImageConstant.imgSlotmachineamico,
                        height: 226.v,
                        width: 269.h)),
                SizedBox(height: 41.v),
                SizedBox(
                    height: 122.v,
                    width: double.maxFinite,
                    child: Stack(alignment: Alignment.topCenter, children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: 98.v,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer
                                      .withOpacity(1),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24.h)),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            appTheme.black900.withOpacity(0.05),
                                        spreadRadius: 2.h,
                                        blurRadius: 2.h,
                                        offset: Offset(0, -3))
                                  ]))),
                      CustomElevatedButton(
                          width: 319.h,
                          text: "Add Bank Account",
                          leftIcon: Container(
                              margin: EdgeInsets.only(right: 8.h),
                              child: CustomImageView(
                                  svgPath: ImageConstant
                                      .imgOutlineaddPrimarycontainer)),
                          onTap: () {
                            onTapAddbank(context);
                          },
                          alignment: Alignment.topCenter)
                    ]))
              ])
            ]))));
  }

  /// Navigates to the myCardsBankAccountAddBankAccountFiveScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the myCardsBankAccountAddBankAccountFiveScreen.
  onTapAddbank(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
