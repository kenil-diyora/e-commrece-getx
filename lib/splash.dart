import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/home.dart';
import 'package:e_commerce/not_found.dart';
import 'package:e_commerce/product_detail.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme();
    initDynamicLinks();
    set();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      body: Center(
        child: Text(
          "E commerce",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: ColorConstant.primaryColor,
          ),
        ),
      ),
    );
  }

  Future<void> theme() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("theme") == true) {
      ColorConstant.primaryColor = Colors.black;
      ColorConstant.secondPrimaryColor = Colors.white60;
      ColorConstant.thirdPrimaryColor = Colors.white;
    } else if (pref.getBool("theme") == false) {
      ColorConstant.primaryColor = Colors.blueGrey;
      ColorConstant.secondPrimaryColor = Colors.blueGrey.shade100;
      ColorConstant.thirdPrimaryColor = Colors.white;
    }
  }

  void initDynamicLinks() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    debugPrint("============================                  12ardf345");

    FirebaseDynamicLinks ins = FirebaseDynamicLinks.instance;
    ins.onLink.listen(
      (event) {
        // debugPrint("=-=-2=-=-is---ins..tance.onLink--onSuccess=-");
        final Uri deepLink = event.link;
        debugPrint("URL CHECK-=-=-= $deepLink");
        String? type;
        String? id = deepLink.toString().split("/").last;
        debugPrint("============================                   $id");
        // var back=deepLink.;

        if (id.isNotEmpty) {
          //routing
          FirebaseFirestore.instance.collection('product').doc(id).get().then(
            (value) {
              debugPrint(
                "================ product =============     ${value.data()?["image"]}",
              );
              if (pref.getString("uid") == null) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              } else if (value.data() != null) {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => ProductDetail(
                      image: value.data()!["image"],
                      product: value.data()!["product"],
                      salePrice: value.data()!["salePrice"],
                      mrp: value.data()!["mrp"],
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const NotFound(),
                  ),
                );
              }
            },
          );
        } else {
          //setLoginData();
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const Login(),
            ),
          );
        }
        //setLoginData();
        // EventScreen();
      },
    ).onError((e) {});

    // debugPrint("=-=-7=-=-is---PendingDynamicLinkData=-");
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    debugPrint("=-=-8=-=-is---deepLink---$deepLink=-");
    String? type;
    String? id = deepLink.toString().split("/").last.toString();
    debugPrint("============================              3     $id");

    // debugPrint("id --- $id   $isLogin    $type");
    if (id.isNotEmpty) {
//routing
    } else {
      //setLoginData();
    }

    // setLoginData();
    /* if (deepLink != null) {
    String id = deepLink
        .toString()
        .split(
      "=",
    )
        .last;

  } else {
    // debugPrint("=-=-11=-=-is---deepLink == null=-");
    // authCheck();
    //getAppVersion();
  }*/
  }

  set() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    Timer(
      const Duration(seconds: 3),
      () {
        // print("=======================             ${pref.getString("uid")}");
        // SharedPreferences.setMockInitialValues({});
        if (context.mounted) {}
        if (pref.getString("uid") == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Home(
                uid: pref.getString("uid"),
              ),
            ),
          );
        }
      },
    );
  }
}
