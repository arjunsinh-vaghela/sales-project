import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // Add this import
import 'package:sales_project/providers/profile_data_provider.dart';
///************************
class PurchaseDataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> purchaseRecordList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _search = '';
  DateTime? _selectedDate;
  bool isLoading = false; // Add loading state
  // Generate a unique identifier for the item
  String uniqueId = Uuid().v4(); // Generate a unique ID

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

  // Future<void> addPurchaseData(Map<String, dynamic> purchaseData) async {
  //   try {
  //     String userId = _auth.currentUser!.uid;
  //
  //     // Add data to Firestore and get the document reference
  //     DocumentReference docRef =  await _firestore.collection('shopOwners').doc(userId).collection('purchaseData').add(purchaseData);
  //
  //     // Add the document data along with the generated ID to the local list
  //     purchaseRecordList.add({
  //       ...purchaseData,
  //       'id': docRef.id, // Include the document ID
  //     });
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error adding purchase data: $e");
  //   }
  // }

  Future<void> addPurchaseData(BuildContext context,Map<String, dynamic> purchaseData) async {
    try {
      String userId = _auth.currentUser !.uid;

      // Add a timestamp to the purchase data
      purchaseData['timestamp'] = Timestamp.now(); // Use Timestamp.now() instead of FieldValue.serverTimestamp()
      purchaseData['uniqueId'] = uniqueId; // Add unique ID

      // Add data to Firestore and get the document reference
      DocumentReference docRef = await _firestore.collection('shopOwners').doc(userId).collection('purchaseData').add(purchaseData);

      // Add the document data along with the generated ID to the local list
      // purchaseRecordList.add({
      //   ...purchaseData,
      //   'id': docRef.id, // Include the document ID
      //   // 'timestamp': (purchaseData['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      // });
      purchaseRecordList.add({
        ...purchaseData,
        'id': docRef.id,
        // 'timestamp': (purchaseData['timestamp'] as Timestamp).toDate(), // Convert to DateTime i think optional
      });

     // Provider.of<ProfileDataProvider>(context, listen: false).addStockData({
     //   // 'Item Price': purchaseData['Item Price'],
     //   // 'Item Stock': purchaseData['Item Quantity'],
     //   // // quantity.toString(),
     //   // 'Item Name': purchaseData['Item Name'],
     //   'Item Price': '1234',
     //   'Item Stock': '1234',
     //   // quantity.toString(),
     //   'Item Name': 'My Item',
     // });
      ProfileDataProvider profiledataprovider = ProfileDataProvider();
     profiledataprovider.addStockData({
       'Item Price': purchaseData['Item Price'],
       'Item Stock': purchaseData['Item Quantity'],
       // quantity.toString(),
       'Item Name': purchaseData['Item Name'],
       'uniqueId': uniqueId, // Include unique ID in stock data
     });

      notifyListeners();
    } catch (e) {
      print("Error adding purchase data: $e");
    }
  }

  // Future<void> addPurchaseData(BuildContext context, Map<String, dynamic> purchaseData) async {
  //   try {
  //     String userId = _auth.currentUser!.uid;
  //
  //     // Add a timestamp to the purchase data
  //     purchaseData['timestamp'] = Timestamp.now();
  //
  //     // Add data to Firestore and get the document reference
  //     DocumentReference docRef = await _firestore
  //         .collection('shopOwners')
  //         .doc(userId)
  //         .collection('purchaseData')
  //         .add(purchaseData);
  //
  //     purchaseRecordList.add({
  //       ...purchaseData,
  //       'id': docRef.id,
  //     });
  //
  //     // Call addStockData with the relevant fields
  //     Provider.of<ProfileDataProvider>(context, listen: false).addStockData({
  //       'Item Price': purchaseData['Item Price'],
  //       'Item Stock': purchaseData['Item Quantity'],
  //       'Item Name': purchaseData['Item Name'],
  //     });
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error adding purchase data: $e");
  //   }
  // }




  // Delete data
  Future<void> deletePurchaseRecord(int index) async{
    try{
      String userId = _auth.currentUser!.uid; // Get current user ID
      String docId = purchaseRecordList[index]['id']; // Fetch document ID

      String uniqueId = purchaseRecordList[index]['uniqueId']; // Get the unique ID

      // // Fetch details of the purchase being deleted
      // String itemName = purchaseRecordList[index]['Item Name'];
      // int quantity = purchaseRecordList[index]['Item Quantity'];

      // updatedData['uniqueId'] = uniqueId; // Ensure unique ID is included

      // Delete the document from Firestore
      await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('purchaseData')
          .doc(docId)
          .delete();

      // Remove the record from the local list
      purchaseRecordList.removeAt(index);

      // // Update corresponding stock data
      // // Update the corresponding stock data
      // await profiledataprovider.reduceStockByName(itemName, quantity);
      // Update corresponding stock data using unique ID
      ProfileDataProvider profiledataprovider = ProfileDataProvider();
      await profiledataprovider.deleteStockRecordByUniqueId(uniqueId);

      notifyListeners();
    } catch (e) {
      print("Error deleting purchase record: $e");
    }
  }

  // Future<void> fetchPurchaseData()async{
  //   setLoading(true); // Set loading to true
  //   try{
  //     String userId = _auth.currentUser!.uid;
  //     QuerySnapshot snapshot = await _firestore.collection('shopOwners').doc(userId).collection('purchaseData').get();
  //     // Store document data along with its ID , for updating data its important
  //     purchaseRecordList = snapshot.docs.map((doc) {
  //       return {
  //         ...doc.data() as Map<String,dynamic>,
  //         'id': doc.id,// Add document ID
  //       };
  //     }).toList();
  //     notifyListeners();
  //   }catch(e){
  //     print("Error fetching purchase data: $e");
  //   }finally {
  //     setLoading(false); // Set loading to false
  //   }
  // }
  // Future<void> deletePurchaseRecord(dynamic identifier) async {
  //   try {
  //     String userId = _auth.currentUser!.uid;
  //     String? docId;
  //     // Fetch details of the purchase being deleted
  //     String itemName = purchaseRecordList[identifier]['Item Name'];
  //     int quantity = purchaseRecordList[identifier]['Item Quantity'];
  //
  //     if (identifier is int) {
  //       // Delete based on index
  //        docId = purchaseRecordList[identifier]['id'];
  //       purchaseRecordList.removeAt(identifier);
  //       Fluttertoast.showToast(msg: 'it is intiger',backgroundColor: Colors.red);
  //     } else if (identifier is String) {
  //       // Delete based on document ID
  //       purchaseRecordList.removeWhere((record) => record['id'] == identifier);
  //       Fluttertoast.showToast(msg: 'it is string',backgroundColor: Colors.green);
  //     } else {
  //       print("Invalid identifier type: $identifier");
  //       return;
  //     }
  //
  //     // Delete from Firestore
  //     await _firestore
  //         .collection('shopOwners')
  //         .doc(userId)
  //         .collection('purchaseData')
  //         .doc(identifier is int ? docId : identifier)
  //         .delete();
  //
  //     // Update the corresponding stock data
  //     await profiledataprovider.reduceStockByName(itemName, quantity);
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error deleting purchase record: $e");
  //   }
  // }


  // Future<void> deletePurchaseRecord(int identifier) async {
  //   try {
  //     String userId = _auth.currentUser !.uid;
  //     String? docId;
  //     String itemName = '';
  //     int quantity = 0;
  //
  //     if (identifier is int) {
  //       // Delete based on index
  //       docId =  purchaseRecordList[identifier]['id'];
  //       itemName = purchaseRecordList[identifier]['Item Name'];
  //       quantity = purchaseRecordList[identifier]['Item Quantity'];
  //       purchaseRecordList.removeAt(identifier);
  //       Fluttertoast.showToast(msg: 'Deleting by index', backgroundColor: Colors.red);
  //     } else if (identifier is String) {
  //       // Delete based on document ID
  //       var recordToDelete = purchaseRecordList.firstWhere(
  //             (record) => record['id'] == identifier,
  //         orElse: () => {'Item Name': '', 'Item Quantity': 0}, // Provide a default value
  //       );
  //
  //       if (recordToDelete['Item Name'] != '') {
  //         itemName = recordToDelete['Item Name'];
  //         quantity = recordToDelete['Item Quantity'];
  //         purchaseRecordList.removeWhere((record) => record['id'] == identifier);
  //         Fluttertoast.showToast(msg: 'Deleting by document ID', backgroundColor: Colors.green);
  //       } else {
  //         print("Record not found for ID: $identifier");
  //         return;
  //       }
  //     } else {
  //       print("Invalid identifier type: $identifier");
  //       return;
  //     }
  //
  //     // Delete from Firestore
  //     await _firestore
  //         .collection('shopOwners')
  //         .doc(userId)
  //         .collection('purchaseData')
  //         .doc(docId )
  //         .delete();
  //
  //     // Update the corresponding stock data
  //     await profiledataprovider.reduceStockByName(itemName, quantity);
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error deleting purchase record: $e");
  //   }
  // }


  Future<void> fetchPurchaseData() async {
    setLoading(true); // Set loading to true
    try {
      String userId = _auth.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('purchaseData')
          .get();

      // Store document data along with its ID and convert timestamp to DateTime
      purchaseRecordList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id, // Add document ID
          'timestamp': (data['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
        };
      }).toList();

      // Sort the list by timestamp in descending order (newest first)
      purchaseRecordList.sort((a, b) {
        DateTime timestampA = a['timestamp'] ?? DateTime.now();
        DateTime timestampB = b['timestamp'] ?? DateTime.now();
        return timestampB.compareTo(timestampA); // Descending order
      });

      notifyListeners();
    } catch (e) {
      print("Error fetching purchase data: $e");
    } finally {
      setLoading(false); // Set loading to false
    }
  }


  Future<void> updatePurchaseRecord(int index, Map<String, dynamic> updatedData) async {
    try {
      String userId = _auth.currentUser !.uid;
      String docId = purchaseRecordList[index]['id'];
      String uniqueId = purchaseRecordList[index]['uniqueId']; // Get the unique ID

      // Update to current timestamp
      updatedData['timestamp'] = Timestamp.now();
      updatedData['uniqueId'] = uniqueId; // Ensure unique ID is included

      // Update purchase data in Firestore
      await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('purchaseData')
          .doc(docId)
          .update(updatedData);

      // Update the local list
      purchaseRecordList[index] = {
        ...updatedData,
        'id': docId,
      };
      ProfileDataProvider profiledataprovider = ProfileDataProvider();
      // Update corresponding stock data using unique ID
      await profiledataprovider.updateStockRecordByUniqueId(uniqueId, {
        'Item Price': updatedData['Item Price'],
        'Item Stock': updatedData['Item Quantity'],
        'Item Name': updatedData['Item Name'], // Ensure Item Name is included
      });

      notifyListeners();
    } catch (e) {
      print("Error updating purchase record: $e");
    }
  }

  Future<void> updatePurchaseRecordName(int index, Map<String, dynamic> updatedData) async {
    try {
      String userId = _auth.currentUser!.uid;
      String docId = purchaseRecordList[index]['id'];

      // Update to current timestamp
      updatedData['timestamp'] = Timestamp.now();

      // Update purchase data in Firestore
      await _firestore
          .collection('shopOwners')
          .doc(userId)
          .collection('purchaseData')
          .doc(docId)
          .update(updatedData);

      // Update the local list
      purchaseRecordList[index] = {
        ...updatedData,
        'id': docId,
      };

      ProfileDataProvider profiledataprovider = ProfileDataProvider();
      // Update corresponding stock data
      await profiledataprovider.updateStockRecordByName(
        updatedData['Item Name'], // Common identifier
        {
          'Item Price': updatedData['Item Price'],
          'Item Stock': updatedData['Item Quantity'],
          'Item Name': updatedData['Item Name'], // Ensure Item Name is included
        },
      );

      notifyListeners();
    } catch (e) {
      print("Error updating purchase record: $e");
    }
  }

