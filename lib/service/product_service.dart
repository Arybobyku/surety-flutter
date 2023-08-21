import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:surety/model/product_model.dart';

class ProductService {
  final CollectionReference _articleReference =
      FirebaseFirestore.instance.collection('Product');

  Reference ref = FirebaseStorage.instance.ref("Product");

  Future<String> saveImage(File image) async {
    try {
      final metadata = SettableMetadata(
        customMetadata: {'picked-file-path': image.path},
      );

      String fileName =
          "${DateTime.now().millisecond}-${DateTime.now().minute}-${DateTime.now().hour}-${DateTime.now().day}-${DateTime.now().month}-profile";
      fileName += image.path.split('/').last;
      var result = await ref.child(fileName).putFile(image, metadata);
      String path = await result.ref.getDownloadURL();
      String profilePath = path;
      return profilePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> createProduct(ProductModel product, File? image) async {
    String? path = image != null ? await saveImage(image) : null;
    product.picture = path;

    try {
      _articleReference.doc().set(product.toJson());
      return product;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductByCreator(String id) async {
    try {
      QuerySnapshot result =
          await _articleReference.where("creator", isEqualTo: id).get();
      List<ProductModel> products = result.docs.map((e) {
        return ProductModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getAllProduct() async {
    try {
      QuerySnapshot result = await _articleReference.get();
      List<ProductModel> products = result.docs.map((e) {
        return ProductModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      print(products.length);
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _articleReference.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
