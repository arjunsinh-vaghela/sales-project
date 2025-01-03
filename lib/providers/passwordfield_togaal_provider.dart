import 'package:flutter/cupertino.dart';

class PasswordfieldTogaalProvider extends ChangeNotifier {
  bool _isHide = true;
  bool get isHide => _isHide;

  void toToggal(){
    _isHide = !_isHide;
    notifyListeners();
  }
}