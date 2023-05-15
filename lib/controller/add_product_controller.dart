import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/show_loading_dialog.dart';

class AddProductController extends GetxController {
  // Rx<GlobalKey> key = GlobalKey<FormState>().obs;
  final key = GlobalKey<FormState>();
  Rx<TextEditingController> product = TextEditingController().obs;
  Rx<TextEditingController> mrp = TextEditingController().obs;
  Rx<TextEditingController> salePrice = TextEditingController().obs;

  RxString productImage = "".obs;

  Future<void> imagePicker(
    BuildContext context,
  ) async {
    showLoadingDialog(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child("product").child(fileName);
    if (image == null) {
      if (context.mounted) {}
      hideDialog(context);
      return;
    }
    UploadTask uploadTask = reference.putFile(File(image.path));
    try {
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      imageUrl = await snapshot.ref.getDownloadURL();
      productImage.value = imageUrl;
      if (productImage.value.isNotEmpty) {
        if (context.mounted) {}
        hideDialog(context);
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }
}
