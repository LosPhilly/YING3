import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

// ignore: must_be_immutable
class Chipviewchips8ItemWidget extends StatelessWidget {
  const Chipviewchips8ItemWidget({Key? key})
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
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 7.v,
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
        selected: false,
        backgroundColor: Colors.transparent,
        selectedColor: appTheme.black900.withOpacity(0.2),
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
