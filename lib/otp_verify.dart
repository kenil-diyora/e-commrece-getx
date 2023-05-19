import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/otp_page_controller.dart';
import 'package:e_commerce/translator.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:e_commerce/widget/show_loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class OtpVerify extends StatefulWidget {
  final String verificationId;

  const OtpVerify({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  OtpPageController controller = Get.put(OtpPageController());

  // final otpKey = GlobalKey<FormState>();
  // TextEditingController? otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textToTrans(
              input: "Enter otp",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w700,
                color: ColorConstant.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 50,
              ),
              child: Form(
                key: controller.otpKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Pinput(
                        toolbarEnabled: false,
                        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
                        closeKeyboardWhenCompleted: true,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        length: 6,
                        controller: controller.otpController.value,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter otp";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showLoadingDialog(context);
                FirebaseAuth auth = FirebaseAuth.instance;

                if (controller.otpKey.currentState!.validate()) {
                  var credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: controller.otpController.value.text,
                  );
                  auth.signInWithCredential(credential).then(
                    (result) async {
                      if (kDebugMode) {
                        print('uesr   ${result.user!.uid}');
                      }
                      hideDialog(context);
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => Home(
                            uid: result.user!.uid,
                          ),
                        ),
                      );
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString(
                        "uid",
                        result.user!.uid,
                      );
                      final userData = await FirebaseFirestore.instance
                          .collection('user')
                          .where(
                            'uid',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                          )
                          .get();
                      if (userData.docs.isEmpty) {
                        FirebaseFirestore.instance
                            .collection("user")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .set(
                          {
                            "uid": result.user?.uid,
                            "email": result.user?.email,
                            "phone": result.user?.phoneNumber,
                            "photo": result.user?.photoURL,
                          },
                        );
                      }
                    },
                  ).catchError(
                    (e) {
                      hideDialog(context);
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
                input: "Verify OTP",
                style: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
