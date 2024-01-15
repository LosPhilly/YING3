import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class CreditcardItemWidget extends StatefulWidget {
  const CreditcardItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  State<CreditcardItemWidget> createState() => _CreditcardItemWidgetState();
}

class _CreditcardItemWidgetState extends State<CreditcardItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.v),
      decoration: AppDecoration.outlineOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconButton(
            height: 40.adaptSize,
            width: 40.adaptSize,
            margin: EdgeInsets.only(bottom: 6.v),
            padding: EdgeInsets.all(7.h),
            decoration: IconButtonStyleHelper.fillRedTL22,
            child: CustomImageView(
              svgPath: ImageConstant.imgLightbulb,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 1.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1234 5678 9012 3456",
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(height: 4.v),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Expiry Date",
                        style: theme.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      TextSpan(
                        text: "MM/YY",
                        style: CustomTextStyles.labelLargeOnPrimarySemiBold_2,
                      ),
                      TextSpan(
                        text: "",
                      ),
                      TextSpan(
                        text: "CVV",
                        style: theme.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      TextSpan(
                        text: "123",
                        style: CustomTextStyles.labelLargeOnPrimarySemiBold_2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          CustomImageView(
            svgPath: ImageConstant.imgCar,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: const EdgeInsets.only(bottom: 26),
          ),
        ],
      ),
    );
  }
}
