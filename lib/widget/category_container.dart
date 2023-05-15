import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_constant.dart';

Widget categoryContainer({
  String? title,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: ColorConstant.secondPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        "$title",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ColorConstant.primaryColor,
        ),
      ),
    ),
  );
}
