import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:surety/model/banner_model.dart';
import 'package:surety/service/banner_service.dart';

class BannerProvider extends ChangeNotifier {
  BannerService _bannerService = BannerService();
  BannerModel? banner = null;

  Future<void> getBanner() async {
    try {
      final result = await _bannerService.getBanner();
      banner = result;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateBanner(File? image,BannerModel bannerModel) async {
    try {
      final result = await _bannerService.update(image,bannerModel);
      banner = result;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
