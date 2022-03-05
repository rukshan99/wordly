import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class UserProvider extends ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  final userController = UserController();

  void update(bool val) {
    _isAdmin = val;
    notifyListeners();
  }
}
