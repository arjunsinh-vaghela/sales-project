import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabaseLogic {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
    String get currentUserId {
    final user = _auth.currentUser ;
    if (user == null) {
    throw Exception("User  is not logged in");
    }
    return user.uid;
  }

  // Add Sale Data
  Future<void> addSaleData(Map<String, dynamic> saleData) async {
    await _db.collection('shopOwners').doc(currentUserId).collection('salesData').add(saleData);
  }


  // Add Purchase Data
  Future<void> addPurchaseData(Map<String, dynamic> purchaseData) async {
    await _db.collection('shopOwners').doc(currentUserId).collection('purchaseData').add(purchaseData);
  }

  // Add Stock Data
  Future<void> addStockData(Map<String, dynamic> stockData) async {
    await _db.collection('shopOwners').doc(currentUserId).collection('stockData').add(stockData);
  }

  // Update Profile
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    await _db.collection('shopOwners').doc(currentUserId).collection('profile').doc('profileId').set(profileData);
  }

  // Fetch Sales Data
  Stream<List<Map<String, dynamic>>> getSalesData() {
    return _db.collection('shopOwners').doc(currentUserId).collection('salesData').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

}
