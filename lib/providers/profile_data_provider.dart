
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
///************************
class ProfileDataProvider extends ChangeNotifier{
  List<Map<String, dynamic>> stockRecordList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _search = '';
  DateTime? _selectedDate;
  bool isLoading = false; // Add loading state
  // Generate a unique identifier for the item
  // String uniqueId = Uuid().v4(); // Generate a unique ID

  // ProfileDataProvider profiledataprovider = ProfileDataProvider();

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

  Future<void> addStockData(Map<String, dynamic> stockData) async {
    try{
      String userId = _auth.currentUser!.uid;
      // Add a timestamp to the purchase data
      stockData['timestamp'] = Timestamp.now(); // Use Timestamp.now() instead of FieldValue.serverTimestamp()
      // Add data to Firestore and get the document reference
      DocumentReference docRef = await _firestore.collection('shopOwners').doc(userId).collection('stockData').add(stockData);
      // Add the document data along with the generated ID to the local list
      stockRecordList.add({
        ...stockData,
        'id': docRef.id, // Include the document ID
        // 'timestamp': (stockData['timestamp'] as Timestamp).toDate(), // Convert to DateTime i think optional
      });
      fetchStockData();
      notifyListeners();
    }catch(e){
      print("Error adding stock data: $e");
    }
  }
  // Future<void> addStockData(Map<String, dynamic> stockData) async {
  //   try {
  //     String userId = _auth.currentUser!.uid;
  //
  //     print("Attempting to add stock data: $stockData");
  //
  //     stockData['timestamp'] = Timestamp.now();
  //
  //     DocumentReference docRef = await _firestore
  //         .collection('shopOwners')
  //         .doc(userId)
  //         .collection('stockData')
  //         .add(stockData);
  //
  //     stockRecordList.add({
  //       ...stockData,
  //       'id': docRef.id,
  //     });
  //
  //     print("Stock data added successfully: ${docRef.id}");
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error adding stock data: $e");
  //   }
  // }



  // Delete data
  Future<void> deleteStockRecord(int index) async{
    try{
      String userId = _auth.currentUser!.uid; // Get current user ID
      String docId = stockRecordList[index]['id']; // Fetch document ID
      // Delete the document from Firestore
      await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .doc(docId)
          .delete();

      // Remove the record from the local list
      stockRecordList.removeAt(index);
      notifyListeners();
    } catch (e) {
      print("Error deleting stock record: $e");
    }
  }

