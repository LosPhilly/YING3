import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class BlogpostItemWidget extends StatelessWidget {
  const BlogpostItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineOnPrimary4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 1.v,
                bottom: 24.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Events Planner available to work from tomorrow?",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleMediumOnPrimary_1.copyWith(
                      height: 1.64,
                    ),
                  ),
                  SizedBox(height: 10.v),
                  Row(
                    children: [
                      CustomElevatedButton(
                        height: 32.v,
                        width: 133.h,
                        text: "Project Manager",
                        buttonStyle: CustomButtonStyles.fillOrange,
                        buttonTextStyle:
                            CustomTextStyles.labelLargeDeeporange600,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 13.h,
                          top: 8.v,
                          bottom: 5.v,
                        ),
                        child: Text(
                          "2h ago",
                          style: CustomTextStyles.labelLargeSemiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgRectangle523,
            height: 72.adaptSize,
            width: 72.adaptSize,
            radius: BorderRadius.circular(
              16.h,
            ),
            margin: EdgeInsets.only(top: 44.v),
          ),
        ],
      ),
    );
  }
}
