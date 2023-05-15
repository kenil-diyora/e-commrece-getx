import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widget/color_constant.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetail extends StatefulWidget {
  final String image;
  final String product;
  final int salePrice;
  final int mrp;

  const ProductDetail({
    Key? key,
    required this.image,
    required this.product,
    required this.salePrice,
    required this.mrp,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.secondPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Product Detail",
          style: TextStyle(
            color: ColorConstant.secondPrimaryColor,
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
        actions: [
          IconButton(
            onPressed: () {
              String? productId;
              FirebaseFirestore.instance
                  .collection("product")
                  .where("product", isEqualTo: widget.product)
                  .get()
                  .then(
                (value) {
                  for (var i in value.docs) {
                    productId = i.id;
                  }
                  dynamicLinks(
                    id: productId,
                    image: widget.image,
                    title: widget.product,
                    des: widget.salePrice,
                  );
                },
              );
            },
            icon: Icon(
              CupertinoIcons.share,
              color: ColorConstant.secondPrimaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product,
                      style: TextStyle(
                        color: ColorConstant.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "${widget.salePrice.toString()}  ",
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            widget.mrp.toString(),
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dynamicLinks({image, title, des, id, shareContent}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://ecommercewithgetx.page.link',
      link: Uri.parse(
        'https://ecommercewithgetx.page.link/event?id=tickitId/$id',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.e_commerce1',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.packagename",
        appStoreId: "123456789",
        // minimumVersion: "1.0.1",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: '$title', description: '$des', imageUrl: Uri.parse("$image")),
    );

    FirebaseDynamicLinks ins = FirebaseDynamicLinks.instance;

    final ShortDynamicLink dynamicUrl = await ins.buildShortLink(parameters);
// final ShortDynamicLink dynamicUrl = await ins.buildShortLink(parameters);
// final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    debugPrint("${dynamicUrl.shortUrl.origin}${dynamicUrl.shortUrl.path}");
    await Share.share(
      'check out product ${dynamicUrl.shortUrl.origin}${dynamicUrl.shortUrl.path}',
      subject: widget.product,
    );
  }
}
