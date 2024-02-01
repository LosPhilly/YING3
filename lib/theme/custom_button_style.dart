import 'package:ying_3_3/core/app_export.dart';
import 'package:flutter/material.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillBlueA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.blueA200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
  static ButtonStyle get fillDeepOrange => ElevatedButton.styleFrom(
        backgroundColor: appTheme.deepOrange700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
  static ButtonStyle get fillGreen => ElevatedButton.styleFrom(
        backgroundColor: appTheme.green50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get fillGreenTL8 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.green400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
  static ButtonStyle get fillIndigoA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.indigoA200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get fillIndigoATL8 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.indigoA200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
  static ButtonStyle get fillLightBlue => ElevatedButton.styleFrom(
        backgroundColor: appTheme.lightBlue50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get fillOrange => ElevatedButton.styleFrom(
        backgroundColor: appTheme.orange50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              12.h,
            ),
            topRight: Radius.circular(
              12.h,
            ),
            bottomLeft: Radius.circular(
              12.h,
            ),
            bottomRight: Radius.circular(
              4.h,
            ),
          ),
        ),
      );
  static ButtonStyle get fillPrimaryTL12 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get fillPrimaryTL8 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
  static ButtonStyle get fillPurple => ElevatedButton.styleFrom(
        backgroundColor: appTheme.purple50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get fillRed => ElevatedButton.styleFrom(
        backgroundColor: appTheme.red50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );

  // Gradient button style
  static BoxDecoration get gradientCyanToGreenDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(12.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreenTL12Decoration => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            12.h,
          ),
          topRight: Radius.circular(
            12.h,
          ),
          bottomLeft: Radius.circular(
            4.h,
          ),
          bottomRight: Radius.circular(
            12.h,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreenTL16Decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreenTL8Decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreenTL81Decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.7),
            appTheme.green40001.withOpacity(0.7),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreenTL82Decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700,
            appTheme.green40001,
          ],
        ),
      );

  // Outline button style
  static ButtonStyle get outlineBlack => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        shadowColor: appTheme.black900.withOpacity(0.25),
        elevation: 4,
      );
  static ButtonStyle get outlineBlueGray => OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer.withOpacity(1),
        side: BorderSide(
          color: appTheme.blueGray50,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              12.h,
            ),
            bottom: Radius.circular(
              12.h,
            ),
          ),
        ),
      );
  static ButtonStyle get outlineOnPrimaryTL121 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.indigoA200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        shadowColor: theme.colorScheme.onPrimary.withOpacity(0.1),
        elevation: 18,
      );
  static ButtonStyle get outlineOnPrimaryTL122 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: theme.colorScheme.onPrimary.withOpacity(0.12),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
      );
  static ButtonStyle get outlinePrimaryContainer => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: theme.colorScheme.primaryContainer.withOpacity(0.12),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
