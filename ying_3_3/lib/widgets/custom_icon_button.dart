import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.margin,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => Padding(
        padding: margin ?? EdgeInsets.zero,
        child: SizedBox(
          height: height ?? 0,
          width: width ?? 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Container(
              padding: padding ?? EdgeInsets.zero,
              decoration: decoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                    border: Border.all(
                      color: theme.colorScheme.onPrimary.withOpacity(0.12),
                      width: 1.h,
                    ),
                  ),
              child: child,
            ),
            onPressed: onTap,
          ),
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineOnPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12.h),
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
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange50,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get outlinePrimaryContainer => BoxDecoration(
        color: appTheme.gray200,
        borderRadius: BorderRadius.circular(17.h),
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(1),
          width: 2.h,
        ),
      );
  static BoxDecoration get fillLightBlue => BoxDecoration(
        color: appTheme.lightBlue50,
        borderRadius: BorderRadius.circular(12.h),
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green50,
        borderRadius: BorderRadius.circular(12.h),
      );
  static BoxDecoration get fillLightBlueTL24 => BoxDecoration(
        color: appTheme.lightBlue50,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillOrangeTL24 => BoxDecoration(
        color: appTheme.orange50,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillPurple => BoxDecoration(
        color: appTheme.purple50,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillGreenTL24 => BoxDecoration(
        color: appTheme.green50,
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(18.h),
      );
  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red50,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get outlinePrimaryContainerTL10 => BoxDecoration(
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(0.12),
          width: 1.h,
        ),
      );
  static BoxDecoration get fillGreenTL28 => BoxDecoration(
        color: appTheme.green400,
        borderRadius: BorderRadius.circular(28.h),
      );
  static BoxDecoration get fillDeepOrange => BoxDecoration(
        color: appTheme.deepOrange700,
        borderRadius: BorderRadius.circular(28.h),
      );
  static BoxDecoration get fillPrimaryContainer => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24.h),
      );
  static BoxDecoration get fillCyan => BoxDecoration(
        color: appTheme.cyan50,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray10002,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get fillPurpleTL16 => BoxDecoration(
        color: appTheme.purple50,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get fillRedTL16 => BoxDecoration(
        color: appTheme.red5001,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get fillGreenTL16 => BoxDecoration(
        color: appTheme.green50,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get gradientCyanToGreen => BoxDecoration(
        borderRadius: BorderRadius.circular(24.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.cyan700.withOpacity(0.1),
            appTheme.green40001.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get fillRedTL12 => BoxDecoration(
        color: appTheme.red50,
        borderRadius: BorderRadius.circular(12.h),
      );
  static BoxDecoration get fillGreenTL20 => BoxDecoration(
        color: appTheme.green50,
        borderRadius: BorderRadius.circular(20.h),
      );
  static BoxDecoration get fillOrangeTL20 => BoxDecoration(
        color: appTheme.orange50,
        borderRadius: BorderRadius.circular(20.h),
      );
  static BoxDecoration get fillGrayTL20 => BoxDecoration(
        color: appTheme.gray10002,
        borderRadius: BorderRadius.circular(20.h),
      );
  static BoxDecoration get fillPurpleTL20 => BoxDecoration(
        color: appTheme.purple50,
        borderRadius: BorderRadius.circular(20.h),
      );
  static BoxDecoration get fillLightBlueTL16 => BoxDecoration(
        color: appTheme.lightBlue50,
        borderRadius: BorderRadius.circular(16.h),
      );
  static BoxDecoration get gradientCyanToGreenTL16 => BoxDecoration(
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
  static BoxDecoration get fillRedTL22 => BoxDecoration(
        color: appTheme.red50,
        borderRadius: BorderRadius.circular(22.h),
      );
  static BoxDecoration get fillLightBlueTL20 => BoxDecoration(
        color: appTheme.lightBlue50,
        borderRadius: BorderRadius.circular(20.h),
      );
}
