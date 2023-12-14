import 'package:flutter/material.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';

// ignore: must_be_immutable
class ShareButton extends StatelessWidget {
  String title;
  Function()? onPressed;
  ShareButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          const Icon(
            Icons.share,
            color: Colors.black,
          ),
          Text('Share', style: CustomTextStyles.bodyMediumOnPrimary)
        ],
      ),
    );
  }
}
