import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';

import 'package:ying_3_3/widgets/custom_image_view.dart';

Widget buildMenuItem({
  String? label,
  String? svgPath,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CustomIconButton(
            height: 44.adaptSize,
            width: 44.adaptSize,
            padding: EdgeInsets.all(12.h),
            decoration: IconButtonStyleHelper.fillGray,
            child: CustomImageView(svgPath: svgPath),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.h, top: 11.v, bottom: 11.v),
            child: Text(
              label!,
              style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Poppins"),
            ),
          ),
          Spacer(),
          CustomImageView(
            svgPath: ImageConstant.imgOutlinerightarrowOnprimary,
            height: 24.adaptSize,
            width: 24.adaptSize,
            margin: EdgeInsets.symmetric(vertical: 10.v),
          )
        ],
      ),
    ),
  );
}

Widget buildSpacer() {
  return SizedBox(height: 24.v);
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(left: 15.h, right: 30.h, bottom: 5.v),
    child: Text(
      title,
      style: TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
          fontFamily: "Poppins"),
    ),
  );
}

Column buildMenuColumn(List<Widget> items) {
  return Column(
    children: items
        .map((item) =>
            Padding(padding: EdgeInsets.only(right: 2.h), child: item))
        .toList(),
  );
}
