
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'profile_data_provider.dart';

class SalesDataProvider extends ChangeNotifier {

  List<Map<String, dynamic>> salesRecordList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _search = '';
  DateTime? _selectedDate;
  bool isLoading = false; // Add loading state

  String get search => _search;
  DateTime? get selectedDate => _selectedDate;

  Future<void> updateSearch(String value) async{
    _search = value;
    notifyListeners();
  }

  Future<void> updateSelectedDate(DateTime? date) async{
    _selectedDate = date;
    notifyListeners();
  }
  // Update loading state
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // // Fetch sales data from Firestore
  Future<void> fetchSalesData() async {
    setLoading(true);
    try {
      String userId = _auth.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('salesData')
          .get();

      salesRecordList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
          'timestamp': (data['timestamp'] as Timestamp).toDate(), // Always convert to DateTime
        };
      }).toList();

      salesRecordList.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp']));
      notifyListeners();
    } catch (e) {
      print("Error fetching sales data: $e");
    } finally {
      setLoading(false);
      notifyListeners();
    }

  }



// Inside SalesDataProvider class
  Future<bool> addSalesData(Map<String, dynamic> salesData) async {
    try {
      print('start ******************');
      String userId = _auth.currentUser !.uid;
      // String myItemQuantity1 = salesData['Item Quantity'].toString();
      String itemName = salesData['Item Name'];
        String quantityToSell = salesData['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
      // Extract non-numeric part
      String stringPart = salesData['Item Quantity'].toString().replaceAll(RegExp(r'[0-9]'), '') ?? '';
        int ourQuantityToSell = int.parse(quantityToSell);

      // Check if the item exists in stock
      QuerySnapshot stockSnapshot = await FirebaseFirestore.instance
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('Item Name', isEqualTo: itemName)
          .limit(1)
          .get();


      if (stockSnapshot.docs.isEmpty) {
        // Item not found in stock
        Fluttertoast.showToast(
          msg: "Invalid item: $itemName not found in stock.",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          fontSize: 20,
          textColor: Colors.white,
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_SHORT,
        );
        return false;
      }

      // Get the stock data
      Map<String, dynamic> stockData = stockSnapshot.docs.first.data() as Map<String, dynamic>;
      String currentStock = stockData['Item Stock'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';  // Default to 0 if null
      String tempQuntityType = stockData['Item Stock'].toString().replaceAll(RegExp(r'[0-9]'), '') ?? '';
      int ourCurrentStock = int.parse(currentStock);
      print('currentStock ***************=>  $ourCurrentStock');
      print('quantityToSell ***************=>  $ourQuantityToSell');
      print('quantityTypeSales ***************=>  $stringPart');
      print('quantityTypeStock ***************=>  $tempQuntityType');
      bool check = ourQuantityToSell > ourCurrentStock;
      print('check boll************* > $check');
      bool check2 = tempQuntityType != stringPart;
      print('check2 boll************* > $check2');
      String uniqueId = stockData['uniqueId'].toString();

      // Check if the quantity to sell is valid
      if ((ourQuantityToSell > ourCurrentStock) || (tempQuntityType != stringPart)) {
        print('========== go to if statement ========================');
        // Not enough stock
        Fluttertoast.showToast(
          msg: "Invalid quantity:  for $itemName.",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          fontSize: 20,
          textColor: Colors.white,
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_SHORT,
        );
        return false;
      }

      // If valid, proceed to add sales data
      salesData['timestamp'] = Timestamp.now(); // Always store as Timestamp
      salesData['uniqueId'] = uniqueId;

      DocumentReference docRef = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('salesData')
          .add(salesData);

      // Update stock quantity
      int updatedStock = ourCurrentStock - ourQuantityToSell;
      String updatedStringCombo =  updatedStock.toString() + stringPart;
      await FirebaseFirestore.instance
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .doc(stockSnapshot.docs.first.id)
          .update({'Item Stock': updatedStringCombo});

      // Add the sales data to the local list
      salesRecordList.add({
        ...salesData,
        'id': docRef.id,
      });
      notifyListeners();
      return true; // Return true on success
    } catch (e) {
      print("Error adding sales data: $e");
      return false; // Return false on error
    }
  }


  // // Update an existing sales record in Firestore
  Future<bool> updateSalesRecord(int index, Map<String, dynamic> updatedData) async {
    try {
      String userId = _auth.currentUser!.uid; // Get current user ID
      String docId = salesRecordList[index]['id']; // Fetch document ID
      // String prvItemQuantity = salesRecordList[index]['id']['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
      // int prvItemQuantityInt = int.parse(prvItemQuantity);
      print('value is ====== ${salesRecordList[index]['Item Quantity']}');
      String prvItemQuantity = salesRecordList[index]['Item Quantity'].toString();
      String numericPart = prvItemQuantity.replaceAll(RegExp(r'[^0-9]'), '');
      int prvItemQuantityInt = int.parse(numericPart);

      // String uniqueId1 = salesRecordList[index]['uniqueId']; // Get the unique ID of sell
      // Update to current timestamp
      updatedData['timestamp'] = Timestamp.now(); // Set to current timestamp
      //**********************************8
      String itemName = updatedData['Item Name'];
      // String itemPrice = updatedData['Item Amount'];
      String quantityToSell = updatedData['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
      // Extract non-numeric part
      String stringPart = updatedData['Item Quantity'].toString().replaceAll(RegExp(r'[0-9]'), '') ?? '';
      int ourQuantityToSell = int.parse(quantityToSell);
      ourQuantityToSell =    ourQuantityToSell -  prvItemQuantityInt;

      // Check if the item exists in stock
      QuerySnapshot stockSnapshot = await FirebaseFirestore.instance
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('Item Name', isEqualTo: itemName)
          .limit(1)
          .get();


      if (stockSnapshot.docs.isEmpty) {
        // Item not found in stock
        Fluttertoast.showToast(
          msg: "Invalid item: $itemName not found in stock.",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          fontSize: 20,
          textColor: Colors.white,
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_SHORT,
        );
        return false;
      }

      // Get the stock data
      Map<String, dynamic> stockData = stockSnapshot.docs.first.data() as Map<String, dynamic>;
      String currentStock = stockData['Item Stock'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';  // Default to 0 if null
      String tempQuntityType = stockData['Item Stock'].toString().replaceAll(RegExp(r'[0-9]'), '') ?? '';
      int ourCurrentStock = int.parse(currentStock);
      print('currentStock ***************=>  $ourCurrentStock');
      print('quantityToSell ***************=>  $ourQuantityToSell');
      print('quantityTypeSales ***************=>  $stringPart');
      print('quantityTypeStock ***************=>  $tempQuntityType');
      bool check = ourQuantityToSell > ourCurrentStock;
      print('check boll************* > $check');
      bool check2 = tempQuntityType != stringPart;
      print('check2 boll************* > $check2');
      String uniqueId = stockData['uniqueId'].toString();

      // Check if the quantity to sell is valid
      if ((ourQuantityToSell > ourCurrentStock) || (tempQuntityType != stringPart)) {
        print('========== go to if statement ========================');
        // Not enough stock
        Fluttertoast.showToast(
          msg: "Invalid quantity:  for $itemName.",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          fontSize: 20,
          textColor: Colors.white,
          timeInSecForIosWeb: 2,
          toastLength: Toast.LENGTH_SHORT,
        );
        return false;
      }

      // Update stock quantity
      int updatedStock = ourCurrentStock - ourQuantityToSell;
      String updatedStringCombo =  updatedStock.toString() + stringPart;


      // **************************8888

          // {'Item Stock': updatedStringCombo}
      // Update Firestore document
      await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('salesData')
          .doc(docId)
          .update(updatedData);


      // Update the local list (retain the document ID)
      salesRecordList[index] = {
        ...updatedData,
        'id': docId, // Keep the document ID intact
      };

      ProfileDataProvider profiledataprovider = ProfileDataProvider();
      // Update corresponding stock data using unique ID
      // bool? isUpdate;
      await profiledataprovider.updateStockRecordByUniqueId(uniqueId, {
        'Item Stock': updatedStringCombo,
        'Item Name': updatedData['Item Name'], // Ensure Item Name is included
      });
      notifyListeners();
      return true;
    } catch (e) {
      print("Error updating sales record: $e");
      return false;
    }
  }

  // Delete data deleteSalesRecord
  Future<bool> deleteSalesRecord(int index) async{
    try{
      String userId = _auth.currentUser!.uid; // Get current user ID
      String docId = salesRecordList[index]['id']; // Fetch document ID
      String itemName =salesRecordList[index]['Item Name'];
      String ItemQuantity = salesRecordList[index]['Item Quantity'].toString();
      String numericPart = ItemQuantity.replaceAll(RegExp(r'[^0-9]'), '');
      int prvItemQuantityInt = int.parse(numericPart);
      // String uniqueId = salesRecordList[index].toString();
      String uniqueId = salesRecordList[index]['uniqueId'].toString(); // Extract the correct unique ID

      // Check if the item exists in stock
      QuerySnapshot stockSnapshot = await FirebaseFirestore.instance
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('Item Name', isEqualTo: itemName)
          .limit(1)
          .get();


      // Get the stock data
      Map<String, dynamic> stockData = stockSnapshot.docs.first.data() as Map<String, dynamic>;
      String currentStock = stockData['Item Stock'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';  // Default to 0 if null
      String tempQuntityType = stockData['Item Stock'].toString().replaceAll(RegExp(r'[0-9]'), '') ?? '';
      int ourCurrentStock = int.parse(currentStock);
      ourCurrentStock = ourCurrentStock + prvItemQuantityInt;
      // String quantityType = '$ourCurrentStock $tempQuntityType';
      String updatedStringCombo =  ourCurrentStock.toString() + tempQuntityType;

      // Delete the document from Firestore
      await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('salesData')
          .doc(docId)
          .delete();

      // Remove the record from the local list
      salesRecordList.removeAt(index);
      print('----- updatedStringCombo $updatedStringCombo');
      print('----- unique id of sales $uniqueId');

      ProfileDataProvider profiledataprovider = ProfileDataProvider();
      // Update corresponding stock data using unique ID
      await profiledataprovider.updateStockRecordByUniqueId(uniqueId, {
        'Item Stock': updatedStringCombo,
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
      print("Error deleting sales record: $e");
    }
  }

}

/// 1234567
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SalesDataProvider extends ChangeNotifier {
//   List<Map<String, dynamic>> salesRecordList = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Map<String, int> inventory = {}; // Tracks itemName -> availableQuantity
//
//   bool isLoading = false;
//
//   void setLoading(bool value) {
//     isLoading = value;
//     notifyListeners();
//   }
//
//   // Fetch sales data from Firestore
//   Future<void> fetchSalesData() async {
//     setLoading(true);
//     try {
//       String userId = _auth.currentUser!.uid;
//       QuerySnapshot snapshot = await _firestore
//           .collection('shopOwners')
//           .doc(userId)
//           .collection('salesData')
//           .get();
//
//       salesRecordList = snapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return {
//           ...data,
//           'id': doc.id,
//           'timestamp': (data['timestamp'] as Timestamp).toDate(),
//         };
//       }).toList();
//
//       salesRecordList.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp']));
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching sales data: $e");
//     } finally {
//       setLoading(false);
//     }
//   }
//
//   // Sync inventory from purchases
//   Future<void> syncInventoryFromPurchases() async {
//     try {
//       String userId = _auth.currentUser!.uid;
//       QuerySnapshot snapshot = await _firestore
//           .collection('shopOwners')
//           .doc(userId)
//           .collection('purchaseData')
//           .get();
//
//       inventory = {};
//       for (var doc in snapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         String itemName = data['itemName'];
//         int quantity = data['quantity'];
//
//         if (inventory.containsKey(itemName)) {
//           inventory[itemName] = inventory[itemName]! + quantity;
//         } else {
//           inventory[itemName] = quantity;
//         }
//       }
//
//       // Deduct quantities sold from the inventory
//       for (var sale in salesRecordList) {
//         String itemName = sale['itemName'];
//         int quantity = sale['quantity'];
//         if (inventory.containsKey(itemName)) {
//           inventory[itemName] = inventory[itemName]! - quantity;
//         }
//       }
//     } catch (e) {
//       print("Error syncing inventory: $e");
//     }
//   }
//
//   Future<String?> addSalesData(Map<String, dynamic> salesData) async {
//     try {
//       String userId = _auth.currentUser!.uid;
//       String itemName = salesData['itemName'];
//       int quantity = salesData['quantity'];
//
//       // Validate item and quantity
//       if (!inventory.containsKey(itemName)) {
//         return "Invalid item: $itemName not found in inventory.";
//       }
//       if (inventory[itemName]! < quantity) {
//         return "Invalid quantity: Available quantity is ${inventory[itemName]}.";
//       }
//       else{
//         salesData['timestamp'] = Timestamp.now();
//         DocumentReference docRef = await _firestore
//             .collection('shopOwners')
//             .doc(userId)
//             .collection('salesData')
//             .add(salesData);
//
//         salesRecordList.add({
//           ...salesData,
//           'id': docRef.id,
//         });
//
//         // Update inventory
//         inventory[itemName] = inventory[itemName]! - quantity;
//
//         notifyListeners();
//         return 'Sucessfull'; // Success
//       }
//     } catch (e) {
//       print("Error adding sales data: $e");
//       return "Error adding sales data: $e";
//     }
//   }
//
//
//   Future<String?> updateSalesRecord(int index, Map<String, dynamic> updatedData) async {
//     try {
//       String userId = _auth.currentUser!.uid;
//       String docId = salesRecordList[index]['id'];
//       String itemName = updatedData['itemName'];
//       int newQuantity = updatedData['quantity'];
//
//       // Existing sales data
//       int existingQuantity = salesRecordList[index]['quantity'];
//
//       // Validate item and quantity
//       if (!inventory.containsKey(itemName)) {
//         return "Invalid item: $itemName not found in inventory.";
//       }
//       int adjustedInventory = inventory[itemName]! + existingQuantity; // Restore old quantity before rechecking
//       if (adjustedInventory < newQuantity) {
//         return "Invalid quantity: Available quantity is $adjustedInventory.";
//       }
//
//       // Update Firestore document
//       updatedData['timestamp'] = Timestamp.now();
//       await _firestore
//           .collection('shopOwners')
//           .doc(userId)
//           .collection('salesData')
//           .doc(docId)
//           .update(updatedData);
//
//       // Update local list and inventory
//       salesRecordList[index] = {
//         ...updatedData,
//         'id': docId,
//       };
//       inventory[itemName] = adjustedInventory - newQuantity;
//
//       notifyListeners();
//       return null; // Success
//     } catch (e) {
//       print("Error updating sales record: $e");
//       return "Error updating sales record: $e";
//     }
//   }
//
// //   // Delete data
//   Future<void> deleteSalesRecord(int index) async{
//     try{
//       String userId = _auth.currentUser!.uid; // Get current user ID
//       String docId = salesRecordList[index]['id']; // Fetch document ID
//       // Delete the document from Firestore
//       await _firestore
//           .collection('shopOwners')
//           .doc(userId)
//           .collection('salesData')
//           .doc(docId)
//           .delete();
//
//       // Remove the record from the local list
//       salesRecordList.removeAt(index);
//       notifyListeners();
//     } catch (e) {
//       print("Error deleting sales record: $e");
//     }
//   }
// }

