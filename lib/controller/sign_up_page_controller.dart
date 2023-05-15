import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpPageController extends GetxController {
  final key = GlobalKey<FormState>();
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;
  Rx<TextEditingController> confirmPassword = TextEditingController().obs;
}