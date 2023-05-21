import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton(
      {Key? key,
      this.onPressed,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor,
      required this.text})
      : super(key: key);

  final void Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          height: 27,
          width: double.infinity,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
