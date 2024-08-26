import 'package:fall_watch_app/widgets/customButton.dart';
import 'package:flutter/material.dart';

Widget dividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 2, color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(child: Divider(thickness: 2, color: Colors.grey)),
      ],
    );
  }
   Widget buttonDesign1(String text1, Color color, ButtonStyleType buttonStyleType, Color textColor, VoidCallback actionPressed) {
    return Container(
      height: 48,
      constraints: const BoxConstraints(minWidth: 250),
      child: CustomButton(
        actionPressed: actionPressed,
        text: text1,
        styleType: buttonStyleType,
        textColor: textColor,
        backgroundColor: color,
      ),
    );
  }

  Widget smallImageButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 45.0,
        height: 45.0,
        child: Image.asset(
          'images/google.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }