import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:surety/model/article_model.dart';
import 'package:surety/service/article_service.dart';

class ArticleProvider extends ChangeNotifier {
  ArticleService _articleService = ArticleService();
  List<ArticleModel> articles = [];
  List<ArticleModel> articlesByCreator = [];
  bool loading = true;

  Future<Either<String, bool>> createArticle(
      ArticleModel article, File? image) async {
    try {
      article.createdAt = DateFormat('dd MMMM,yyyy').format(DateTime.now());
      article.creator = article.userModel!.id;
      final result = await _articleService.createArticle(article, image);
      articles.add(result);
      articlesByCreator.add(result);
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> getAllArticles() async {
    try {
      final result = await _articleService.getAllArticles();
      articles = result;
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> removeArticle(String id) async {
    try {
       await _articleService.remove(id);
      articlesByCreator.removeWhere((element) => element.id == id);
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> getAllArticlesByCreator(String id) async {
    try {
      loading = true;
      final result = await _articleService.getArticleByCreator(id);
      articlesByCreator = result;
      loading = false;
      notifyListeners();
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
