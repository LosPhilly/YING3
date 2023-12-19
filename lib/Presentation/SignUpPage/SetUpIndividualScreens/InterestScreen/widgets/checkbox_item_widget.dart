import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class CheckboxItemWidget extends StatefulWidget {
  final String skill;
  final Function(bool, String) onChecked;
  const CheckboxItemWidget(
      {Key? key, required this.skill, required this.onChecked})
      : super(
          key: key,
        );

  @override
  State<CheckboxItemWidget> createState() => _CheckboxItemWidgetState();
}

class _CheckboxItemWidgetState extends State<CheckboxItemWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChecked(
          isChecked,
          widget.skill,
        ); // Pass the item text or ID
      },
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: AppDecoration.outlinePrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Row(
          children: [
            Container(
              height: 28.adaptSize,
              width: 28.adaptSize,
              padding: EdgeInsets.all(2.h),
              decoration: AppDecoration.outlineOnPrimary2.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8,
              ),
              child: isChecked
                  ? CustomImageView(
                      svgPath: ImageConstant.imgCheckmark,
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      alignment: Alignment.center,
                    )
                  : SizedBox(), // Use SizedBox when not checked
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                top: 3.v,
              ),
              child: Text(
                widget.skill,
                style: CustomTextStyles.titleMediumOnPrimary_1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
