import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  List productData = [];
  int itemCount = 10;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.addListener(
    //   () {
    //     // if (controller.offset >= controller.position.maxScrollExtent &&
    //     //     !controller.position.outOfRange) {
    //     //   itemCount += 10;
    //     //   setState(() {});
    //     //   print("demo");
    //     // } else {}
    //     if (controller.position.maxScrollExtent == controller.position.pixels) {
    //       itemCount += 10;
    //       setState(() {});
    //     }
    //   },
    // );
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Pagination",
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: productData.length,
        // controller: controller,
        itemBuilder: (
          BuildContext context,
          index,
        ) {
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal.shade400,
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    productData[index]["image"],
                    height: 150,
                    width: 150,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        productData[index]["product"],
                      ),
                      Row(
                        children: [
                          Text(
                            "${productData[index]["salePrice"].toString()}  ",
                          ),
                          Text(
                            productData[index]["mrp"].toString(),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void getData() {
    FirebaseFirestore.instance.collection("product").get().then(
      (value) {
        for (var i in value.docs) {
          productData.add(i.data());
          debugPrint(
            "${productData[0]["image"]}",
          );
        }
        setState(() {});
      },
    );
  }
}
