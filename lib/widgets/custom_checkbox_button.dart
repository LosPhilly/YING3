import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';

// ignore: must_be_immutable
class CustomCheckboxButton extends StatefulWidget {
  CustomCheckboxButton({
    Key? key,
    required this.onChange,
    this.decoration,
    this.alignment,
    this.isRightCheck,
    this.iconSize,
    required this.value,
    this.text,
    this.width,
    this.margin,
    this.padding,
    this.textStyle,
    this.textAlignment,
    this.isExpandedText = false,
  }) : super(
          key: key,
        );

  final BoxDecoration? decoration;

  final Alignment? alignment;

  final bool? isRightCheck;

  final double? iconSize;

  bool value;

  final Function(bool) onChange;

  final String? text;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  final TextAlign? textAlignment;

  final bool isExpandedText;

  @override
  _CustomCheckboxButtonState createState() => _CustomCheckboxButtonState();
}

class _CustomCheckboxButtonState extends State<CustomCheckboxButton> {
  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: buildCheckBoxWidget,
          )
        : buildCheckBoxWidget;
  }

  Widget get buildCheckBoxWidget => InkWell(
        onTap: () {
          setState(() {
            widget.value = !widget.value;
          });
          widget.onChange(widget.value);
        },
        child: Container(
          decoration: widget.decoration,
          width: widget.width,
          margin: widget.margin ?? EdgeInsets.zero,
          child: (widget.isRightCheck ?? false)
              ? rightSideCheckbox
              : leftSideCheckbox,
        ),
      );

  Widget get leftSideCheckbox => Row(
        children: [
          Padding(
            child: checkboxWidget,
            padding: EdgeInsets.only(right: 8),
          ),
          widget.isExpandedText ? Expanded(child: textWidget) : textWidget,
        ],
      );

  Widget get rightSideCheckbox => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isExpandedText ? Expanded(child: textWidget) : textWidget,
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: checkboxWidget,
          ),
        ],
      );

  Widget get textWidget => Text(
        widget.text ?? "",
        textAlign: widget.textAlignment ?? TextAlign.center,
        style: widget.textStyle ?? CustomTextStyles.labelLargeOnPrimarySemiBold,
      );

  Widget get checkboxWidget => SizedBox(
        height: widget.iconSize,
        width: widget.iconSize,
        child: Checkbox(
          visualDensity: VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          value: widget.value,
          onChanged: (value) {
            widget.onChange(value!);
          },
        ),
      );
}
