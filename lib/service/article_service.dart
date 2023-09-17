import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:surety/model/article_model.dart';

class ArticleService {
  final CollectionReference _articleReference =
      FirebaseFirestore.instance.collection('Article');

  Reference ref = FirebaseStorage.instance.ref("Article");

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

  Future<ArticleModel> createArticle(ArticleModel article, File? image) async {
    String? path = image != null ? await saveImage(image) : null;
    article.picture = path;

    try {
      _articleReference.doc().set(article.toJson());
      return article;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ArticleModel>> getArticleByCreator(String id) async {
    try {
      QuerySnapshot result =
          await _articleReference.where("creator", isEqualTo: id).get();
      List<ArticleModel> articles = result.docs.map((e) {
        return ArticleModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      return articles;
    } catch (e) {
      rethrow;
    }
  }

  Future<ArticleModel> update(File? image, ArticleModel articleModel) async {
    try {
      final filePath =
          image != null ? await saveImage(image) : articleModel.picture;

      articleModel.picture = filePath;
      var result = await _articleReference.doc(articleModel.id);
      ;
      await result.set(articleModel.toJson());

      return articleModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ArticleModel>> getAllArticles() async {
    try {
      QuerySnapshot result = await _articleReference.get();
      List<ArticleModel> articles = result.docs.map((e) {
        return ArticleModel.fromJson(e.data() as Map<String, dynamic>, e.id);
      }).toList();
      print(articles.length);
      return articles;
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
