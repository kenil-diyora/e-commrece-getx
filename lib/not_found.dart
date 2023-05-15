import 'package:e_commerce/widget/color_constant.dart';
import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Product Detail",
        ),
        backgroundColor: ColorConstant.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Product not found!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ColorConstant.primaryColor,
          ),
        ),
      ),
    );
  }
}
