import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Eventpost1ItemWidget extends StatelessWidget {
  Eventpost1ItemWidget({
    Key? key,
    this.onTapImgProjectName,
  }) : super(
          key: key,
        );

  VoidCallback? onTapImgProjectName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.v,
      width: 152.h,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle513240x152,
            height: 240.v,
            width: 152.h,
            radius: BorderRadius.circular(
              16.h,
            ),
            alignment: Alignment.center,
            onTap: () {
              onTapImgProjectName?.call();
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                bottom: 16.v,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Project Name",
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.v),
                  Text(
                    "Description",
                    style: CustomTextStyles.bodyMediumPrimaryContainer,
                  ),
                  SizedBox(height: 8.v),
                  SizedBox(
                    height: 28.v,
                    width: 52.h,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgRectangle6828x28,
                          height: 28.adaptSize,
                          width: 28.adaptSize,
                          radius: BorderRadius.circular(
                            14.h,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgStories28x28,
                          height: 28.adaptSize,
                          width: 28.adaptSize,
                          radius: BorderRadius.circular(
                            14.h,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
