import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartPageController extends GetxController {
  RxInt subTotal = 0.obs;
  RxInt gst = 0.obs;
  RxInt total = 0.obs;

  void priceCounter({
  required String? uid,
}) {
    List cartData = [];
    FirebaseFirestore.instance
        .collection("cart")
        .where("uid", isEqualTo: uid)
        .get()
        .then(
          (value) {
        for (var i in value.docs) {
          cartData.add(
            i.data(),
          );
        }
        // print("c c $cartData");
        int newSubTotal = 0;
        int newGst = 0;
        int newTotal = 0;
        for (int i = 0; i < cartData.length; i++) {
          newSubTotal =
              (newSubTotal + cartData[i]["salePrice"] * cartData[i]["qty"]).toInt();
          newGst = newSubTotal * 18 ~/ 100;
          newTotal = newSubTotal + newGst;
        }
        subTotal.value = newSubTotal;
        gst.value = newGst;
        total.value = newTotal;
      },
    );
    // print(cartData);
    // print(cartData[0]["salePrice"]);
  }
}