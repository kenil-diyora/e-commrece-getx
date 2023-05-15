import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/product_detail.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  final String? uid;

  const Favorite({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstant.primaryColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        )),
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
          "Favorite item",
          style: TextStyle(
            color: ColorConstant.secondPrimaryColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('favorite')
            .where("uid", isEqualTo: widget.uid)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView(
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
                    return Padding(
                      padding: const EdgeInsets.all(10),
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
                                          color:
                                              ColorConstant.secondPrimaryColor,
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
                                                    TextDecoration.lineThrough,
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
                    );
                  },
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
