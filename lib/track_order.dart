import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrack extends StatefulWidget {
  final String? uid;

  const OrderTrack({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<OrderTrack> createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  List<DocumentSnapshot<Map<String, dynamic>>> orderSummary = [];

  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(
      () {
        // if (controller.offset >= controller.position.maxScrollExtent &&
        //     !controller.position.outOfRange) {
        //   itemCount += 10;
        //   setState(() {});
        //   print("demo");
        // }
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
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: ColorConstant.primaryColor,
        elevation: 0,
        title: Text(
          "Track Order",
          style: TextStyle(
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: orderSummary.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: ListView.builder(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                itemCount: orderSummary.length,
                itemBuilder: (
                  BuildContext context,
                  index,
                ) {
                  var ref = orderSummary[index].data()!;
                  return Container(
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
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${ref["salePrice"].toString()}  ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              ColorConstant.secondPrimaryColor,
                                        ),
                                      ),
                                      Text(
                                        ref["mrp"].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              ColorConstant.secondPrimaryColor,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  DateFormat.yMd()
                                      .add_jm()
                                      .format(ref["created_at"].toDate())
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: ColorConstant.secondPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Image.asset(
                "assets/image/not-found.png",
                height: 500,
                width: 500,
              ),
            ),
    );
  }

  void getData() {
    FirebaseFirestore.instance
        .collection("order_summary")
        .where(
          "uid",
          isEqualTo: widget.uid,
        )
        .limit(5)
        .get()
        .then(
      (value) {
        for (var i in value.docs) {
          orderSummary.add(i);
        }
        setState(() {});
      },
    );
  }

  void getPageData() {
    FirebaseFirestore.instance
        .collection("order_summary")
        .where(
          "uid",
          isEqualTo: widget.uid,
        )
        .startAfterDocument(orderSummary[orderSummary.length - 1])
        .limit(5)
        .get()
        .then(
      (value) {
        for (var i in value.docs) {
          orderSummary.add(i);
        }
        setState(() {});
      },
    );
  }
}
