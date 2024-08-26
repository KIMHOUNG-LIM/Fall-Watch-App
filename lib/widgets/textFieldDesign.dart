import 'package:flutter/material.dart';

Widget buildTextFormField(TextEditingController controller, bool isObscure, String label, String? Function(String?)? validateRule) {
    return Container(
      width: 300,
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color.fromRGBO(230, 81, 0, 1)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black38),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
        obscureText: isObscure,
        validator: validateRule,
      ),
    );
  }