// // Function to update an existing sales record
  // Future<void> updatePurchaseRecord(int index, Map<String, dynamic> updatedData) async{
  //   try{
  //     String userId = _auth.currentUser!.uid; // Get current user ID
  //     String docId = purchaseRecordList[index]['id']; // Fetch document ID
  //
  //     // Update to current timestamp
  //     updatedData['timestamp'] = Timestamp.now(); // Set to current timestamp
  //
  //     await _firestore.collection('shopOwners').doc(userId).collection('purchaseData').doc(docId).update(updatedData);
  //     // Update the local list (retain the document ID)
  //     purchaseRecordList[index] = {
  //       ...updatedData,
  //       'id': docId, // Keep the document ID intact
  //     };
  //     // profiledataprovider.updateStockRecord(index,{
  //     //   'Item Price': updatedData['Item Price'],
  //     //   'Item Stock': updatedData['Item Quantity'],
  //     //   // quantity.toString(),
  //     //   'Item Name': updatedData['Item Name'],
  //     // });
  //     // profiledataprovider.updateStockRecordByName(updatedData['Item Name'], {
  //     //   'Item Price': updatedData['Item Price'],
  //     //   'Item Stock': updatedData['Item Quantity'],
  //     // });
  //     notifyListeners();
  //   }catch(e){
  //     print("Error updating purchase record: $e");
  //   }
  // }


}


