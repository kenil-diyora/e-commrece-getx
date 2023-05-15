import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/add_product_controller.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:e_commerce/widget/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddProduct extends StatelessWidget {
  AddProduct({Key? key}) : super(key: key);

  final AddProductController controller = Get.put(AddProductController());

  // String? productImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
        title: Text(
          "Add product",
          style: TextStyle(
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Form(
            key: controller.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product title",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter product title";
                      }
                      return null;
                    },
                    controller: controller.product.value,
                    style: TextStyle(
                      color: ColorConstant.primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: ColorConstant.primaryColor,
                      ),
                      hintText: "Enter product title",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorConstant.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "MRP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter product mrp";
                      }
                      return null;
                    },
                    controller: controller.mrp.value,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: ColorConstant.primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: ColorConstant.primaryColor,
                      ),
                      hintText: "Enter password",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorConstant.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Sale price",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter sale price";
                      }
                      return null;
                    },
                    controller: controller.salePrice.value,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: ColorConstant.primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: ColorConstant.primaryColor,
                      ),
                      hintText: "Enter sale price",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorConstant.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Product image",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.imagePicker(context);
                  },
                  child: Container(
                    height: 100,
                    width: 180,
                    margin: const EdgeInsets.only(
                      top: 20,
                      bottom: 50,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConstant.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.primaryColor.withOpacity(0.06),
                          offset: const Offset(0, 16),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Obx(
                      () => controller.productImage.value.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: Image.asset(
                                    "assets/image/camera 1.png",
                                    height: 31,
                                    width: 31,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                                Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                controller.productImage.value,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.key.currentState!.validate() &&
                        controller.productImage.value.isNotEmpty) {
                      FirebaseFirestore.instance.collection("product").add(
                        {
                          "image": controller.productImage.value,
                          "mrp": int.parse(controller.mrp.value.text),
                          "product": controller.product.value.text,
                          "salePrice":
                              int.parse(controller.salePrice.value.text),
                        },
                      ).then(
                        (value) {
                          hideDialog(context);
                        },
                      );
                      Fluttertoast.showToast(
                        msg: "Product add successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: ColorConstant.primaryColor,
                        textColor: ColorConstant.secondPrimaryColor,
                        fontSize: 16.0,
                      );
                      controller.productImage.value = "";
                    } else if (controller.productImage.value.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Select product image",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: ColorConstant.primaryColor,
                        textColor: ColorConstant.secondPrimaryColor,
                        fontSize: 16.0,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(
                      double.infinity,
                      45,
                    ),
                    backgroundColor: ColorConstant.primaryColor,
                  ),
                  child: Text(
                    "Add product",
                    style: TextStyle(
                      color: ColorConstant.secondPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
