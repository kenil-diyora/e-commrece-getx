import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PhoneNumberPageController extends GetxController {
  final formKey = GlobalKey<FormState>();
  Rx<TextEditingController> phone = TextEditingController().obs;
  RxString countryCode = "91".obs;
}