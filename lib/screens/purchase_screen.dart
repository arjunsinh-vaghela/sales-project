import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common_widgets/add_sales_bottom_sheet.dart';
import '../providers/purchase_data_provider.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Fetch sales data when the purchase is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PurchaseDataProvider>(context, listen: false).fetchPurchaseData();
    });
  }

  Future<void> _refreshData() async {
    searchController.clear(); // Clear the search bar text
    final pro = Provider.of<PurchaseDataProvider>(context, listen: false);
    await pro.updateSearch('');
    await pro.updateSelectedDate(null);
    await pro.fetchPurchaseData();
  }

  // Function to show the bottom sheet
  void _showBottomSheet({bool isEditing = false, int? editingIndex}) {
    final providerState = Provider.of<PurchaseDataProvider>(context, listen: false);
    if (isEditing && editingIndex != null) {
      // Pre-fill controllers with existing record values
      final record = providerState.purchaseRecordList[editingIndex];
      priceController.text = record['Item Price'] ?? '';
      amountController.text = record['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
      itemNameController.text = record['Item Name'] ?? '';
      supplierNameController.text = record['Supplier Name'] ?? '';
      mobileController.text = record['Phone Number'] ?? '';
      taxController.text = record['Tax'].toString().replaceAll('%', '') ?? '';
    } else {
      // Clear controllers for a new record
      priceController.clear();
      amountController.clear();
      itemNameController.clear();
      supplierNameController.clear();
      mobileController.clear();
      taxController.clear();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddSalesBottomSheet(
          amountController: priceController,
          itemQuantityController: amountController,
          itemNameController: itemNameController,
          nameController: supplierNameController,
          taxController: taxController,
          mobileController: mobileController,
          formKey: _formKey,
          isEditing: isEditing,
          isPurchase: true,
          onAdd: (data) {
            if (isEditing && editingIndex != null) {
              providerState.updatePurchaseRecord(editingIndex, data);
              // _updateSalesRecord(editingIndex, data);
            } else {
              providerState.addPurchaseData(context,data);
              // _addSalesRecord(data);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerState = Provider.of<PurchaseDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase'),
        centerTitle: true,
      ),
      body: providerState.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: providerState.purchaseRecordList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/no_data_preview.svg', // Path to your SVG file
                height: 250.h, // Adjust size as needed
                width: 250.w,
              ),
            ],
          ),
        )
            : Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              String val = value.trim().replaceAll(RegExp(r'\s+'),' ');
                              providerState.updateSearch(val);
                            },//_onSearchChanged,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Search Bar For Supplier Name..."),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:providerState.selectedDate, // _selectedDate,
                                firstDate: DateTime(2023), // Earliest selectable date: January 1, 2023
                                lastDate:  DateTime.now(), // Latest selectable date: December 31, 2025
                              );

                              if (providerState.selectedDate != null &&
                                  providerState.selectedDate!.isAtSameMomentAs(pickedDate!)) {
                                // If the same date is selected again, unselect it
                                providerState.updateSelectedDate(null);
                              } else {
                                // Otherwise, select the new date
                                providerState.updateSelectedDate(pickedDate);
                              }
                            },
                            child: Text("Date"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                              itemCount: providerState.purchaseRecordList.length,
                              itemBuilder: (context, index) {
                    final record = providerState.purchaseRecordList[index];
                    DateTime timestamp = record['timestamp'] is Timestamp
                        ? (record['timestamp'] as Timestamp).toDate()
                        : record['timestamp'];
                    final tax = record['Tax'] ?? '0'; // Tax as stored in Firestore
                    // final DateTime timestamp = record['timestamp']?? DateTime.now(); // Fallback to now if null; // Always a DateTime
                    final String formattedDate = DateFormat('dd-MM-yyyy').format(timestamp);
                    String date = formattedDate;
                    String title = record['Supplier Name'];

                    // DateTime timestamp = record['timestamp']; // Get the DateTime object
                    // String formattedDate = DateFormat('dd/MM/yyyy').format(timestamp); // Format the date


                    if (providerState.search.isEmpty && providerState.selectedDate == null) {
                      return CustomeSalesCard(
                          context: context,
                          record: record,
                          formattedDate: formattedDate,
                          tax: tax,
                          index: index,
                          providerState: providerState
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(providerState.search.toLowerCase()) &&
                        providerState.selectedDate == null) {
                      return CustomeSalesCard(
                          context: context,
                          record: record,
                          formattedDate: formattedDate,
                          tax: tax,
                          index: index,
                          providerState: providerState
                      );
                    } else if (providerState.selectedDate != null &&
                        title
                            .toLowerCase()
                            .contains(providerState.search.toLowerCase()) &&
                        date.contains(DateFormat('dd-MM-yyyy')
                            .format(providerState.selectedDate!))) {
                      return CustomeSalesCard(
                          context: context,
                          record: record,
                          formattedDate: formattedDate,
                          tax: tax,
                          index: index,
                          providerState: providerState
                      );
                    } else {
                      return Container();
                    }

                    // return Card(
                    //   margin: EdgeInsets.all(8.0.r),
                    //   child: ListTile(
                    //     subtitle: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Text('Supplier Name:'),
                    //             SizedBox(width: 2.w),
                    //             Expanded(
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text('${record['Supplier Name']}',
                    //                       style: TextStyle(fontWeight: FontWeight.bold)),
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(width: 20.w),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Contact No :'),
                    //             SizedBox(width: 2.w),
                    //             Text('${record['Phone Number']} ,',
                    //                 style: TextStyle(fontWeight: FontWeight.bold)),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Date: '),
                    //             SizedBox(width: 2.w),
                    //             Text(
                    //               formattedDate,
                    //               style: TextStyle(fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Item: '),
                    //             SizedBox(width: 2.w),
                    //             Text(
                    //               '${record['Item Name']}',
                    //               style: TextStyle(fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Item Price: '),
                    //             SizedBox(width: 2.w),
                    //             Text(
                    //               '${record['Item Price']}',
                    //               style: TextStyle(fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Item Quantity: '),
                    //             SizedBox(width: 2.w),
                    //             Text(
                    //               '${record['Item Quantity']}',
                    //               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Items Tax :'),
                    //             SizedBox(width: 2.w),
                    //             Text(tax,//'${record['Tax']} ,'
                    //                 style: TextStyle(fontWeight: FontWeight.bold)),
                    //           ],
                    //         ),
                    //         SizedBox(height: 4.h),
                    //         Row(
                    //           children: [
                    //             Text('Total Amount:'),
                    //             SizedBox(width: 2.w),
                    //             Text('${record['Total']} ,',
                    //                 style: TextStyle(fontWeight: FontWeight.bold)),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //     trailing: PopupMenuButton<String>(
                    //       icon: Icon(Icons.more_vert), // Three vertical dots icon
                    //       onSelected: (value) {
                    //         if (value == 'Edit') {
                    //           _showBottomSheet(isEditing: true, editingIndex: index);
                    //         } else if (value == 'Delete') {
                    //           providerState.deletePurchaseRecord(index);
                    //         }
                    //         else if(value == 'View'){
                    //
                    //         }
                    //       },
                    //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    //         PopupMenuItem<String>(
                    //           value: 'Edit',
                    //           child: Row(
                    //             children: [
                    //               Icon(Icons.edit, color: Colors.blue),
                    //               SizedBox(width: 8.w),
                    //               Text('Edit'),
                    //             ],
                    //           ),
                    //         ),
                    //         PopupMenuItem<String>(
                    //           value: 'View',
                    //           child: Row(
                    //             children: [
                    //               Icon(Icons.visibility, color: Colors.green),
                    //               SizedBox(width: 8.w),
                    //               Text('View'),
                    //             ],
                    //           ),
                    //         ),
                    //         PopupMenuItem<String>(
                    //           value: 'Delete',
                    //           child: Row(
                    //             children: [
                    //               Icon(Icons.delete, color: Colors.red),
                    //               SizedBox(width: 8.w),
                    //               Text('Delete'),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
                              },
                            ),
                  ),
                ],
              ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab2', // Unique tag for the first FAB
        onPressed: () {
          _showBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget CustomeSalesCard({
    required BuildContext context,
    required record,
    required formattedDate,
    required tax,
    required index,
    required providerState,
  }){
    return Card(
      margin: EdgeInsets.all(8.0.r),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Supplier Name:'),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${record['Supplier Name']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Contact No :'),
                SizedBox(width: 2.w),
                Text('${record['Phone Number']} ,',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Date: '),
                SizedBox(width: 2.w),
                Text(
                  formattedDate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item: '),
                SizedBox(width: 2.w),
                Text(
                  '${record['Item Name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item Price: '),
                SizedBox(width: 2.w),
                Text(
                  '${record['Item Price']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item Quantity: '),
                SizedBox(width: 2.w),
                Text(
                  '${record['Item Quantity']}',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Items Tax :'),
                SizedBox(width: 2.w),
                Text(tax,//'${record['Tax']} ,'
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Total Amount:'),
                SizedBox(width: 2.w),
                Text('${record['Total']} ,',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert), // Three vertical dots icon
          onSelected: (value) {
            if (value == 'Edit') {
              _showBottomSheet(isEditing: true, editingIndex: index);
            } else if (value == 'Delete') {
              providerState.deletePurchaseRecord(index);
            }
            else if(value == 'View'){

            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 8.w),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'View',
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.green),
                  SizedBox(width: 8.w),
                  Text('View'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'Delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8.w),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
   }

}