//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_project/providers/profile_data_provider.dart';
//
// class PurchaseDataProvider extends ChangeNotifier {
//   List<Map<String, dynamic>> purchaseRecordList = [];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _search = '';
//   DateTime? _selectedDate;
//   bool isLoading = false; // Add loading state
//
//   String get search => _search;
//   DateTime? get selectedDate => _selectedDate;
//
//   Future<void> updateSearch(String value) async{
//     _search = value;
//     notifyListeners();
//   }
//
//   Future<void> updateSelectedDate(DateTime? date) async{
//     _selectedDate = date;
//     notifyListeners();
//   }
//
//   // Update loading state
//   void setLoading(bool value) {
//     isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> addPurchaseData(Map<String, dynamic> purchaseData) async {
//     try {
//       String userId = _auth.currentUser !.uid;
//
//       // Add a timestamp to the purchase data
//       purchaseData['timestamp'] = Timestamp.now(); // Use Timestamp.now() instead of FieldValue.serverTimestamp()
//
//       // Add data to Firestore and get the document reference
//       DocumentReference docRef = await _firestore.collection('shopOwners').doc(userId).collection('purchaseData').add(purchaseData);
//
//       // Add the document data along with the generated ID to the local list
//       // purchaseRecordList.add({
//       //   ...purchaseData,
//       //   'id': docRef.id, // Include the document ID
//       //   // 'timestamp': (purchaseData['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
//       // });
//       purchaseRecordList.add({
//         ...purchaseData,
//         'id': docRef.id,
//         // 'timestamp': (purchaseData['timestamp'] as Timestamp).toDate(), // Convert to DateTime i think optional
//       });
//
//       Provider.of<ProfileDataProvider>(context, listen: false).addStockData(
//         'Item Amount': '',
//         'Item Quantity': '',
//         // quantity.toString(),
//         'Item Name': '',
//       );
//
//       notifyListeners();
//     } catch (e) {
//       print("Error adding purchase data: $e");
//     }
//   }
//
//
//   // Delete data
//   Future<void> deletePurchaseRecord(int index) async{
//     try{
//       String userId = _auth.currentUser!.uid; // Get current user ID
//       String docId = purchaseRecordList[index]['id']; // Fetch document ID
//       // Delete the document from Firestore
//       await _firestore
//           .collection('shopOwners')
//           .doc(userId)
//           .collection('purchaseData')
//           .doc(docId)
//           .delete();
//
//       // Remove the record from the local list
//       purchaseRecordList.removeAt(index);
//       notifyListeners();
//     } catch (e) {
//       print("Error deleting purchase record: $e");
//     }
//   }
//
//
//
//   Future<void> fetchPurchaseData() async {
//     setLoading(true); // Set loading to true
//     try {
//       String userId = _auth.currentUser!.uid;
//       QuerySnapshot snapshot = await _firestore
//           .collection('shopOwners')
//           .doc(userId)
//           .collection('purchaseData')
//           .get();
//
//       // Store document data along with its ID and convert timestamp to DateTime
//       purchaseRecordList = snapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return {
//           ...data,
//           'id': doc.id, // Add document ID
//           'timestamp': (data['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
//         };
//       }).toList();
//
//       // Sort the list by timestamp in descending order (newest first)
//       purchaseRecordList.sort((a, b) {
//         DateTime timestampA = a['timestamp'] ?? DateTime.now();
//         DateTime timestampB = b['timestamp'] ?? DateTime.now();
//         return timestampB.compareTo(timestampA); // Descending order
//       });
//
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching purchase data: $e");
//     } finally {
//       setLoading(false); // Set loading to false
//     }
//   }
//
//
//   // Function to update an existing sales record
//   Future<void> updatePurchaseRecord(int index, Map<String, dynamic> updatedData) async{
//     try{
//       String userId = _auth.currentUser!.uid; // Get current user ID
//       String docId = purchaseRecordList[index]['id']; // Fetch document ID
//
//       // Update to current timestamp
//       updatedData['timestamp'] = Timestamp.now(); // Set to current timestamp
//
//       await _firestore.collection('shopOwners').doc(userId).collection('purchaseData').doc(docId).update(updatedData);
//       // Update the local list (retain the document ID)
//       purchaseRecordList[index] = {
//         ...updatedData,
//         'id': docId, // Keep the document ID intact
//       };
//       notifyListeners();
//     }catch(e){
//       print("Error updating purchase record: $e");
//     }
//   }
//
//
// }Undefined name 'context'.1 positional argument expected by 'addStockData', but 0 found.Expected an identifier.The named parameter '' isn't defined.Expected an identifier.The argument for the named parameter '' was already specified.The named parameter '' isn't defined.Expected an identifier.The argument for the named parameter '' was already specified.The named parameter '' isn't defined.
