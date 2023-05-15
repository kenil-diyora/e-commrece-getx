import 'package:e_commerce/widget/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(
  BuildContext context,
) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: CupertinoActivityIndicator(
          radius: 20,
          color: ColorConstant.secondPrimaryColor,
        ),
      );
    },
  );
}

void hideDialog(
  BuildContext context,
) {
  Navigator.pop(context);
}
