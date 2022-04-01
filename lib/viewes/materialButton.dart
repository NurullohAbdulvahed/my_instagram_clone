import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container materialButton({required String title,required void Function() onPressed}){
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30)),
    child: MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)),
      color: Colors.blue,
      onPressed: onPressed,
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
        ),
        child:  Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    ),
  );
}