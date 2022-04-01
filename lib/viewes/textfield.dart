import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container textField({required String hintText,required bool isHidden,required TextEditingController controller}){
  return  Container(
    height: 50,
    padding: EdgeInsets.only(left: 10,right: 10),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(7),
    ),
    child: TextField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 15.0,color: Colors.grey)
      ),
    ),
  );
}
