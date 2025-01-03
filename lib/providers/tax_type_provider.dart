import 'package:flutter/material.dart';

class TaxTypeProvider with ChangeNotifier {
  String _selectedTaxType = 'Amount'; // Default value
  String _selectedItemType = 'COUNT'; // Default value

  String get selectedTaxType => _selectedTaxType;
  String get selectedItemType => _selectedItemType;

  void setSelectedTaxType(String value) {
    _selectedTaxType = value;
    notifyListeners(); // Notify listeners about the change
  }

  void setSelectedItemType(String value) {
    _selectedItemType = value;
    notifyListeners(); // Notify listeners about the change
  }
  // void setSelectedItemType1(String value) {
  //   _selectedItemType = value;
  //   notifyListeners(); // Notify listeners about the change
  // }


}