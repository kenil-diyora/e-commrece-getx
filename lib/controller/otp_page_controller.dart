import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OtpPageController extends GetxController {
  final otpKey = GlobalKey<FormState>();
  Rx<TextEditingController> otpController = TextEditingController().obs;
}