import 'package:flutter/material.dart';

enum ButtonStyleType {primary, outline}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback actionPressed;
  final ButtonStyleType styleType;
  final Color? backgroundColor;
  final Color? textColor;
  
  CustomButton({
    required this.text,
    required this.actionPressed,
    required this.styleType,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle;
    switch (styleType) {
      case ButtonStyleType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          primary: backgroundColor ?? Colors.orange,
          shape: StadiumBorder()
        );
        break;
      case ButtonStyleType.outline:
        buttonStyle = OutlinedButton.styleFrom(
          side: BorderSide(color: backgroundColor ?? Colors.orange, width: 2),
          shape: StadiumBorder()
        );
        break;
    }
    return ElevatedButton(
      onPressed: actionPressed, 
      child: Text(text, style: TextStyle(color: textColor ?? Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
      style: buttonStyle
      );
  }
}
