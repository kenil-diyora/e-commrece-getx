import 'package:e_commerce/controller/phone_number_page_controller.dart';
import 'package:e_commerce/otp_verify.dart';
import 'package:e_commerce/translator.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:e_commerce/widget/show_loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  PhoneNumberPageController controller = Get.put(PhoneNumberPageController());

  // final formKey = GlobalKey<FormState>();
  // TextEditingController? phone = TextEditingController();
  // String countryCode = "91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.all(50),
                alignment: Alignment.bottomLeft,
                child: textToTrans(
                  input: "Enter number",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.thirdPrimaryColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstant.secondPrimaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height / 1.59,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                      left: 30,
                    ),
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.thirdPrimaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: TextFormField(
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: ColorConstant.primaryColor,
                              ),
                              controller: controller.phone.value,
                              validator: (value) {
                                if (value!.length < 10) {
                                  return "Enter valid phone number";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                // constraints: const BoxConstraints(
                                //   maxHeight: 45,
                                // ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode: true,
                                        onSelect: (
                                          Country country,
                                        ) {
                                          controller.countryCode.value =
                                              country.phoneCode;
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(
                                          () => textToTrans(
                                            input:
                                                "+${controller.countryCode.value}",
                                            style: TextStyle(
                                              color: ColorConstant.primaryColor,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: ColorConstant.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                hintText: "Enter your mobile number",
                                hintStyle: TextStyle(
                                  color: ColorConstant.secondPrimaryColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorConstant.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                showLoadingDialog(context);
                                FirebaseAuth auth = FirebaseAuth.instance;

                                auth.verifyPhoneNumber(
                                  phoneNumber:
                                      "+${controller.countryCode.value}${controller.phone.value.text}",
                                  timeout: const Duration(seconds: 120),
                                  verificationCompleted:
                                      (AuthCredential authCredential) {
                                    auth
                                        .signInWithCredential(authCredential)
                                        .then(
                                      (result) {
                                        if (kDebugMode) {
                                          print('uesr   ${result.user}');
                                        }
                                      },
                                    ).catchError(
                                      (e) {
                                        //error
                                        if (kDebugMode) {
                                          print(e);
                                        }
                                        hideDialog(context);
                                      },
                                    );
                                  },
                                  verificationFailed: (
                                    authException,
                                  ) {
                                    if (kDebugMode) {
                                      print(authException.message);
                                    }
                                    hideDialog(context);
                                  },
                                  codeSent: (
                                    String verificationId,
                                    int? forceResendingToken,
                                  ) {
                                    // debugPrint(
                                    //   "verificationid              $verificationId",
                                    // );
                                    // debugPrint(
                                    //   "forceResendingToken                   $forceResendingToken",
                                    // );
                                    hideDialog(context);
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => OtpVerify(
                                          verificationId: verificationId,
                                        ),
                                      ),
                                    );
                                  },
                                  codeAutoRetrievalTimeout: (
                                    String verificationId,
                                  ) {
                                    if (kDebugMode) {
                                      print(verificationId);
                                    }
                                    if (kDebugMode) {
                                      print("Timout");
                                    }
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.primaryColor,
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                45,
                              ),
                            ),
                            child: textToTrans(
                              input: "Send otp",
                              style: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
