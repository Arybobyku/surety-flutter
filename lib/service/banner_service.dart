import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:surety/model/banner_model.dart';

class BannerService {
  final CollectionReference _friendsReference =
      FirebaseFirestore.instance.collection('Banner');

  Reference ref = FirebaseStorage.instance.ref("Banner");

  final bannerId = "123";

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

  Future<BannerModel> update(File? image, String url, String oldImage) async {
    try {
      final filePath =image!= null ? await saveImage(image) :"";
      var result = await _friendsReference.doc(bannerId);

      final banner = BannerModel(url: url, image: filePath);
      await result.set(banner.toJson());

      return banner;
    } catch (e) {
      rethrow;
    }
  }

  Future<BannerModel?> getBanner() async {
    try {
      DocumentSnapshot snapshot = await _friendsReference.doc(bannerId).get();
      final form = snapshot.data() != null
          ? BannerModel.fromJson((snapshot.data() as Map<String, dynamic>))
          : null;

      return form;
    } catch (e) {
      rethrow;
    }
  }
}
