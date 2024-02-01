import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black900.withOpacity(0.4),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray100,
      );
  static BoxDecoration get fillGray10001 => BoxDecoration(
        color: appTheme.gray10001,
      );
  static BoxDecoration get fillIndigoA => BoxDecoration(
        color: appTheme.indigoA200,
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.7),
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange50,
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static BoxDecoration get fillPrimaryContainer1 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.28),
      );

  // Gradient decorations
  static BoxDecoration get gradientBlackToBlack => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.62),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.black900.withOpacity(0),
            appTheme.black900.withOpacity(0.75),
          ],
        ),
      );
  static BoxDecoration get gradientBlackToBlack900 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.61),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.black900.withOpacity(0),
            appTheme.black900.withOpacity(0.75),
          ],
        ),
      );
  static BoxDecoration get gradientBlackToBlack9001 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.54),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.black900.withOpacity(0),
            appTheme.black900.withOpacity(0.75),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreen => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreen40001 => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(1),
          width: 2.h,
          strokeAlign: strokeAlignOutside,
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
  static BoxDecoration get gradientCyanToGreen400011 => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(1),
          width: 1.h,
          strokeAlign: strokeAlignOutside,
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
  static BoxDecoration get gradientCyanToGreen400012 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.7),
            appTheme.green40001.withOpacity(0.7),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreen400013 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientCyanToGreen400014 => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2.h,
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
  static BoxDecoration get gradientCyanToGreen400015 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700,
            appTheme.green40001,
          ],
        ),
      );
  static BoxDecoration get gradientOnPrimaryToOnPrimary => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            theme.colorScheme.onPrimary.withOpacity(0),
            theme.colorScheme.onPrimary.withOpacity(1),
          ],
        ),
      );
  static BoxDecoration get gradientPrimaryContainerToPrimaryContainer =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 1),
          end: Alignment(0.5, 0),
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0),
            theme.colorScheme.primary.withOpacity(0.5),
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.05),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              -3,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9001 => BoxDecoration();
  static BoxDecoration get outlineOnPrimary => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.12),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnPrimary1 => BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onPrimary.withOpacity(0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              18,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineOnPrimary2 => BoxDecoration(
        color: theme.colorScheme.primary,
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.12),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnPrimary3 => BoxDecoration();
  static BoxDecoration get outlineOnPrimary4 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onPrimary.withOpacity(0.12),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              1,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineOnPrimary5 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onPrimary.withOpacity(0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              18,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineOnPrimary6 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withOpacity(0.12),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimaryContainer => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(0.12),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimary1 => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2.h,
        ),
      );

  // Column decorations
  static BoxDecoration get column31 => BoxDecoration();
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder22 => BorderRadius.circular(
        22.h,
      );
  static BorderRadius get circleBorder26 => BorderRadius.circular(
        26.h,
      );
  static BorderRadius get circleBorder50 => BorderRadius.circular(
        50.h,
      );
  static BorderRadius get circleBorder85 => BorderRadius.circular(
        85.h,
      );

  // Custom borders
  static BorderRadius get customBorderBL12 => BorderRadius.only(
        topLeft: Radius.circular(4.h),
        topRight: Radius.circular(12.h),
        bottomLeft: Radius.circular(12.h),
        bottomRight: Radius.circular(12.h),
      );
  static BorderRadius get customBorderBL121 => BorderRadius.vertical(
        bottom: Radius.circular(12.h),
      );
  static BorderRadius get customBorderBR12 => BorderRadius.horizontal(
        right: Radius.circular(4.h),
      );
  static BorderRadius get customBorderTL12 => BorderRadius.only(
        topLeft: Radius.circular(12.h),
        topRight: Radius.circular(4.h),
        bottomLeft: Radius.circular(12.h),
        bottomRight: Radius.circular(12.h),
      );
  static BorderRadius get customBorderTL121 => BorderRadius.horizontal(
        left: Radius.circular(12.h),
      );
  static BorderRadius get customBorderTL122 => BorderRadius.only(
        topLeft: Radius.circular(12.h),
        topRight: Radius.circular(12.h),
        bottomLeft: Radius.circular(12.h),
        bottomRight: Radius.circular(4.h),
      );
  static BorderRadius get customBorderTL20 => BorderRadius.vertical(
        top: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL24 => BorderRadius.vertical(
        top: Radius.circular(24.h),
      );
  static BorderRadius get customBorderTL40 => BorderRadius.only(
        topLeft: Radius.circular(40.h),
      );
  static BorderRadius get customBorderTL401 => BorderRadius.vertical(
        top: Radius.circular(40.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h,
      );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h,
      );
  static BorderRadius get roundedBorder30 => BorderRadius.circular(
        30.h,
      );
  static BorderRadius get roundedBorder40 => BorderRadius.circular(
        40.h,
      );
  static BorderRadius get roundedBorder46 => BorderRadius.circular(
        46.h,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
    