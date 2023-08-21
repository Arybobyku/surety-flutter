import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:surety/model/product_model.dart';
import 'package:surety/service/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductService _productService = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> productsByCreator = [];
  bool loading = true;

  Future<Either<String, bool>> createProduct(
      ProductModel product, File? image) async {
    try {
      product.createdAt = DateFormat('dd MMMM,yyyy').format(DateTime.now());
      product.creator = product.userModel!.id;
      final result = await _productService.createProduct(product, image);
      products.add(result);
      productsByCreator.add(result);
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> getAllProducts() async {
    try {
      final result = await _productService.getAllProduct();
      products = result;
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> removeProduct(String id) async {
    try {
      await _productService.remove(id);
      productsByCreator.removeWhere((element) => element.id == id);
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> getAllProductByCreator(String id) async {
    try {
      loading = true;
      final result = await _productService.getProductByCreator(id);
      productsByCreator = result;
      loading = false;
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
