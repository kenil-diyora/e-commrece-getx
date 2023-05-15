import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/login_page_controller.dart';
import 'package:e_commerce/phone_number.dart';
import 'package:e_commerce/sign_up.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:e_commerce/widget/show_loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginPageController controller = Get.put(LoginPageController());
  final key = GlobalKey<FormState>();

  // final key = GlobalKey<FormState>();
  // TextEditingController? email = TextEditingController();
  // TextEditingController? password = TextEditingController();

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
                child: Text(
                  "Login",
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
                      top: 80,
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
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your email";
                                }
                                return null;
                              },
                              controller: controller.email.value,
                              decoration: InputDecoration(
                                hintText: "Enter email",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorConstant.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter password";
                                }
                                return null;
                              },
                              controller: controller.password.value,
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: ColorConstant.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.primaryColor,
                              minimumSize: const Size(
                                double.infinity,
                                45,
                              ),
                            ),
                            onPressed: () async {
                              // if(mounted){}
                              debugPrint(
                                  "=========== =================   =====     ${FirebaseMessaging.instance.getToken()}");
                              if (key.currentState!.validate()) {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: controller.email.value.text,
                                    password: controller.password.value.text,
                                  );
                                  // print("hello                          ${credential.user?.uid}");
                                  if (mounted) {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) => Home(
                                          uid: credential.user?.uid,
                                        ),
                                      ),
                                    );
                                  }
                                  Fluttertoast.showToast(
                                    msg: "Login success",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: ColorConstant.primaryColor,
                                    textColor: ColorConstant.secondPrimaryColor,
                                    fontSize: 16.0,
                                  );
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                    "uid",
                                    "${credential.user?.uid}",
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    Fluttertoast.showToast(
                                      msg: "No user found for that email.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          ColorConstant.primaryColor,
                                      textColor:
                                          ColorConstant.secondPrimaryColor,
                                      fontSize: 16.0,
                                    );
                                  } else if (e.code == 'wrong-password') {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Wrong password provided for that user.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          ColorConstant.primaryColor,
                                      textColor:
                                          ColorConstant.secondPrimaryColor,
                                      fontSize: 16.0,
                                    );
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "Login",
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    signup();
                                  },
                                  child: Container(
                                    height: 45,
                                    margin: const EdgeInsets.only(
                                      top: 15,
                                      right: 7.5,
                                      bottom: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorConstant.secondPrimaryColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/image/google1.png",
                                      height: 50,
                                      width: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const PhoneNumber(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                      height: 45,
                                      margin: const EdgeInsets.only(
                                        top: 15,
                                        left: 7.5,
                                        bottom: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorConstant.secondPrimaryColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.call,
                                        size: 24,
                                        color: ColorConstant.primaryColor,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Need an account?",
                                style: TextStyle(
                                  color: ColorConstant.primaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => const SignUP(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    color: ColorConstant.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     ElevatedButton(
                          //       onPressed: () async {
                          //         try {
                          //           final credential = await FirebaseAuth
                          //               .instance
                          //               .createUserWithEmailAndPassword(
                          //             email: "a@gmail.com",
                          //             password: "Kenil@1234",
                          //           );
                          //           debugPrint(
                          //               "========================     $credential");
                          //         } on FirebaseAuthException catch (e) {
                          //           if (e.code == 'weak-password') {
                          //             print(
                          //                 'The password provided is too weak.');
                          //           } else if (e.code ==
                          //               'email-already-in-use') {
                          //             print(
                          //                 'The account already exists for that email.');
                          //           }
                          //         } catch (e) {
                          //           print(e);
                          //         }
                          //       },
                          //       child: const Text(
                          //         "sign up",
                          //       ),
                          //     ),
                          //     ElevatedButton(
                          //       onPressed: () async {
                          //         try {
                          //           final credential = await FirebaseAuth
                          //               .instance
                          //               .signInWithEmailAndPassword(
                          //             email: "a@gmail.com",
                          //             password: "Kenil@1234",
                          //           );
                          //           debugPrint("======================        $credential");
                          //         } on FirebaseAuthException catch (e) {
                          //           if (e.code == 'user-not-found') {
                          //             print('No user found for that email.');
                          //           } else if (e.code == 'wrong-password') {
                          //             print(
                          //                 'Wrong password provided for that user.');
                          //           }
                          //         }
                          //       },
                          //       child: const Text(
                          //         "Login",
                          //       ),
                          //     ),
                          //   ],
                          // ),
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

  Future<void> signup() async {
    showLoadingDialog(context);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        // Getting users credential.
        UserCredential result =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        User? user = result.user;
        if (user != null) {
          // googleLogin(account: user);
          debugPrint("${FirebaseAuth.instance.currentUser?.uid}");
          final userSnapshot = await FirebaseFirestore.instance
              .collection('user')
              .where(
                'uid',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid,
              )
              .get();
          if (userSnapshot.docs.isEmpty) {
            FirebaseFirestore.instance
                .collection("user")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .set(
              {
                "uid": FirebaseAuth.instance.currentUser?.uid,
                "email": FirebaseAuth.instance.currentUser?.email,
                "phone": FirebaseAuth.instance.currentUser?.phoneNumber,
                "photo": FirebaseAuth.instance.currentUser?.photoURL,
              },
            );
            if (mounted) {
              hideDialog(context);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => Home(
                    uid: FirebaseAuth.instance.currentUser?.uid,
                  ),
                ),
              );
            }
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString(
              "uid",
              "${FirebaseAuth.instance.currentUser?.uid}",
            );
          } else {
            if (mounted) {
              hideDialog(context);
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => Home(
                    uid: FirebaseAuth.instance.currentUser?.uid,
                  ),
                ),
              );
            }
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString(
              "uid",
              "${FirebaseAuth.instance.currentUser?.uid}",
            );
          }
        }
      } else {
        if (mounted) {
          hideDialog(context);
        }
      }
    } catch (e) {
      hideDialog(context);
      // debugPrint('error = $e');
    }
  }
}