  Future<void> reduceStockByName(String itemName, int quantityToDeduct) async {
    try {
      String userId = _auth.currentUser!.uid;

      // Find the stock record by Item Name
      QuerySnapshot snapshot = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('Item Name', isEqualTo: itemName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;
        Map<String, dynamic> stockData = snapshot.docs.first.data() as Map<String, dynamic>;
        int currentStock = stockData['Item Stock'] ?? 0;

        // Calculate the new stock quantity
        int updatedStock = currentStock - quantityToDeduct;
        if (updatedStock > 0) {
          // Update the stock record in Firestore
          await _firestore
              .collection('shopOwners')
              .doc(userId)
              .collection('stockData')
              .doc(docId)
              .update({'Item Stock': updatedStock, 'timestamp': Timestamp.now()});

          // Update the local list (optional for UI sync)
          int index = stockRecordList.indexWhere((stock) => stock['id'] == docId);
          if (index != -1) {
            stockRecordList[index]['Item Stock'] = updatedStock;
            stockRecordList[index]['timestamp'] = Timestamp.now();
            notifyListeners();
          }
        } else {
          // If stock becomes 0 or less, delete the stock record
          await _firestore
              .collection('shopOwners')
              .doc(userId)
              .collection('stockData')
              .doc(docId)
              .delete();

          // Remove the stock record from the local list (optional for UI sync)
          stockRecordList.removeWhere((stock) => stock['id'] == docId);
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error reducing stock by name: $e");
    }
  }


  Future<void> fetchStockData() async{
    setLoading(true); // Set loading to true
    try{
      String userId = _auth.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore.collection('shopOwners').doc(userId).collection('stockData').get();
      stockRecordList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id, // Add document ID
          'timestamp': (data['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
        };
      },).toList();

      // Sort the list by timestamp in descending order (newest first)
      stockRecordList.sort((a, b) {
        DateTime timestampA = a['timestamp'] ?? DateTime.now();
        DateTime timestampB = b['timestamp'] ?? DateTime.now();
        return timestampB.compareTo(timestampA); // Descending order
      });
      notifyListeners();
    }catch(e){
      print("Error adding stock data: $e");
    }finally {
      setLoading(false); // Set loading to false
    }
  }

  Future<void> updateStockRecord(int index, Map<String, dynamic> updatedData) async {
    try{
      String userId = _auth.currentUser!.uid; // Get current user ID
      String docId = stockRecordList[index]['id']; // Fetch document ID

      // Update to current timestamp
      updatedData['timestamp'] = Timestamp.now(); // Set to current timestamp

      await _firestore.collection('shopOwners').doc(userId).collection('stockData').doc(docId).update(updatedData);
      // Update the local list (retain the document ID)
      stockRecordList[index] = {
        ...updatedData,
        'id': docId, // Keep the document ID intact
      };
      notifyListeners();
    }catch(e){
      print("Error adding stock data: $e");
    }

  }

  Future<void> updateStockRecordByName(String itemName, Map<String, dynamic> updatedData) async {
    try {
      String userId = _auth.currentUser!.uid;

      // Find the stock record by Item Name
      QuerySnapshot snapshot = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('Item Name', isEqualTo: itemName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;

        // Update to current timestamp
        updatedData['timestamp'] = Timestamp.now();

        // Update the record in Firestore
        await _firestore
            .collection('shopOwners')
            .doc(userId)
            .collection('stockData')
            .doc(docId)
            .update(updatedData);

        // Update the local list (optional for UI sync)
        int index = stockRecordList.indexWhere((stock) => stock['id'] == docId);
        if (index != -1) {
          stockRecordList[index] = {
            ...updatedData,
            'id': docId,
          };
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error updating stock record by name: $e");
    }
  }

  Future<void> updateStockRecordByUniqueId(String uniqueId, Map<String, dynamic> updatedData) async {
    try {
      String userId = _auth.currentUser !.uid;

      // Find the stock record by unique ID
      QuerySnapshot snapshot = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('uniqueId', isEqualTo: uniqueId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;

        // Update to current timestamp
        updatedData['timestamp'] = Timestamp.now();

        // Update the record in Firestore
        await _firestore
            .collection('shopOwners')
            .doc(userId)
            .collection('stockData')
            .doc(docId)
            .update(updatedData);

        // Update the local list (optional for UI sync)
        int index = stockRecordList.indexWhere((stock) => stock['id'] == docId);
        if (index != -1) {
          stockRecordList[index] = {
            ...updatedData,
            'id': docId,
          };
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error updating stock record by unique ID: $e");
    }
  }

  Future<void> deleteStockRecordByUniqueId(String uniqueId) async {
    try {
      String userId = _auth.currentUser !.uid;

      // Find the stock record by unique ID
      QuerySnapshot snapshot = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('stockData')
          .where('uniqueId', isEqualTo: uniqueId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String docId = snapshot.docs.first.id;

        // Update the record in Firestore
        await _firestore
            .collection('shopOwners')
            .doc(userId)
            .collection('stockData')
            .doc(docId)
            .delete();

        fetchStockData();
        // // Remove the record from the local list
        // stockRecordList.removeAt(index);
        // // Update the local list (optional for UI sync)
        // int index = stockRecordList.indexWhere((stock) => stock['id'] == docId);
        // if (index != -1) {
        //   stockRecordList[index] = {
        //     ...updatedData,
        //     'id': docId,
        //   };
        //
        // }
        notifyListeners();
      }
    } catch (e) {
      print("Error updating stock record by unique ID: $e");
    }
  }

}

