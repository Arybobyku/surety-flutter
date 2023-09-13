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

  Future<void> updateBanner(File? image,String url) async {
    try {
      final result = await _bannerService.update(image,url,banner?.image ?? "-");
      banner = result;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
