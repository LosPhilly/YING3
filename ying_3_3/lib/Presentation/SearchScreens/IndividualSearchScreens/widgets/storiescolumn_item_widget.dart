import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

// ignore: must_be_immutable
class StoriescolumnItemWidget extends StatelessWidget {
  const StoriescolumnItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 15.v,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder16,
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.imgStories250x152,
          ),
          fit: BoxFit.cover,
        ),
      ),
      foregroundDecoration: AppDecoration.gradientBlackToBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      width: 152.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 157.v),
          Text(
            "Joshua King",
            style: CustomTextStyles.titleSmallPrimaryContainer_3,
          ),
          Text(
            "1 week on Ying | \n2 tasks completed",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodySmallPrimaryContainer.copyWith(
              height: 1.70,
            ),
          ),
        ],
      ),
    );
  }
}
