import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

// ignore: must_be_immutable
class Outlineinput2ItemWidget extends StatelessWidget {
  const Outlineinput2ItemWidget({Key? key})
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
      decoration: AppDecoration.outlineOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 23.h),
        child: Text(
          "Describe Your Needs (Hours Required, People Needed etc.)",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium!.copyWith(
            height: 1.70,
          ),
        ),
      ),
    );
  }
}
