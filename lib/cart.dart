import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/product_detail.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controller/cart_page_controller.dart';

class Cart extends StatefulWidget {
  final String? uid;

  const Cart({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartPageController controller = Get.put(CartPageController());

  // price counter method
  // int subTotal = 0;
  // int gst = 0;
  // int total = 0;

  // void priceCounter() {
  //   List cartData = [];
  //   FirebaseFirestore.instance
  //       .collection("cart")
  //       .where("uid", isEqualTo: widget.uid)
  //       .get()
  //       .then(
  //     (value) {
  //       for (var i in value.docs) {
  //         cartData.add(
  //           i.data(),
  //         );
  //       }
  //       int newSubTotal = 0;
  //       int newGst = 0;
  //       int newTotal = 0;
  //       for (int i = 0; i < cartData.length; i++) {
  //         newSubTotal =
  //             (newSubTotal + cartData[i]["salePrice"] * cartData[i]["qty"])
  //                 .toInt();
  //         newGst = newSubTotal * 18 ~/ 100;
  //         newTotal = newSubTotal + newGst;
  //       }
  //       setState(
  //         () {
  //           subTotal = int.parse("$newSubTotal");
  //           gst = int.parse("$newGst");
  //           total = int.parse("$newTotal");
  //         },
  //       );
  //     },
  //   );
  //   // print(cartData);
  //   // print(cartData[0]["salePrice"]);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // priceCounter();
    controller.priceCounter(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
        title: Text(
          "Cart",
          style: TextStyle(
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where("uid", isEqualTo: widget.uid)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return docs.isNotEmpty
                ? ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (
                          BuildContext context,
                          index,
                        ) {
                          var ref = docs[index];
                          int qty = ref["qty"];
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Slidable(
                              direction: Axis.horizontal,
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    icon: Icons.delete,
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: ColorConstant.primaryColor,
                                    onPressed: (BuildContext context) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return removeCartDialog(
                                            context,
                                            ref,
                                            collectionName: "cart",
                                          );
                                        },
                                      ).whenComplete(
                                        // () => priceCounter(),
                                        () => controller.priceCounter(
                                            uid: widget.uid),
                                      );
                                    },
                                  ),
                                ],
                              ),
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
                                child: Container(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${ref["salePrice"].toString()}  ",
                                                      style: TextStyle(
                                                        color: ColorConstant
                                                            .secondPrimaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      ref["mrp"].toString(),
                                                      style: TextStyle(
                                                        color: ColorConstant
                                                            .secondPrimaryColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: ColorConstant
                                                      .secondPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        if (qty > 1) {
                                                          qty--;
                                                        }
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("cart")
                                                            .doc(ref.id)
                                                            .update(
                                                          {
                                                            "qty": qty,
                                                          },
                                                        ).then(
                                                          (value) =>
                                                              // priceCounter(),
                                                              controller
                                                                  .priceCounter(
                                                            uid: widget.uid,
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove,
                                                      ),
                                                    ),
                                                    Text(
                                                      qty.toString(),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        qty++;
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("cart")
                                                            .doc(ref.id)
                                                            .update(
                                                          {
                                                            "qty": qty,
                                                          },
                                                        ).then(
                                                          (value) =>
                                                              // priceCounter(),
                                                              controller
                                                                  .priceCounter(
                                                            uid: widget.uid,
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: ColorConstant.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                "Price Detail",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.secondPrimaryColor,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "${controller.subTotal.value}",
                                    style: TextStyle(
                                      color: ColorConstant.secondPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "GST(18%)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstant.secondPrimaryColor,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      "${controller.gst.value}",
                                      style: TextStyle(
                                        color: ColorConstant.secondPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "${controller.total.value}",
                                    style: TextStyle(
                                      color: ColorConstant.secondPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            makePayment(controller.total.value);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstant.primaryColor,
                            minimumSize: const Size(
                              double.infinity,
                              45,
                            ),
                          ),
                          child: Text(
                            "Buy now",
                            style: TextStyle(
                              color: ColorConstant.secondPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Image.network(
                            "https://www.livemed.com.ng/medfiles/med-theme/assets/images/ucart.gif",
                            height: 200,
                            width: 200,
                          ),
                        ),
                        Text(
                          "Your cart is empty!",
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorConstant.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(num amount) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  style: ThemeMode.dark,
                  customerId: paymentIntentData!['customer'],
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  customerEphemeralKeySecret:
                      paymentIntentData!['ephemeralKey'],
                  merchantDisplayName: '<your-app-name>'))
          .then(
            (value) {},
          );

      ///now finally display payment sheeet
      displayPaymentSheet(videoPrice: amount);
    } catch (e, s) {
      if (kDebugMode) {
        print('exception:$e$s');
      }
    }
  }

  displayPaymentSheet({num? videoPrice}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (newValue) {
          if (kDebugMode) {
            print('payment intent${paymentIntentData!['id']}');
          }
          if (kDebugMode) {
            print('payment intent${paymentIntentData!['client_secret']}');
          }
          if (kDebugMode) {
            print('payment intent${paymentIntentData!['amount']}');
          }
          if (kDebugMode) {
            print('payment intent$paymentIntentData');
          }

          debugPrint(
              "======================================= success payment ===============");
          FirebaseFirestore.instance
              .collection("cart")
              .where("uid", isEqualTo: widget.uid)
              .get()
              .then(
            (value) {
              for (var i in value.docs) {
                FirebaseFirestore.instance
                    .collection("cart")
                    .doc(i.id)
                    .delete();
                FirebaseFirestore.instance.collection("order_summary").add(
                  {
                    "uid": widget.uid,
                    "image": i.data()["image"],
                    "mrp": i.data()["mrp"],
                    "product": i.data()["product"],
                    "qty": i.data()["qty"],
                    "salePrice": i.data()["salePrice"],
                  },
                );
              }
            },
          );
        },
      ).onError(
        (error, stackTrace) {
          if (kDebugMode) {
            print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
          }
        },
      );
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Exception/DISPLAYPAYMENTSHEET==> $e');
      }
      showDialog(
          context: context,
          builder: (_) => const CupertinoAlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  createPaymentIntent(num amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      if (kDebugMode) {
        print(body);
      }
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51MzCaWSGodUMKXcxFC8zjccZ5QRmVNaUUKqfWWFuZBtrzKArxpVyENbADm3SOR9SROppgTfzOgyiyh8nH9xduAyF00JUk0WfbI',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      if (kDebugMode) {
        print('Create Intent reponse ===> ${response.body.toString()}');
      }

      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(num amount) {
    final a = (amount) * 100;
    return a.toString();
  }
}

CupertinoAlertDialog removeCartDialog(
  BuildContext context,
  DocumentSnapshot<Map<String, dynamic>> ref, {
  String? collectionName,
  List? dataList,
  int? index,
}) {
  return CupertinoAlertDialog(
    title: Text(
      "Are you want to delete this product",
      style: TextStyle(
        color: ColorConstant.primaryColor,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "No",
          style: TextStyle(
            color: ColorConstant.primaryColor,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection(collectionName!)
              .doc(ref.id)
              .delete();
          dataList?.removeAt(index!);
          Navigator.of(context).pop();
        },
        child: Text(
          "Yes",
          style: TextStyle(
            color: ColorConstant.primaryColor,
          ),
        ),
      ),
    ],
  );
}
