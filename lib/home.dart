import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/add_product.dart';
import 'package:e_commerce/cart.dart';
import 'package:e_commerce/chat_screen.dart';
import 'package:e_commerce/favorite.dart';
import 'package:e_commerce/login.dart';
import 'package:e_commerce/product_detail.dart';
import 'package:e_commerce/track_order.dart';
import 'package:e_commerce/translator.dart';
import 'package:e_commerce/widget/category_container.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/language.dart';

final DecorationTween _tween = DecorationTween(
  begin: const BoxDecoration(
      // color: CupertinoColors.systemYellow,
      // boxShadow: const <BoxShadow>[],
      // borderRadius: BorderRadius.circular(20.0),
      ),
  end: const BoxDecoration(
      // color: CupertinoColors.systemYellow,
      // boxShadow: CupertinoContextMenu.kEndBoxShadow,
      // borderRadius: BorderRadius.circular(20.0),
      ),
);

class Home extends StatefulWidget {
  final String? uid;

  const Home({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Or just do this inline in the builder below?
  static Animation<Decoration> _boxDecorationAnimation(
      Animation<double> animation) {
    return _tween.animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          0.0,
          CupertinoContextMenu.animationOpensAt,
        ),
      ),
    );
  }

  // HomePageController controller = Get.put(HomePageController());

  // void localStorage() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  // }

  List<DocumentSnapshot<Map<String, dynamic>>> productData = [];

  // int itemCount = 10;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    languageData();
    getCurrentLanguage();
    controller.addListener(
      () {
        // if (controller.offset >= controller.position.maxScrollExtent &&
        //     !controller.position.outOfRange) {
        //   itemCount += 10;
        //   setState(() {});
        //   print("demo");
        // } else {}
        if (controller.position.maxScrollExtent == controller.position.pixels) {
          // itemCount += 10;
          // setState(() {});
          getPageData();
        }
      },
    );
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
          ),
        ),
        backgroundColor: ColorConstant.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            categoryContainer(
              onTap: () {
                widget.uid == "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                    ? Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => AddProduct(),
                        ),
                      )
                    : Navigator.of(context).pop();
              },
              title: widget.uid == "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                  ? "Add product"
                  : "Product",
            ),
            categoryContainer(
              onTap: () {
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (context) => const Chat(),
                //   ),
                // );
                widget.uid == "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                    ? Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const ChatScreen(
                            receiverId: "User",
                            name: "User",
                            senderId: "Admin",
                          ),
                        ),
                      )
                    : Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const ChatScreen(
                            receiverId: "Admin",
                            name: "Admin",
                            senderId: "User",
                          ),
                        ),
                      );
              },
              title: "Chat",
            ),
            widget.uid == "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                ? categoryContainer(title: "Orders", onTap: () {})
                : const SizedBox(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 10,
            //   ),
            //   child: textToTrans(
            //     input: 'Hello',
            //     style: null,
            //   ),
            // ),
            categoryContainer(
              onTap: () {
                showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        color: ColorConstant.primaryColor,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            textToTrans(
                              input: 'Select language',
                              isCenterText: true,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.secondPrimaryColor,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: textToTrans(
                                  input: "Popular language",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: fevList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString(
                                      "language",
                                      fevList[index]["code"],
                                    );
                                    getCurrentLanguage();
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(
                                      15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: ColorConstant.secondPrimaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          fevList[index]["language"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstant.primaryColor,
                                          ),
                                        ),
                                        languageCode ==
                                                    fevList[index]["code"] ||
                                                (languageCode == null &&
                                                    fevList[index]
                                                            ["language"] ==
                                                        "English")
                                            ? Icon(
                                                Icons.check_circle,
                                                color:
                                                    ColorConstant.primaryColor,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: textToTrans(
                                  input: "Other language",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: remainList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString(
                                      "language",
                                      remainList[index]["code"],
                                    );
                                    getCurrentLanguage();
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(
                                      15,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: ColorConstant.secondPrimaryColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          remainList[index]["language"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstant.primaryColor,
                                          ),
                                        ),
                                        languageCode ==
                                                remainList[index]["code"]
                                            ? Icon(
                                                Icons.check_circle,
                                                color:
                                                    ColorConstant.primaryColor,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              title: "Language",
            ),
            widget.uid != "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                ? categoryContainer(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => OrderTrack(
                            uid: widget.uid,
                          ),
                        ),
                      );
                    },
                    title: "Track Order",
                  )
                : const SizedBox(),
            categoryContainer(
              onTap: () async {
                final GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.signOut();
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.clear();
                if (context.mounted) {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Login(),
                  //   ),
                  //   (route) => false,
                  // );
                  Get.offAll(() => const Login());
                }
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (context) => const Login(),
                //   ),
                // );
              },
              title: "Log out",
            ),
          ],
        ),
      ),
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: ColorConstant.primaryColor,
        elevation: 0,
        title: Text(
          "eCommerce",
          style: TextStyle(
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
        actions: [
          widget.uid == "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => AddProduct(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: ColorConstant.secondPrimaryColor,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Get.isDarkMode
                    //         ? Get.changeTheme(
                    //       ThemeData.light(),
                    //     )
                    //         : Get.changeTheme(
                    //       ThemeData.dark(),
                    //     );
                    //     debugPrint("=== === ==  ${Get.isDarkMode}");
                    //   },
                    //   icon: Icon(
                    //     Icons.light_mode,
                    //     color: ColorConstant.secondPrimaryColor,
                    //   ),
                    // ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => Favorite(uid: widget.uid),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: ColorConstant.secondPrimaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => Cart(
                              uid: widget.uid,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: ColorConstant.secondPrimaryColor,
                      ),
                    ),
                  ],
                ),
          IconButton(
            onPressed: () async {
              // if (Get.isDarkMode) {
              //   ColorConstant.primaryColor = Colors.black;
              //   ColorConstant.secondPrimaryColor = Colors.white60;
              // } else {
              //   ColorConstant.primaryColor = Colors.blueGrey;
              //   ColorConstant.secondPrimaryColor =
              //       Colors.blueGrey.shade100;
              // }
              // controller.localStorage();
              Get.isDarkMode
                  ? Get.changeTheme(
                      ThemeData.light(),
                    )
                  : Get.changeTheme(
                      ThemeData.dark(),
                    );
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool(
                "theme",
                Get.isDarkMode,
              );
              if (prefs.getBool("theme") == true) {
                ColorConstant.primaryColor = Colors.black;
                ColorConstant.secondPrimaryColor = Colors.white60;
                ColorConstant.thirdPrimaryColor = Colors.white;
              } else if (prefs.getBool("theme") == false) {
                ColorConstant.primaryColor = Colors.blueGrey;
                ColorConstant.secondPrimaryColor = Colors.blueGrey.shade100;
                ColorConstant.thirdPrimaryColor = Colors.white;
              }
              debugPrint("=== === ==  ${Get.isDarkMode}");
            },
            icon: Icon(
              Icons.light_mode,
              color: ColorConstant.secondPrimaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: ListView.builder(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          itemCount: productData.length,
          itemBuilder: (
            BuildContext context,
            index,
          ) {
            var ref = productData[index].data()!;
            // IconData favorite = Icons.favorite_border;
            // void fav() {
            //   List fa = [];
            //
            //   FirebaseFirestore.instance
            //       .collection("favorite")
            //       .where("uid", isEqualTo: widget.uid)
            //       .get()
            //       .then(
            //     (value) {
            //       for (var i in value.docs) {
            //         fa.add(i.data());
            //       }
            //       for (int i = 0; i < fa.length; i++) {
            //         if (fa[index]["product"] == ref["product"]) {
            //           favorite = Icons.favorite;
            //           setState(() {});
            //         } else {
            //           favorite = Icons.favorite_border;
            //           setState(() {});
            //         }
            //       }
            //     },
            //   );
            // }

            return CupertinoContextMenu.builder(
              actions: widget.uid == "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                  ? [
                      CupertinoContextMenuAction(
                        onPressed: () {
                          addToCart(
                              product: ref["product"],
                              image: ref["image"],
                              mrp: ref["mrp"],
                              salePrice: ref["salePrice"]);
                          Navigator.pop(context);
                        },
                        isDefaultAction: true,
                        trailingIcon: Icons.edit,
                        child: textToTrans(
                          input: "Edit product",
                          style: null,
                        ),
                      ),
                      CupertinoContextMenuAction(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return removeCartDialog(
                                context,
                                productData[index],
                                collectionName: "product",
                                dataList: productData,
                                index: index,
                              );
                            },
                          ).whenComplete(() => setState(() {}));
                        },
                        isDestructiveAction: true,
                        trailingIcon: CupertinoIcons.delete_solid,
                        child: textToTrans(
                          input: "Delete product",
                          style: null,
                        ),
                      ),
                    ]
                  : [
                      CupertinoContextMenuAction(
                        onPressed: () {
                          addToCart(
                              product: ref["product"],
                              image: ref["image"],
                              mrp: ref["mrp"],
                              salePrice: ref["salePrice"]);
                          Navigator.pop(context);
                        },
                        isDefaultAction: true,
                        trailingIcon: CupertinoIcons.cart_fill,
                        child: textToTrans(
                          input: "Add to cart",
                          style: null,
                        ),
                      ),
                      CupertinoContextMenuAction(
                        onPressed: () {
                          addToFavorite(
                            salePrice: ref["salePrice"],
                            mrp: ref["mrp"],
                            image: ref["image"],
                            product: ref["product"],
                          );
                          Navigator.pop(context);
                        },
                        isDestructiveAction: true,
                        trailingIcon: CupertinoIcons.heart_fill,
                        child: textToTrans(
                          input: "Add to favorite",
                          style: null,
                        ),
                      ),
                    ],
              builder: (BuildContext context, Animation<double> animation) {
                final Animation<Decoration> boxDecorationAnimation =
                    _boxDecorationAnimation(animation);

                return Container(
                  decoration:
                      animation.value < CupertinoContextMenu.animationOpensAt
                          ? boxDecorationAnimation.value
                          : null,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ProductDetail(
                            image: ref["image"],
                            product: ref["product"],
                            salePrice: ref["salePrice"],
                            mrp: ref["mrp"],
                          ),
                        ),
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorConstant.primaryColor,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    ref["image"],
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          ref["product"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: ColorConstant
                                                .secondPrimaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              textToTrans(
                                                input:
                                                    "${ref["salePrice"].toString()}  ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorConstant
                                                      .secondPrimaryColor,
                                                ),
                                              ),
                                              textToTrans(
                                                input: ref["mrp"].toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorConstant
                                                      .secondPrimaryColor,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.uid !=
                                                "tuMQxWrOPFNNiU7IJxx0CracUhJ3"
                                            ? TextButton(
                                                onPressed: () {
                                                  addToCart(
                                                    image: ref["image"],
                                                    mrp: ref["mrp"],
                                                    product: ref["product"],
                                                    salePrice: ref["salePrice"],
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: ColorConstant
                                                      .secondPrimaryColor,
                                                ),
                                                child: textToTrans(
                                                  input: "Add to cart",
                                                  style: TextStyle(
                                                    color: ColorConstant
                                                        .primaryColor,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                            ),
                            child: IconButton(
                              onPressed: () {
                                addToFavorite(
                                  salePrice: ref["salePrice"],
                                  mrp: ref["mrp"],
                                  image: ref["image"],
                                  product: ref["product"],
                                );
                              },
                              icon: Icon(
                                Icons.favorite_border,
                                // favorite,
                                color: ColorConstant.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void addToFavorite({
    String? product,
    String? image,
    int? mrp,
    int? salePrice,
  }) {
    List tempItemFavoriteList = [];
    FirebaseFirestore.instance
        .collection("favorite")
        .where("uid", isEqualTo: widget.uid)
        .where("product", isEqualTo: product)
        .get()
        .then(
      (value) {
        for (var itemFavorite in value.docs) {
          tempItemFavoriteList.add(
            itemFavorite.data(),
          );
          // print(
          //     "======================             ${itemFavorite.data()}");
        }
        // String? id1;
        // final fav = FirebaseFirestore.instance
        //     .collection('favorite')
        //     .doc();
        // final docId = fav.id;
        // print(docId);
        // print("=====================          ${tempItemFavoriteList[0]["favorite"]}");
        if (tempItemFavoriteList.isEmpty) {
          FirebaseFirestore.instance
              .collection("favorite")
              .doc("$product + ${widget.uid}")
              .set(
            {
              "image": image,
              "mrp": mrp,
              "product": product,
              "salePrice": salePrice,
              "uid": widget.uid,
              "favorite": true,
            },
          );
          if (kDebugMode) {
            print("add");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorConstant.primaryColor,
              content: textToTrans(
                input: "Add to favorite",
                style: TextStyle(
                  color: ColorConstant.secondPrimaryColor,
                ),
              ),
              action: SnackBarAction(
                label: "View",
                textColor: ColorConstant.thirdPrimaryColor,
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => Favorite(
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          FirebaseFirestore.instance
              .collection("favorite")
              .doc("$product + ${widget.uid}")
              .delete();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorConstant.primaryColor,
              content: textToTrans(
                input: "Remove item from favorite",
                style: TextStyle(
                  color: ColorConstant.secondPrimaryColor,
                ),
              ),
              action: SnackBarAction(
                label: "View",
                textColor: ColorConstant.thirdPrimaryColor,
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => Favorite(
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          if (kDebugMode) {
            print("delete");
          }
        }
      },
    );
    // fav();
  }

  void addToCart({
    String? image,
    int? mrp,
    String? product,
    int? salePrice,
  }) {
    List tempCartList = [];
    FirebaseFirestore.instance
        .collection("cart")
        .where("uid", isEqualTo: widget.uid)
        .where("product", isEqualTo: product)
        .get()
        .then(
      (value) {
        for (var cartInformation in value.docs) {
          tempCartList.add(cartInformation.data());
        }
        if (tempCartList.isEmpty) {
          FirebaseFirestore.instance.collection("cart").add(
            {
              "image": image,
              "mrp": mrp,
              "product": product,
              "salePrice": salePrice,
              "qty": 1,
              "uid": widget.uid,
            },
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorConstant.primaryColor,
              content: textToTrans(
                input: "Cart add successfully",
                style: TextStyle(
                  color: ColorConstant.secondPrimaryColor,
                ),
              ),
              action: SnackBarAction(
                label: "View cart",
                textColor: ColorConstant.thirdPrimaryColor,
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => Cart(
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorConstant.primaryColor,
              content: textToTrans(
                input: "Product already in cart",
                style: TextStyle(
                  color: ColorConstant.secondPrimaryColor,
                ),
              ),
              action: SnackBarAction(
                label: "View cart",
                textColor: ColorConstant.thirdPrimaryColor,
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => Cart(
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  // void _showActionSheet(
  //     BuildContext context, {
  //       required void Function() yes,
  //       required void Function() no,
  //     }) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoActionSheet(
  //       title: const Text("Are you sure you want to exit"),
  //       // message: const Text('Message'),
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           /// This parameter indicates the action would be a default
  //           /// defualt behavior, turns the action's text to bold text.
  //           isDefaultAction: true,
  //           onPressed: no,
  //           child: const Text("No"),
  //         ),
  //         // CupertinoActionSheetAction(
  //         //   onPressed: () {
  //         //     Navigator.pop(context);
  //         //   },
  //         //   child: const Text('Action'),
  //         // ),
  //         CupertinoActionSheetAction(
  //           /// This parameter indicates the action would perform
  //           /// a destructive action such as delete or exit and turns
  //           /// the action's text color to red.
  //           isDestructiveAction: true,
  //           onPressed: yes,
  //           child: const Text("Yes"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void getData() {
    FirebaseFirestore.instance.collection("product").limit(5).get().then(
      (value) {
        for (var i in value.docs) {
          productData.add(i);
        }
        setState(() {});
      },
    );
  }

  void getPageData() {
    FirebaseFirestore.instance
        .collection("product")
        .startAfterDocument(productData[productData.length - 1])
        .limit(5)
        .get()
        .then(
      (value) {
        for (var i in value.docs) {
          productData.add(i);
        }
        setState(() {});
      },
    );
  }
}
