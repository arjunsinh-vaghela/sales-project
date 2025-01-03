
import 'package:flutter/material.dart';

class DummyTest extends StatefulWidget {
  const DummyTest({super.key});

  @override
  State<DummyTest> createState() => _DummyTestState();
}

class _DummyTestState extends State<DummyTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy Screen'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey ,borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('uhshas'),
                        SizedBox(height: 8.0), // Add spacing for better readability
                        Text(
                          'uhshasuhshasuhshasuhshasuhshasuhshasuhshasuhshasuhshasuhshasuhshasuhshasshasuhshasuhshasuhshasuhshasuhshas',
                          softWrap: true, // Ensure text wraps
                          overflow: TextOverflow.clip, // Prevent overflow
                        ),
                        SizedBox(height: 8.0),
                        Text('uhshas'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20), // Add spacing between text and icons
                  Column(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(height: 8.0),
                      Icon(Icons.delete),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }
}
/// *************** sales screen ******************************
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../common_widgets/add_sales_bottom_sheet.dart';
// import '../providers/sales_data_provider.dart';
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
//   // late var search = "";
//   // DateTime? _selectedDate;
//   // final DateTime now = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<SalesDataProvider>(context, listen: false).fetchSalesData();
//     });
//   }
//
//   // void _onSearchChanged(String value) {
//   //   setState(() {});
//   //   search = value.trim().replaceAll(RegExp(r'\s+'),' ');
//   //   }
//   Future<void> _refreshData() async {
//     searchController.clear(); // Clear the search bar text
//     // setState(() {
//     //   search = ""; // Reset the search variable
//     // });
//     final pro = Provider.of<SalesDataProvider>(context, listen: false);
//     // await Provider.of<SalesDataProvider>(context, listen: false).updateSearch('');
//     // await Provider.of<SalesDataProvider>(context, listen: false).fetchSalesData();
//     await pro.updateSearch('');
//     await pro.updateSelectedDate(null);
//     await pro.fetchSalesData();
//   }
//   // // Parsing Percentage for Calculations
//   // double taxValue = parseTaxValue(record['Tax']);
//   // double tax = record['Tax Type'] == 'Percentage'
//   //     ? (amount * quantity * taxValue / 100)
//   //     : taxValue;
//   void _showBottomSheet({bool isEditing = false, int? editingIndex}) {
//     final providerState = Provider.of<SalesDataProvider>(context, listen: false);
//     if (isEditing && editingIndex != null) {
//       final record = providerState.salesRecordList[editingIndex];
//       nameController.text = record['Customer Name'] ?? '';
//       mobileController.text = record['Customer Phone Number'] ?? '';
//       amountController.text = record['Item Amount'] ?? '';
//       itemNameController.text = record['Item Name'] ?? '';
//       itemQuantityController.text = record['Item Quantity'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
//       taxController.text = record['Tax'].toString().replaceAll(RegExp(r'[^0-9]'),'') ?? '';
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
//           onAdd: (data) {
//             if (isEditing && editingIndex != null) {
//               providerState.updateSalesRecord(editingIndex, data);
//             } else {
//               providerState.addSalesData(data);
//             }
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final providerState = Provider.of<SalesDataProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sales'),
//         centerTitle: true,
//       ),
//       body: providerState.isLoading
//           ? Center(child: CircularProgressIndicator()) // Show single loader during initial fetch
//           : RefreshIndicator(
//         onRefresh: _refreshData,
//         child: providerState.salesRecordList.isEmpty
//             ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                 'assets/images/no_data_preview.svg', // Path to your SVG file
//                 height: 250.h, // Adjust size as needed
//                 width: 250.w,
//               ),
//               // Image.asset('assets/images/no_data.png',height: 150.h,width: 150.w,),
//               // Text('Data is not available'),
//               // Text('Please add data'),
//             ],
//           ),
//         )
//             : Container(
//           child: Column(
//             // shrinkWrap: true,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: TextFormField(
//                         controller: searchController,
//                         onChanged: (value) {
//                           String val = value.trim().replaceAll(RegExp(r'\s+'),' ');
//                           providerState.updateSearch(val);
//                         },//_onSearchChanged,
//                         decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             hintText: "Search Bar..."),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                     child: SizedBox(
//                       width: 100,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate:providerState.selectedDate, // _selectedDate,
//                             // // Always start with the current date
//                             // firstDate: DateTime(2000),
//                             // // Earliest selectable date
//                             // lastDate: DateTime(2100),
//                             firstDate: DateTime(2023), // Earliest selectable date: January 1, 2023
//                             lastDate:  DateTime.now(), // Latest selectable date: December 31, 2025
//                           );
//
//                           if (providerState.selectedDate != null &&
//                               providerState.selectedDate!.isAtSameMomentAs(pickedDate!)) {
//                             // If the same date is selected again, unselect it
//                             // setState(() {
//                             //   _selectedDate = null;
//                             // });
//                             providerState.updateSelectedDate(null);
//                           } else {
//                             // Otherwise, select the new date
//                             // setState(() {
//                             //   _selectedDate = pickedDate;
//                             // });
//                             providerState.updateSelectedDate(pickedDate);
//                           }
//                         },
//                         child: Text("Date"),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               Expanded(
//
//
//                 child: ListView.builder(
//                   itemCount: providerState.salesRecordList.length,
//                   itemBuilder: (context, index) {
//                     final record = providerState.salesRecordList[index];
//                     final tax = record['Tax'] ?? '0'; // Tax as stored in Firestore
//                     DateTime timestamp = record['timestamp'] is Timestamp
//                         ? (record['timestamp'] as Timestamp).toDate()
//                         : record['timestamp'];
//                     // final DateTime timestamp = record['timestamp']?? DateTime.now(); // Fallback to now if null; // Always a DateTime
//                     final String formattedDate = DateFormat('yyyy-MM-dd').format(timestamp);
//                     String date = formattedDate;
//                     String title = record['Customer Name'];
//                     if (providerState.search.isEmpty && providerState.selectedDate == null) {
//                       return CustomeSalesCard(
//                           context: context,
//                           record: record,
//                           formattedDate: formattedDate,
//                           tax: tax,
//                           index: index,
//                           providerState: providerState
//                       );
//                       // return Card(
//                       //   margin: EdgeInsets.all(8.0.r),
//                       //   child: ListTile(
//                       //     subtitle: Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Row(
//                       //           children: [
//                       //             Text('Customer :'),
//                       //             SizedBox(width: 2.w),
//                       //             Expanded(
//                       //               child: Column(
//                       //                 crossAxisAlignment: CrossAxisAlignment.start,
//                       //                 children: [
//                       //                   Text('${record['Customer Name']}',
//                       //                       style: TextStyle(fontWeight: FontWeight.bold)),
//                       //                 ],
//                       //               ),
//                       //             ),
//                       //             SizedBox(width: 20.w),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Date :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text(formattedDate,
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         InkWell(
//                       //           child: Row(
//                       //             children: [
//                       //               Text('Contact No :'),
//                       //               SizedBox(width: 2.w),
//                       //               Text('${record['Customer Phone Number']} ,',
//                       //                   style: TextStyle(fontWeight: FontWeight.bold)),
//                       //             ],
//                       //           ),
//                       //           onTap: () {
//                       //             launch( 'tel:+91${record['Customer Phone Number'].toString().replaceAll(RegExp(r'[^0-9]'),'')}');
//                       //           },
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Name']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item Price :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Amount']} ,',
//                       //                 style: TextStyle(
//                       //                     color: Colors.green,
//                       //                     fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item Quantity :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Quantity']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Items Tax :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text(tax,//'${record['Tax']} ,'
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Total Amount:'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Total']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //       ],
//                       //     ),
//                       //     trailing: PopupMenuButton<String>(
//                       //       icon: Icon(Icons.more_vert),
//                       //       onSelected: (value) {
//                       //         if (value == 'Edit') {
//                       //           _showBottomSheet(isEditing: true, editingIndex: index);
//                       //         } else if (value == 'View') {
//                       //           // Implement view functionality if needed
//                       //         } else if (value == 'Delete') {
//                       //           providerState.deleteSalesRecord(index);
//                       //         }
//                       //       },
//                       //       itemBuilder: (BuildContext context) =>
//                       //       <PopupMenuEntry<String>>[
//                       //         PopupMenuItem<String>(
//                       //           value: 'Edit',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.edit, color: Colors.blue),
//                       //               SizedBox(width: 8.w),
//                       //               Text('Edit'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         PopupMenuItem<String>(
//                       //           value: 'View',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.visibility, color: Colors.green),
//                       //               SizedBox(width: 8.w),
//                       //               Text('View'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         PopupMenuItem<String>(
//                       //           value: 'Delete',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.delete, color: Colors.red),
//                       //               SizedBox(width: 8.w),
//                       //               Text('Delete'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // );
//                     } else if (title
//                         .toLowerCase()
//                         .contains(providerState.search.toLowerCase()) &&
//                         providerState.selectedDate == null) {
//                       return CustomeSalesCard(
//                           context: context,
//                           record: record,
//                           formattedDate: formattedDate,
//                           tax: tax,
//                           index: index,
//                           providerState: providerState
//                       );
//                       // return Card(
//                       //   margin: EdgeInsets.all(8.0.r),
//                       //   child: ListTile(
//                       //     subtitle: Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Row(
//                       //           children: [
//                       //             Text('Customer :'),
//                       //             SizedBox(width: 2.w),
//                       //             Expanded(
//                       //               child: Column(
//                       //                 crossAxisAlignment: CrossAxisAlignment.start,
//                       //                 children: [
//                       //                   Text('${record['Customer Name']}',
//                       //                       style: TextStyle(fontWeight: FontWeight.bold)),
//                       //                 ],
//                       //               ),
//                       //             ),
//                       //             SizedBox(width: 20.w),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Date :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text(formattedDate,
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         InkWell(
//                       //           child: Row(
//                       //             children: [
//                       //               Text('Contact No :'),
//                       //               SizedBox(width: 2.w),
//                       //               Text('${record['Customer Phone Number']} ,',
//                       //                   style: TextStyle(fontWeight: FontWeight.bold)),
//                       //             ],
//                       //           ),
//                       //           onTap: () {
//                       //             launch( 'tel:+91${record['Customer Phone Number'].toString().replaceAll(RegExp(r'[^0-9]'),'')}');
//                       //           },
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Name']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item Price :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Amount']} ,',
//                       //                 style: TextStyle(
//                       //                     color: Colors.green,
//                       //                     fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item Quantity :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Quantity']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Items Tax :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text(tax,//'${record['Tax']} ,'
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Total Amount:'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Total']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //       ],
//                       //     ),
//                       //     trailing: PopupMenuButton<String>(
//                       //       icon: Icon(Icons.more_vert),
//                       //       onSelected: (value) {
//                       //         if (value == 'Edit') {
//                       //           _showBottomSheet(isEditing: true, editingIndex: index);
//                       //         } else if (value == 'View') {
//                       //           // Implement view functionality if needed
//                       //         } else if (value == 'Delete') {
//                       //           providerState.deleteSalesRecord(index);
//                       //         }
//                       //       },
//                       //       itemBuilder: (BuildContext context) =>
//                       //       <PopupMenuEntry<String>>[
//                       //         PopupMenuItem<String>(
//                       //           value: 'Edit',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.edit, color: Colors.blue),
//                       //               SizedBox(width: 8.w),
//                       //               Text('Edit'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         PopupMenuItem<String>(
//                       //           value: 'View',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.visibility, color: Colors.green),
//                       //               SizedBox(width: 8.w),
//                       //               Text('View'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         PopupMenuItem<String>(
//                       //           value: 'Delete',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.delete, color: Colors.red),
//                       //               SizedBox(width: 8.w),
//                       //               Text('Delete'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // );
//                     } else if (providerState.selectedDate != null &&
//                         title
//                             .toLowerCase()
//                             .contains(providerState.search.toLowerCase()) &&
//                         date.contains(DateFormat('yyyy-MM-dd')
//                             .format(providerState.selectedDate!))) {
//                       return CustomeSalesCard(
//                           context: context,
//                           record: record,
//                           formattedDate: formattedDate,
//                           tax: tax,
//                           index: index,
//                           providerState: providerState
//                       );
//                       // return Card(
//                       //   margin: EdgeInsets.all(8.0.r),
//                       //   child: ListTile(
//                       //     subtitle: Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Row(
//                       //           children: [
//                       //             Text('Customer :'),
//                       //             SizedBox(width: 2.w),
//                       //             Expanded(
//                       //               child: Column(
//                       //                 crossAxisAlignment: CrossAxisAlignment.start,
//                       //                 children: [
//                       //                   Text('${record['Customer Name']}',
//                       //                       style: TextStyle(fontWeight: FontWeight.bold)),
//                       //                 ],
//                       //               ),
//                       //             ),
//                       //             SizedBox(width: 20.w),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Date :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text(formattedDate,
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         InkWell(
//                       //           child: Row(
//                       //             children: [
//                       //               Text('Contact No :'),
//                       //               SizedBox(width: 2.w),
//                       //               Text('${record['Customer Phone Number']},',
//                       //                   style: TextStyle(fontWeight: FontWeight.bold)),
//                       //             ],
//                       //           ),
//                       //           onTap: () {
//                       //             launch( 'tel:+917487811160');
//                       //           },
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Name']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item Price :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Amount']} ,',
//                       //                 style: TextStyle(
//                       //                     color: Colors.green,
//                       //                     fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Item Quantity :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Item Quantity']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Items Tax :'),
//                       //             SizedBox(width: 2.w),
//                       //             Text(tax,//'${record['Tax']} ,'
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //         SizedBox(height: 4.h),
//                       //         Row(
//                       //           children: [
//                       //             Text('Total Amount:'),
//                       //             SizedBox(width: 2.w),
//                       //             Text('${record['Total']} ,',
//                       //                 style: TextStyle(fontWeight: FontWeight.bold)),
//                       //           ],
//                       //         ),
//                       //       ],
//                       //     ),
//                       //     trailing: PopupMenuButton<String>(
//                       //       icon: Icon(Icons.more_vert),
//                       //       onSelected: (value) {
//                       //         if (value == 'Edit') {
//                       //           _showBottomSheet(isEditing: true, editingIndex: index);
//                       //         } else if (value == 'View') {
//                       //           // Implement view functionality if needed
//                       //         } else if (value == 'Delete') {
//                       //           providerState.deleteSalesRecord(index);
//                       //         }
//                       //       },
//                       //       itemBuilder: (BuildContext context) =>
//                       //       <PopupMenuEntry<String>>[
//                       //         PopupMenuItem<String>(
//                       //           value: 'Edit',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.edit, color: Colors.blue),
//                       //               SizedBox(width: 8.w),
//                       //               Text('Edit'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         PopupMenuItem<String>(
//                       //           value: 'View',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.visibility, color: Colors.green),
//                       //               SizedBox(width: 8.w),
//                       //               Text('View'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //         PopupMenuItem<String>(
//                       //           value: 'Delete',
//                       //           child: Row(
//                       //             children: [
//                       //               Icon(Icons.delete, color: Colors.red),
//                       //               SizedBox(width: 8.w),
//                       //               Text('Delete'),
//                       //             ],
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // );
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
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
//                 Text('Customer :'),
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
//                 launch( 'tel:+917487811160');
//               },
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Item :'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Item Name']} ,',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Item Price :'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Item Amount']} ,',
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
//                 Text('Items Tax :'),
//                 SizedBox(width: 2.w),
//                 Text(tax,//'${record['Tax']} ,'
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Total Amount:'),
//                 SizedBox(width: 2.w),
//                 Text('${record['Total']} ,',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ],
//         ),
//         trailing: PopupMenuButton<String>(
//           icon: Icon(Icons.more_vert),
//           onSelected: (value) {
//             if (value == 'Edit') {
//               _showBottomSheet(isEditing: true, editingIndex: index);
//             } else if (value == 'View') {
//               // Implement view functionality if needed
//             } else if (value == 'Delete') {
//               providerState.deleteSalesRecord(index);
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

/// *************** AddSalesBottomSheet widget ******************************
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../providers/tax_type_provider.dart';
// import '../constes/responsive_font_size.dart';
//
// class AddSalesBottomSheet extends StatelessWidget {
//   final TextEditingController? priceController;
//   final TextEditingController? nameController;
//   final TextEditingController? mobileController;
//   final TextEditingController? amountController;
//   final TextEditingController? itemNameController;
//   final TextEditingController? itemQuantityController;
//   final TextEditingController? taxController;
//   final GlobalKey<FormState>? formKey;
//   // String selectedUnit = 'kg';
//
//   final Function(Map<String, dynamic>) onAdd;
//   final bool isEditing;
//   final bool? isPurchase;
//   final bool? isProfile;
//
//   const AddSalesBottomSheet({
//     this.priceController,
//     this.nameController,
//     this.mobileController,
//     this.amountController,
//     this.itemNameController,
//     this.formKey,
//     required this.onAdd,
//     this.isEditing = false,
//     this.isPurchase,
//     this.isProfile,
//     this.itemQuantityController,
//     this.taxController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime currentDateTime = DateTime.now();
//     String formattedDate = DateFormat('dd/MM/yyyy').format(currentDateTime);
//
//     // Access the TaxTypeProvider
//     final taxTypeProvider = Provider.of<TaxTypeProvider>(context);
//
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           padding: EdgeInsets.only(
//               top: 10.r,
//               left: 10.r,
//               right: 10.r,
//               bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 isPurchase!
//                     ? (isProfile ?? false
//                     ? (isEditing ? 'Edit Stock Data' : 'Add Stock Data')
//                     : (isEditing
//                     ? 'Edit Purchase Data'
//                     : 'Add Purchase Data'))
//                     : isEditing
//                     ? 'Edit Sales Data'
//                     : 'Add Sales Data',
//                 style: TextStyle(
//                     fontSize: ResponsiveFontSize.getFontSize(20, 11, 10),
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 15.h),
//               Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     if (isPurchase! != true) ...[
//                       TextFormField(
//                         controller: nameController,
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter name of customer';
//                           }
//                           return null;
//                         },
//                         maxLength: 20,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.person),
//                           label: Text('Customer Name*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: mobileController,
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter mobile number of customer';
//                           } else if (value.length != 10) {
//                             return 'Contact Number must be 10 digits';
//                           }
//                           return null;
//                         },
//                         maxLength: 10,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.phone),
//                           label: Text('Customer Mobile Number*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: itemNameController,
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter name of item';
//                           }
//                           return null;
//                         },
//                         maxLength: 25,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.shopping_bag_outlined),
//                           label: Text('Item Name*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: amountController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return isProfile ?? false
//                                 ? 'Please enter stock of item'
//                                 : 'Please enter amount of item';
//                           } else if (!(int.parse(value!) >= 0)) {
//                             return 'item must be positive number';
//                           }
//                           return null;
//                         },
//                         maxLength: 20,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.currency_rupee),
//                           label: Text(isProfile ?? false
//                               ? "Item Stock*"
//                               : 'Item Price*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: itemQuantityController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter item quantity';
//                           } else if (!(int.parse(value!) >= 1)) {
//                             return 'item quantity must be at least 1';
//                           }
//                           return null;
//                         },
//                         maxLength: 20,
//                         decoration: InputDecoration(
//                           suffixIcon: SizedBox(
//                             width: 200,
//                             child: DropdownButtonFormField<String>(
//                               value: taxTypeProvider.selectedItemType,
//                               items: [
//                                 DropdownMenuItem(
//                                   value: 'COUNT',
//                                   child: Text('COUNT'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'K.G.',
//                                   child: Text('K.G.'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'LITERS',
//                                   child: Text('LITERS'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'METER',
//                                   child: Text('METER'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'FOOT',
//                                   child: Text('FOOT'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'S',
//                                   child: Text('S'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'L',
//                                   child: Text('L'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'M',
//                                   child: Text('M'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'XL',
//                                   child: Text('XL'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'XXL',
//                                   child: Text('XXL'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'XXXL',
//                                   child: Text('XXXL'),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 // if (value != null) {
//                                 taxTypeProvider.setSelectedItemType(value!);
//                                 // }
//                               },
//                               decoration: InputDecoration(
//                                 // label: Text('Tax Type*'),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15.r),
//                                   borderSide: BorderSide(
//                                     style: BorderStyle.solid,
//                                     width: 2.w,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           label: Text('Item Quantity*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: taxController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter tax';
//                           }
//                           if (taxTypeProvider.selectedTaxType == 'Percentage') {
//                             double? percentage = double.tryParse(value);
//                             if (percentage == null ||
//                                 percentage < 0 ||
//                                 percentage > 70) {
//                               return 'Tax percentage must be between 0 and 70%';
//                             }
//                           }
//                           return null;
//                         },
//                         maxLength: 10,
//                         decoration: InputDecoration(
//                           // suffixIcon: taxTypeProvider.selectedTaxType == 'Percentage'
//                           //     ? Text('%')
//                           //     : Icon(Icons.currency_rupee),
//                           suffixIcon: SizedBox(
//                             width: 200,
//                             child: DropdownButtonFormField<String>(
//                               value: taxTypeProvider.selectedTaxType,
//                               items: [
//                                 DropdownMenuItem(
//                                   value: 'Amount',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.attach_money,
//                                           color: Colors.blue),
//                                       // Icon for Amount
//                                       SizedBox(width: 8),
//                                       // Space between icon and text
//                                       Text('Amount'),
//                                     ],
//                                   ),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'Percentage',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.percent, color: Colors.green),
//                                       // Icon for Percentage
//                                       SizedBox(width: 8),
//                                       // Space between icon and text
//                                       Text('Percentage'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 if (value != null) {
//                                   taxTypeProvider.setSelectedTaxType(value);
//                                 }
//                               },
//                               decoration: InputDecoration(
//                                 // label: Text('Tax Type*'),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15.r),
//                                   borderSide: BorderSide(
//                                     style: BorderStyle.solid,
//                                     width: 2.w,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           label: Text('Tax Amount*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                     ],
//
//                     if (isPurchase!) ...[
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: nameController,
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter name of supplier';
//                           }
//                           return null;
//                         },
//                         maxLength: 20,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.person),
//                           label: Text('Supplier Name*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: mobileController,
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter mobile number of supplier';
//                           } else if (value.length != 10) {
//                             return 'Contact Number must be 10 digits';
//                           }
//                           return null;
//                         },
//                         maxLength: 10,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.phone),
//                           label: Text('Supplier Mobile Number*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: itemNameController,
//                         keyboardType: TextInputType.text,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter name of item';
//                           }
//                           return null;
//                         },
//                         maxLength: 25,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.shopping_bag_outlined),
//                           label: Text('Item Name*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         controller: amountController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter price';
//                           } else if (!(int.parse(value!) >= 0)) {
//                             return 'item must be positive number';
//                           }
//                           return null;
//                         },
//                         maxLength: 20,
//                         decoration: InputDecoration(
//                           suffixIcon: Icon(Icons.currency_rupee),
//                           label: Text('Item Price*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: itemQuantityController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return isProfile ?? false
//                                 ? 'Please enter stock of item'
//                                 : 'Please enter amount of item';
//                           } else if (!(int.parse(value!) >= 1)) {
//                             return 'item quantity must be at least 1';
//                           }
//                           return null;
//                         },
//                         maxLength: 20,
//                         decoration: InputDecoration(
//                           suffixIcon: SizedBox(
//                             width: 200,
//                             child: DropdownButtonFormField<String>(
//                               value: taxTypeProvider.selectedItemType,
//                               items: [
//                                 DropdownMenuItem(
//                                   value: 'COUNT',
//                                   child: Text('COUNT'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'K.G.',
//                                   child: Text('K.G.'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'LITERS',
//                                   child: Text('LITERS'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'METER',
//                                   child: Text('METER'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'FOOT',
//                                   child: Text('FOOT'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'S',
//                                   child: Text('S'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'L',
//                                   child: Text('L'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'M',
//                                   child: Text('M'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'XL',
//                                   child: Text('XL'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'XXL',
//                                   child: Text('XXL'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'XXXL',
//                                   child: Text('XXXL'),
//                                 ),
//                               ],
//                               // onChanged: (value) {
//                               //   if (value != null) {
//                               //     taxTypeProvider.setSelectedItemType(value);
//                               //   }
//                               //    },
//                               onChanged: (String? newValue) {
//                                 // if (newValue != null) {
//                                 taxTypeProvider
//                                     .setSelectedItemType(newValue!);
//                                 // }
//                                 // setState(() {
//                                 //   selectedUnit = newValue ??
//                                 //       'COUNT'; // Update selected unit
//                                 // });
//                               },
//
//                               decoration: InputDecoration(
//                                 // label: Text('Tax Type*'),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15.r),
//                                   borderSide: BorderSide(
//                                     style: BorderStyle.solid,
//                                     width: 2.w,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           label: Text('Item Quantity*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       TextFormField(
//                         controller: taxController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter tax';
//                           }
//                           if (taxTypeProvider.selectedTaxType == 'Percentage') {
//                             double? percentage = double.tryParse(value);
//                             if (percentage == null ||
//                                 percentage < 0 ||
//                                 percentage > 70) {
//                               return 'Tax percentage must be between 0 and 70%';
//                             }
//                           }
//                           return null;
//                         },
//                         maxLength: 10,
//                         decoration: InputDecoration(
//                           // suffixIcon: taxTypeProvider.selectedTaxType == 'Percentage'
//                           //     ? Text('%')
//                           //     : Icon(Icons.currency_rupee),
//                           suffixIcon: SizedBox(
//                             width: 200,
//                             child: DropdownButtonFormField<String>(
//                               value: taxTypeProvider.selectedTaxType,
//                               items: [
//                                 DropdownMenuItem(
//                                   value: 'Amount',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.attach_money,
//                                           color: Colors.blue),
//                                       // Icon for Amount
//                                       SizedBox(width: 8),
//                                       // Space between icon and text
//                                       Text('Amount'),
//                                     ],
//                                   ),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'Percentage',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.percent, color: Colors.green),
//                                       // Icon for Percentage
//                                       SizedBox(width: 8),
//                                       // Space between icon and text
//                                       Text('Percentage'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 if (value != null) {
//                                   taxTypeProvider.setSelectedTaxType(value);
//                                 }
//                               },
//                               decoration: InputDecoration(
//                                 // label: Text('Tax Type*'),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(15.r),
//                                   borderSide: BorderSide(
//                                     style: BorderStyle.solid,
//                                     width: 2.w,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           label: Text('Tax Amount*'),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.r),
//                             borderSide: BorderSide(
//                               style: BorderStyle.solid,
//                               width: 2.w,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                     ],
//                     ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(Colors.cyan),
//                         padding: MaterialStateProperty.all(EdgeInsets.symmetric(
//                             vertical: 10.r, horizontal: 40.r)),
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(15.r)),
//                         )),
//                       ),
//                       onPressed: () {
//                         if (formKey?.currentState?.validate() ?? false) {
//                           double amount =
//                               double.tryParse(amountController?.text ?? '0') ??
//                                   0;
//                           double quantity = double.tryParse(
//                               itemQuantityController?.text ?? '0') ??
//                               0;
//                           double taxValue =
//                               double.tryParse(taxController?.text ?? '0') ?? 0;
//
//                           // Determine tax value format
//                           String formattedTaxValue;
//                           if (taxTypeProvider.selectedTaxType == 'Percentage') {
//                             formattedTaxValue =
//                             "${taxValue.toStringAsFixed(2)}%";
//                           } else {
//                             formattedTaxValue = taxValue
//                                 .toStringAsFixed(2); // Store as plain number
//                           }
//
//                           // Determine tax value format
//                           String formattedItemValue;
//                           if (taxTypeProvider.selectedTaxType != 'COUNT') {
//                             formattedItemValue = quantity.toString();
//                           } else {
//                             // Combine quantity and selected item type
//                             formattedItemValue =
//                             "$quantity ${taxTypeProvider.selectedItemType}";
//
//                             // formattedItemValue = "${quantity.toStringAsFixed(2)} ${taxTypeProvider.selectedTaxType}"; // Store as plain number
//                           }
//                           String formattedItemValue1 =
//                               "$quantity ${taxTypeProvider.selectedItemType}";
//
//                           // Calculate tax and total
//                           double tax =
//                           taxTypeProvider.selectedTaxType == 'Percentage'
//                               ? (amount *
//                               quantity *
//                               taxValue /
//                               100) // Convert percentage to decimal
//                               : taxValue;
//
//                           double total = (amount * quantity) + tax;
//                           if (isPurchase!) {
//                             if (isProfile ?? false) {
//                               onAdd({
//                                 'Item Price': priceController!.text,
//                                 'Item Stock': amountController!.text,
//                                 'Item Name': itemNameController!.text,
//                                 'Tax': formattedTaxValue,
//                                 'Total': total.toString(),
//                                 'Tax Type': taxTypeProvider.selectedTaxType,
//                               });
//                             } else {
//                               onAdd({
//                                 'Supplier Name': nameController!.text,
//                                 'Phone Number': mobileController!.text,
//                                 'Item Price': amountController!.text,
//                                 'Item Quantity': formattedItemValue1,
//                                 // quantity.toString(),
//                                 'Item Name': itemNameController!.text,
//                                 'Tax': formattedTaxValue,
//                                 'Total': total.toString(),
//                                 'Tax Type': taxTypeProvider.selectedTaxType,
//                               });
//                             }
//                           } else {
//                             onAdd({
//                               'Customer Name': nameController!.text,
//                               'Customer Phone Number': mobileController!.text,
//                               'Item Amount': amountController!.text,
//                               'Item Quantity': formattedItemValue1,
//                               // quantity.toString(),
//                               'Item Name': itemNameController!.text,
//                               'Tax': formattedTaxValue,
//                               'Total': total.toString(),
//                               'Tax Type': taxTypeProvider.selectedTaxType,
//                             });
//                           }
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Text(
//                         isEditing ? 'Save Changes' : 'Add',
//                         style: TextStyle(
//                           fontSize: ResponsiveFontSize.getFontSize(16, 9, 7),
//                         ),
//                       ),
//                     ),
//
//                     // ElevatedButton(
//                     //   style: ButtonStyle(
//                     //     backgroundColor: MaterialStateProperty.all(Colors.cyan),
//                     //     padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10.r, horizontal: 40.r)),
//                     //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.all(Radius.circular(15.r)),
//                     //     )),
//                     //   ),
//                     //   onPressed: () {
//                     //     if (formKey?.currentState?.validate() ?? false) {
//                     //       double amount = double.tryParse(amountController?.text ?? '0') ?? 0;
//                     //       double quantity = double.tryParse(itemQuantityController?.text ?? '0') ?? 0;
//                     //       double taxValue = double.tryParse(taxController?.text ?? '0') ?? 0;
//                     //
//                     //       // Calculate tax and total
//                     //       double tax = taxTypeProvider.selectedTaxType == 'Percentage'
//                     //           ? (amount * quantity * taxValue / 100)
//                     //           : taxValue;
//                     //
//                     //       double total = (amount * quantity) + tax;
//                     //
//                     //       if (isPurchase!) {
//                     //         if (isProfile ?? false) {
//                     //           onAdd({
//                     //             'Item Price': priceController!.text,
//                     //             'Item Stock': amountController!.text,
//                     //             'Item Name': itemNameController!.text,
//                     //             'Tax': tax.toString(),
//                     //             'Total': total.toString(),
//                     //             'Tax Type': taxTypeProvider.selectedTaxType,
//                     //           });
//                     //         } else {
//                     //           onAdd({
//                     //             'Item Price': priceController!.text,
//                     //             'Item Amount': amountController!.text,
//                     //             'Item Name': itemNameController!.text,
//                     //             'Tax': tax.toString(),
//                     //             'Total': total.toString(),
//                     //             'Tax Type': taxTypeProvider.selectedTaxType,
//                     //           });
//                     //         }
//                     //       } else {
//                     //         onAdd({
//                     //           'Customer Name': nameController!.text,
//                     //           'Customer Phone Number': mobileController!.text,
//                     //           'Item Amount': amountController!.text,
//                     //           'Item Quantity': quantity.toString(),
//                     //           'Item Name': itemNameController!.text,
//                     //           'Tax': tax.toString(),
//                     //           'Total': total.toString(),
//                     //           'Tax Type': taxTypeProvider.selectedTaxType,
//                     //         });
//                     //       }
//                     //       Navigator.pop(context);
//                     //     }
//                     //   },
//                     //   child: Text(isEditing ? 'Save Changes' : 'Add', style: TextStyle(
//                     //     fontSize: ResponsiveFontSize.getFontSize(16, 9, 7),
//                     //   )),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

