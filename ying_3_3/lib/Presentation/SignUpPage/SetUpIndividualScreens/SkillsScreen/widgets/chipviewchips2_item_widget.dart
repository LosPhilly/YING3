import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Chipviewchips2ItemWidget extends StatelessWidget {
  const Chipviewchips2ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: RawChip(
        padding: EdgeInsets.only(
          left: 20.h,
          top: 9.v,
          bottom: 9.v,
        ),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          "UI Design",
          style: TextStyle(
            color: theme.colorScheme.onPrimary.withOpacity(1),
            fontSize: 12.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        deleteIcon: CustomImageView(
          svgPath: ImageConstant.imgOutlineRemove,
          height: 20.adaptSize,
          width: 20.adaptSize,
          margin: EdgeInsets.only(left: 6.h),
        ),
        onDeleted: () {},
        selected: false,
        backgroundColor: Colors.transparent,
        selectedColor: appTheme.gray300,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(
            12.h,
          ),
        ),
        onSelected: (value) {},
      ),
    );
  }
}
