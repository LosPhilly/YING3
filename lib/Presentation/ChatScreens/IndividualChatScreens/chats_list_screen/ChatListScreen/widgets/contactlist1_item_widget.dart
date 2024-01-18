import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Contactlist1ItemWidget extends StatelessWidget {
  const Contactlist1ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgUnsplashavatar44x44,
            height: 44.adaptSize,
            width: 44.adaptSize,
            radius: BorderRadius.circular(
              22.h,
            ),
            margin: EdgeInsets.only(bottom: 2.v),
          ),
          Container(
            width: 87.h,
            margin: EdgeInsets.only(left: 12.h),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Jane Smith\n",
                    style: theme.textTheme.titleSmall,
                  ),
                  TextSpan(
                    text: "Seen 6h ago",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
