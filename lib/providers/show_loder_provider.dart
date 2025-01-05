import 'package:flutter/cupertino.dart';

class ShowLoaderProvider extends ChangeNotifier {
  bool showOurLoader = false;

  // Update loading state
  void setLoading(bool value) {
    showOurLoader = value;
    notifyListeners();
  }
}