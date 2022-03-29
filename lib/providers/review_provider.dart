import 'package:flutter/material.dart';
import '../controllers/review_controller.dart';

class ReviewProvider extends ChangeNotifier {


  final reviewController = ReviewController();

  void update(bool val) {
    notifyListeners();
  }
}