
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common_widgets/add_sales_bottom_sheet.dart';
import '../providers/sales_data_provider.dart';
import '../providers/show_loder_provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalesDataProvider>(context, listen: false).fetchSalesData();
    });
  }

  Future<void> _refreshData() async {
    searchController.clear(); // Clear the search bar text
    final pro = Provider.of<SalesDataProvider>(context, listen: false);
    await pro.updateSearch('');
    await pro.updateSelectedDate(null);
    await pro.fetchSalesData();
  }

  void _showBottomSheet({bool isEditing = false, int? editingIndex}) {
    final providerState = Provider.of<SalesDataProvider>(context, listen: false);
    final showLoader = Provider.of<ShowLoaderProvider>(context, listen: false);

    if (isEditing && editingIndex != null) {
      final record = providerState.salesRecordList[editingIndex];
      nameController.text = record['Customer Name'] ?? '';
      mobileController.text = record['Customer Phone Number'] ?? '';
      amountController.text = record['Item Amount'] ?? '';
      itemNameController.text = record['Item Name'] ?? '';
      itemQuantityController.text = record['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '';
      taxController.text = record['Tax'].toString().replaceAll('%', '') ?? '';
    } else {
      nameController.clear();
      mobileController.clear();
      amountController.clear();
      itemNameController.clear();
      itemQuantityController.clear();
      taxController.clear();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddSalesBottomSheet(
          nameController: nameController,
          mobileController: mobileController,
          amountController: amountController,
          itemNameController: itemNameController,
          itemQuantityController: itemQuantityController,
          taxController: taxController,
          formKey: _formKey,
          isEditing: isEditing,
          isPurchase: false,
          onAdd: (data) async {
            bool success;
            showLoader.setLoading(true);
            if (isEditing && editingIndex != null) {
              success = await providerState.updateSalesRecord(editingIndex, data);
            } else {
              success = await providerState.addSalesData(data);
            }
            if (success) {
              Navigator.pop(context); // Close the bottom sheet on success
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Operation failed. Please try again.')),
              );
            }
            showLoader.setLoading(false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        centerTitle: true,
      ),
      body: Consumer<SalesDataProvider>(
        builder: (context, providerState, child) {
          return providerState.isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: providerState.salesRecordList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/no_data_preview.svg',
                                height: 250.h,
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
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextFormField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          String val = value
                                              .trim()
                                              .replaceAll(RegExp(r'\s+'), ' ');
                                          providerState.updateSearch(val);
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              "Search by Item or Customer Name",
                                          prefixIcon: Icon(Icons.search,
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        final DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate:
                                              providerState.selectedDate ??
                                                  DateTime.now(),
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime.now(),
                                        );

                                        if (pickedDate != null &&
                                            providerState.selectedDate !=
                                                null &&
                                            providerState.selectedDate!
                                                .isAtSameMomentAs(pickedDate)) {
                                          providerState
                                              .updateSelectedDate(null);
                                        } else {
                                          providerState
                                              .updateSelectedDate(pickedDate);
                                        }
                                      },
                                      icon: Icon(Icons.calendar_today,
                                          size: 18, color: Colors.blue),
                                      label: Text(
                                        providerState.selectedDate != null
                                            ? "${providerState.selectedDate!.day}/${providerState.selectedDate!.month}/${providerState.selectedDate!.year}"
                                            : "Select Date",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.blue),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      providerState.salesRecordList.length,
                                  itemBuilder: (context, index) {
                                    final record =
                                        providerState.salesRecordList[index];
                                    final tax = record['Tax'] ?? '0';
                                    DateTime timestamp =
                                        record['timestamp'] is Timestamp
                                            ? (record['timestamp'] as Timestamp)
                                                .toDate()
                                            : record['timestamp'];
                                    final String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(timestamp);
                                    String date = formattedDate;
                                    String title = record['Customer Name'];
                                    String searchItemName = record['Item Name'];

                                    if (providerState.search.isEmpty &&
                                        providerState.selectedDate == null) {
                                      return CustomSalesCard(
                                        context: context,
                                        record: record,
                                        formattedDate: formattedDate,
                                        tax: tax,
                                        index: index,
                                        providerState: providerState,
                                      );
                                    } else if ((title.toLowerCase().contains(
                                                providerState.search
                                                    .toLowerCase()) ||
                                            searchItemName
                                                .toLowerCase()
                                                .contains(providerState.search
                                                    .toLowerCase())) &&
                                        providerState.selectedDate == null) {
                                      return CustomSalesCard(
                                        context: context,
                                        record: record,
                                        formattedDate: formattedDate,
                                        tax: tax,
                                        index: index,
                                        providerState: providerState,
                                      );
                                    } else if (providerState.selectedDate != null &&
                                        (title.toLowerCase().contains(
                                                providerState.search
                                                    .toLowerCase()) ||
                                            searchItemName
                                                .toLowerCase()
                                                .contains(providerState.search
                                                    .toLowerCase())) &&
                                        date.contains(DateFormat('dd-MM-yyyy')
                                            .format(providerState.selectedDate!))) {
                                      return CustomSalesCard(
                                        context: context,
                                        record: record,
                                        formattedDate: formattedDate,
                                        tax: tax,
                                        index: index,
                                        providerState: providerState,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab1',
        onPressed: () {
          _showBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget CustomSalesCard({
    required BuildContext context,
    required record,
    required formattedDate,
    required tax,
    required index,
    required providerState,
  }) {
    return Card(
      margin: EdgeInsets.all(8.0.r),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Customer Name :'),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${record['Customer Name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Date :'),
                SizedBox(width: 2.w),
                Text(formattedDate, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            InkWell(
              child: Row(
                children: [
                  Text('Contact No :'),
                  SizedBox(width: 2.w),
                  Text('${record['Customer Phone Number']},', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              onTap: () {
                launch('tel:+91${record['Customer Phone Number'].toString().replaceAll(RegExp(r'[^0-9]'), '')}');
              },
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item Name :'),
                SizedBox(width: 2.w),
                Text('${record['Item Name']} ,', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item Unit Price :'),
                SizedBox(width: 2.w),
                Text('${record['Item Amount']} ₹,', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item Quantity :'),
                SizedBox(width: 2.w),
                Text('${record['Item Quantity']} ,', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Tax :'),
                SizedBox(width: 2.w),
                Text('$tax ₹', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Total :'),
                SizedBox(width: 2.w),
                Text('${record['Total']} ₹,', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'Edit') {
              _showBottomSheet(isEditing: true, editingIndex: index);
            } else if (value == 'View') {
              // Implement view functionality if needed
            } else if (value == 'Delete') {
              bool success = await providerState.deleteSalesRecord(index);
              if (success) {
                Fluttertoast.showToast(
                  msg: 'Record deleted successfully.',
                  backgroundColor: Colors.green,
                  gravity: ToastGravity.TOP,
                  fontSize: 20,
                  textColor: Colors.white,
                  timeInSecForIosWeb: 2,
                  toastLength: Toast.LENGTH_SHORT,
                );
              } else {
                Fluttertoast.showToast(
                  msg: 'Failed to delete record.',
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  fontSize: 20,
                  textColor: Colors.white,
                  timeInSecForIosWeb: 2,
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../common_widgets/add_sales_bottom_sheet.dart';
// import '../providers/sales_data_provider.dart';
// import '../providers/show_loder_provider.dart';
//
// class SalesScreen extends StatefulWidget {
//   const SalesScreen({super.key});
//
//   @override
//   State<SalesScreen> createState() => _SalesScreenState();
// }
//
// class _SalesScreenState extends State<SalesScreen> {
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   TextEditingController itemNameController = TextEditingController();
//   TextEditingController itemQuantityController = TextEditingController();
//   TextEditingController taxController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<SalesDataProvider>(context).fetchSalesData();
//     });
//   }
//
//   Future<void> _refreshData() async {
//     searchController.clear(); // Clear the search bar text
//    final pro = Provider.of<SalesDataProvider>(context);
//     await pro.updateSearch('');
//     await pro.updateSelectedDate(null);
//     await pro.fetchSalesData();
//   }
//
//   void _showBottomSheet({bool isEditing = false, int? editingIndex}) {
//     final providerState = Provider.of<SalesDataProvider>(context, listen: false);
//     final showLoader = Provider.of<ShowLoaderProvider>(context, listen: false);
//     if (isEditing && editingIndex != null) {
//       final record = providerState.salesRecordList[editingIndex];
//       nameController.text = record['Customer Name'] ?? '';
//       mobileController.text = record['Customer Phone Number'] ?? '';
//       amountController.text = record['Item Amount'] ?? '';
//       itemNameController.text = record['Item Name'] ?? '';
//       // itemQuantityController.text = record['Item Quantity'] ?? '';
//       // taxController.text = record['Tax'] ?? '';
//       itemQuantityController.text = record['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
//       taxController.text = record['Tax'].toString().replaceAll('%', '') ?? '';
//     } else {
//       nameController.clear();
//       mobileController.clear();
//       amountController.clear();
//       itemNameController.clear();
//       itemQuantityController.clear();
//       taxController.clear();
//     }
//
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return AddSalesBottomSheet(
//           nameController: nameController,
//           mobileController: mobileController,
//           amountController: amountController,
//           itemNameController: itemNameController,
//           itemQuantityController: itemQuantityController,
//           taxController: taxController,
//           formKey: _formKey,
//           isEditing: isEditing,
//           isPurchase: false,
//           onAdd: (data) async {
//             bool success;
//             showLoader.setLoading(true);
//             if (isEditing && editingIndex != null) {
//               success = await providerState.updateSalesRecord(editingIndex, data);
//             } else {
//               success = await providerState.addSalesData(data);
//             }
//             if (success) {
//               Navigator.pop(context); // Close the bottom sheet on success
//             } else {
//               // Optionally show an error message to the user
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Operation failed. Please try again.')),
//               );
//             }
//             showLoader.setLoading(false);
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final providerState = Provider.of<SalesDataProvider>(context,listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sales'),
//         centerTitle: true,
//       ),
//       body: Consumer<SalesDataProvider>(builder: (context, value, child) {
//         return providerState.isLoading
//             ? Center(child: CircularProgressIndicator()) // Show single loader during initial fetch
//             : RefreshIndicator(
//           onRefresh: _refreshData,
//           child: providerState.salesRecordList.isEmpty
//               ? Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   'assets/images/no_data_preview.svg', // Path to your SVG file
//                   height: 250.h, // Adjust size as needed
//                   width: 250.w,
//                 ),
//               ],
//             ),
//           )
//               : Container(
//             child: Column(
//               // shrinkWrap: true,
//               children: [
//                 Row(
//                   children: [
//                     Flexible(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: TextFormField(
//                           controller: searchController,
//                           onChanged: (value) {
//                             String val = value.trim().replaceAll(RegExp(r'\s+'), ' ');
//                             providerState.updateSearch(val);
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Search by Item or Customer Name",
//                             prefixIcon: Icon(Icons.search, color: Colors.grey),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             filled: true,
//                             fillColor: Colors.grey[200],
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: OutlinedButton.icon(
//                         onPressed: () async {
//                           final DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate: providerState.selectedDate ?? DateTime.now(),
//                             firstDate: DateTime(2023),
//                             lastDate: DateTime.now(),
//                           );
//
//                           if (pickedDate != null &&
//                               providerState.selectedDate != null &&
//                               providerState.selectedDate!.isAtSameMomentAs(pickedDate)) {
//                             providerState.updateSelectedDate(null);
//                           } else {
//                             providerState.updateSelectedDate(pickedDate);
//                           }
//                         },
//                         icon: Icon(Icons.calendar_today, size: 18, color: Colors.blue),
//                         label: Text(
//                           providerState.selectedDate != null
//                               ? "${providerState.selectedDate!.day}/${providerState.selectedDate!.month}/${providerState.selectedDate!.year}"
//                               : "Select Date",
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: Colors.blue),
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //         child: Padding(
//                 //           padding: const EdgeInsets.symmetric(horizontal: 20),
//                 //           child: TextFormField(
//                 //             controller: searchController,
//                 //             onChanged: (value) {
//                 //               String val = value.trim().replaceAll(RegExp(r'\s+'),' ');
//                 //               providerState.updateSearch(val);
//                 //             },//_onSearchChanged,
//                 //             decoration: InputDecoration(
//                 //                 border: OutlineInputBorder(),
//                 //                 hintText: "Search By Customer Or Item Name"),
//                 //           ),
//                 //         ),
//                 //     ),
//                 //     Padding(
//                 //         padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                 //         child: SizedBox(
//                 //           width: 100,
//                 //           child: ElevatedButton(
//                 //             onPressed: () async {
//                 //               final DateTime? pickedDate = await showDatePicker(
//                 //                 context: context,
//                 //                 initialDate:providerState.selectedDate, // _selectedDate,
//                 //                 firstDate: DateTime(2023), // Earliest selectable date: January 1, 2023
//                 //                 lastDate:  DateTime.now(), // Latest selectable date: December 31, 2025
//                 //               );
//                 //
//                 //               if (providerState.selectedDate != null &&
//                 //                   providerState.selectedDate!.isAtSameMomentAs(pickedDate!)) {
//                 //                 // If the same date is selected again, unselect it
//                 //                 providerState.updateSelectedDate(null);
//                 //               } else {
//                 //                 // Otherwise, select the new date
//                 //                 providerState.updateSelectedDate(pickedDate);
//                 //               }
//                 //             },
//                 //             child: Text("Date"),
//                 //           ),
//                 //         ),
//                 //        ),
//                 //   ],
//                 // ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: providerState.salesRecordList.length,
//                     itemBuilder: (context, index) {
//                       final record = providerState.salesRecordList[index];
//                       final tax = record['Tax'] ?? '0'; // Tax as stored in Firestore
//                       DateTime timestamp = record['timestamp'] is Timestamp
//                           ? (record['timestamp'] as Timestamp).toDate()
//                           : record['timestamp'];
//                       // final DateTime timestamp = record['timestamp']?? DateTime.now(); // Fallback to now if null; // Always a DateTime
//                       final String formattedDate = DateFormat('dd-MM-yyyy').format(timestamp);
//                       String date = formattedDate;
//                       String title = record['Customer Name'];
//                       String searchItemName = record['Item Name'];
//                       if (providerState.search.isEmpty && providerState.selectedDate == null) {
//                         return CustomeSalesCard(
//                             context: context,
//                             record: record,
//                             formattedDate: formattedDate,
//                             tax: tax,
//                             index: index,
//                             providerState: providerState
//                         );
//                       } else if ((title
//                           .toLowerCase()
//                           .contains(providerState.search.toLowerCase()) || searchItemName.toLowerCase().contains(providerState.search.toLowerCase())) &&
//                           providerState.selectedDate == null) {
//                         return CustomeSalesCard(
//                             context: context,
//                             record: record,
//                             formattedDate: formattedDate,
//                             tax: tax,
//                             index: index,
//                             providerState: providerState
//                         );
//                       } else if (providerState.selectedDate != null &&
//                           (title
//                               .toLowerCase()
//                               .contains(providerState.search.toLowerCase()) || searchItemName.toLowerCase().contains(providerState.search.toLowerCase())) &&
//                           date.contains(DateFormat('dd-MM-yyyy')
//                               .format(providerState.selectedDate!))) {
//                         return CustomeSalesCard(
//                             context: context,
//                             record: record,
//                             formattedDate: formattedDate,
//                             tax: tax,
//                             index: index,
//                             providerState: providerState
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },),
//       floatingActionButton: FloatingActionButton(
//         heroTag: 'fab1',
//         onPressed: () {
//           _showBottomSheet();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget CustomeSalesCard({
//     required BuildContext context,
//     required record,
//     required formattedDate,
//     required tax,
//     required index,
//     required providerState,
//   }){
//     return Card(
//       margin: EdgeInsets.all(8.0.r),
//       child: ListTile(
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('Customer Name :'),
//                 SizedBox(width: 2.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('${record['Customer Name']}',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 20.w),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Date :'),
//                 SizedBox(width: 2.w),
//                 Text(formattedDate,
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             InkWell(
//               child: Row(
//                 children: [
//                   Text('Contact No :'),
//                   SizedBox(width: 2.w),
//                   Text('${record['Customer Phone Number']},',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               onTap: () {
//                 launch( 'tel:+91${record['Customer Phone Number'].toString().replaceAll(RegExp(r'[^0-9]'),'')}');
//               },
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Item Name :'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Item Name']} ,',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Item Unit Price :'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Item Amount']} ₹,',
//                     style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Item Quantity :'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Item Quantity']} ,',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Tax :'),
//                 SizedBox(width: 2.w),
//                 Text('$tax ₹',//'${record['Tax']} ,'
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Total :'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Total']} ₹,',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ],
//         ),
//         trailing: PopupMenuButton<String>(
//           icon: Icon(Icons.more_vert),
//           onSelected: (value) async {
//             if (value == 'Edit') {
//               _showBottomSheet(isEditing: true, editingIndex: index);
//             } else if (value == 'View') {
//               // Implement view functionality if needed
//             } else if (value == 'Delete') {
//               // providerState.deleteSalesRecord(index);
//               bool success = await providerState.deleteSalesRecord(index);
//               if (success) {
//                 Fluttertoast.showToast(
//                   msg: 'Record deleted successfully.',
//                   backgroundColor: Colors.green,
//                   gravity: ToastGravity.TOP,
//                   fontSize: 20,
//                   textColor: Colors.white,
//                   timeInSecForIosWeb: 2,
//                   toastLength: Toast.LENGTH_SHORT,
//                 );
//               } else {
//                 Fluttertoast.showToast(
//                   msg: 'Failed to delete record.',
//                   backgroundColor: Colors.red,
//                   gravity: ToastGravity.TOP,
//                   fontSize: 20,
//                   textColor: Colors.white,
//                   timeInSecForIosWeb: 2,
//                   toastLength: Toast.LENGTH_SHORT,
//                 );
//               }
//             }
//           },
//           itemBuilder: (BuildContext context) =>
//           <PopupMenuEntry<String>>[
//             PopupMenuItem<String>(
//               value: 'Edit',
//               child: Row(
//                 children: [
//                   Icon(Icons.edit, color: Colors.blue),
//                   SizedBox(width: 8.w),
//                   Text('Edit'),
//                 ],
//               ),
//             ),
//             PopupMenuItem<String>(
//               value: 'View',
//               child: Row(
//                 children: [
//                   Icon(Icons.visibility, color: Colors.green),
//                   SizedBox(width: 8.w),
//                   Text('View'),
//                 ],
//               ),
//             ),
//             PopupMenuItem<String>(
//               value: 'Delete',
//               child: Row(
//                 children: [
//                   Icon(Icons.delete, color: Colors.red),
//                   SizedBox(width: 8.w),
//                   Text('Delete'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }