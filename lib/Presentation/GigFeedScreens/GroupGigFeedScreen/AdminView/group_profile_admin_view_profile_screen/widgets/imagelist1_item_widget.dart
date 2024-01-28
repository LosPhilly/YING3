import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/theme/app_decoration.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Imagelist1ItemWidget extends StatelessWidget {
  Imagelist1ItemWidget({
    Key? key,
    this.onTapImgUserImage,
  }) : super(
          key: key,
        );

  VoidCallback? onTapImgUserImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96.h,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: 140.v,
          width: 96.h,
          decoration: AppDecoration.outlineOnPrimary3,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRectangle68,
                height: 140.v,
                width: 96.h,
                radius: BorderRadius.circular(
                  16.h,
                ),
                alignment: Alignment.center,
                onTap: () {
                  onTapImgUserImage?.call();
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12.h,
                    bottom: 14.v,
                  ),
                  child: Text(
                    "Tatiana\nBator",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelLargePrimaryContainer.copyWith(
                      height: 1.70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
