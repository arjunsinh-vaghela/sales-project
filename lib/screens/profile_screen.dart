
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/add_sales_bottom_sheet.dart';
import '../providers/auth_provider/auth_provider.dart';
import '../providers/bottom_navigation_provider.dart';
import '../providers/profile_data_provider.dart';
import 'auth_screens/register_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileDataProvider>(context, listen: false).fetchStockData();
    });
  }

  Future<void> _refreshData() async {
    searchController.clear(); // Clear the search bar text
    // await Provider.of<ProfileDataProvider>(context, listen: false).fetchStockData();
    final pro = Provider.of<ProfileDataProvider>(context, listen: false);
    await pro.updateSearch('');
    await pro.updateSelectedDate(null);
    await pro.fetchStockData();
  }

  void _showBottomSheet({bool isEditing = false, int? editingIndex}) {
    final providerState = Provider.of<ProfileDataProvider>(context, listen: false);
    if (isEditing && editingIndex != null) {
      final record = providerState.stockRecordList[editingIndex];
      priceController.text = record['Item Price'] ?? '';
      amountController.text = record['Item Stock'] ?? '';
      itemNameController.text = record['Item Name'] ?? '';
    } else {
      priceController.clear();
      amountController.clear();
      itemNameController.clear();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddSalesBottomSheet(
          priceController: priceController,
          amountController: amountController,
          itemNameController: itemNameController,
          formKey: _formKey,
          isEditing: isEditing,
          isPurchase: true,
          isProfile: true,
          onAdd: (data) {
            if (isEditing && editingIndex != null) {
              providerState.updateStockRecord(editingIndex, data);
            } else {
              providerState.addStockData(data);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerState = Provider.of<ProfileDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Name: '),
                          SizedBox(width: 5.w),
                          const Text(
                            'Vaghela Arjunsinh P.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          const Text('Mobile No: '),
                          SizedBox(width: 5.w),
                          const Text(
                            '7226886072',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          const Text('Email: '),
                          SizedBox(width: 5.w),
                          const Text(
                            'arjun123@gmail.com',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _signOutUser();
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _sendEmail();
                            },
                            child: const Text(
                              'Email us',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 20,
                    right: 15,
                    child: ClipOval(
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.cyan,
                        child: const Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Stack(
              children: [
                providerState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    :
                RefreshIndicator(
                  onRefresh: _refreshData,
                  child: providerState.stockRecordList.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/no_data_preview.svg', // Path to your SVG file
                          height: 250.h, // Adjust size as needed
                          width: 250.w,
                        ),
                        // Image.asset(
                        //   'assets/images/no_data.png',
                        //   height: 150.h,
                        //   width: 150.w,
                        // ),
                        // Text('Data is not available'),
                        // Text('Please add data'),
                      ],
                    ),
                  )
                      : Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25,top: 18),
                                  child: TextFormField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      String val = value.trim().replaceAll(RegExp(r'\s+'),' ');
                                      providerState.updateSearch(val);
                                    },//_onSearchChanged,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Search Bar For Item Name..."),
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
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Consumer<ProfileDataProvider>(
                            builder: (context, value, child) {
                              return ListView.builder(
                                itemCount: providerState.stockRecordList.length,
                                itemBuilder: (context, index) {

                                  // final record = providerState.stockRecordList[index];
                                  // DateTime timestamp = record['timestamp'] is Timestamp
                                  //     ? (record['timestamp'] as Timestamp).toDate()
                                  //     : record['timestamp'];
                                  // String formattedDate = DateFormat('dd/MM/yyyy').format(timestamp);
                                  final record = providerState.stockRecordList[index];
                                  DateTime timestamp = record['timestamp'] is Timestamp
                                      ? (record['timestamp'] as Timestamp).toDate()
                                      : record['timestamp'];

                                  final String formattedDate = DateFormat('dd-MM-yyyy').format(timestamp);
                                  String date = formattedDate;
                                  String title = record['Item Name'];

                                  if (providerState.search.isEmpty && providerState.selectedDate == null) {
                                    return CustomeSalesCard(
                                        record: record,
                                    );
                                  } else if (title
                                      .toLowerCase()
                                      .contains(providerState.search.toLowerCase()) &&
                                      providerState.selectedDate == null) {
                                    return CustomeSalesCard(
                                        record: record,
                                    );
                                  } else if (providerState.selectedDate != null &&
                                      title
                                          .toLowerCase()
                                          .contains(providerState.search.toLowerCase()) &&
                                      date.contains(DateFormat('dd-MM-yyyy')
                                          .format(providerState.selectedDate!))) {
                                    return CustomeSalesCard(
                                        record: record,
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
                                  //             Text('Item :'),
                                  //             SizedBox(width: 2.w),
                                  //             Text(
                                  //               '${record['Item Name']} ,',
                                  //               style: TextStyle(fontWeight: FontWeight.bold),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         SizedBox(height: 4.h),
                                  //         Row(
                                  //           children: [
                                  //             Text('Stock :'),
                                  //             SizedBox(width: 2.w),
                                  //             Text(
                                  //               '${record['Item Stock']} ,',
                                  //               style: TextStyle(
                                  //                 color: int.parse(record['Item Stock'].split(' ').first) < 50
                                  //                     ? Colors.red
                                  //                     : Colors.green,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         SizedBox(height: 4.h),
                                  //         Row(
                                  //           children: [
                                  //             Text('Item Price :'),
                                  //             SizedBox(width: 2.w),
                                  //             Text(
                                  //               '${record['Item Price']} ,',
                                  //               style: TextStyle(fontWeight: FontWeight.bold),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     // trailing: PopupMenuButton<String>(
                                  //     //   icon: Icon(Icons.more_vert),
                                  //     //   onSelected: (value) {
                                  //     //     if (value == 'Edit') {
                                  //     //       _showBottomSheet(
                                  //     //           isEditing: true, editingIndex: index);
                                  //     //     } else if (value == 'View'){
                                  //     //
                                  //     //     }else if (value == 'Delete') {
                                  //     //       providerState.deleteStockRecord(index);
                                  //     //     }
                                  //     //   },
                                  //     //   itemBuilder: (context) => <PopupMenuEntry<String>>[
                                  //     //     PopupMenuItem<String>(
                                  //     //       value: 'Edit',
                                  //     //       child: Row(
                                  //     //         children: [
                                  //     //           Icon(Icons.edit, color: Colors.blue),
                                  //     //           SizedBox(width: 8.w),
                                  //     //           Text('Edit'),
                                  //     //         ],
                                  //     //       ),
                                  //     //     ),
                                  //     //     PopupMenuItem<String>(
                                  //     //       value: 'View',
                                  //     //       child: Row(
                                  //     //         children: [
                                  //     //           Icon(Icons.visibility, color: Colors.green),
                                  //     //           SizedBox(width: 8.w),
                                  //     //           Text('View'),
                                  //     //         ],
                                  //     //       ),
                                  //     //     ),
                                  //     //     PopupMenuItem<String>(
                                  //     //       value: 'Delete',
                                  //     //       child: Row(
                                  //     //         children: [
                                  //     //           Icon(Icons.delete, color: Colors.red),
                                  //     //           SizedBox(width: 8.w),
                                  //     //           Text('Delete'),
                                  //     //         ],
                                  //     //       ),
                                  //     //     ),
                                  //     //   ],
                                  //     // ),
                                  //   ),
                                  // );
                                },
                              );
                            },
                                                ),
                                              ),
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'fab3',
      //   onPressed: () {
      //     _showBottomSheet();
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }


  Future<void> _sendEmail() async {
    String subject = 'Test Email Subject';
    String body = 'This is the body of the email \+with spaces.';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'arjunsinh08vaghela@gmail.com', // Recipient email address
      queryParameters: {
        'subject': subject ,  // Email subject
        'body': body,  // Email body content
      },
    );
    // Launch the email client with the email URI
    try {
     final  emailUri2 = emailUri.toString().replaceAll('+',' ');
      final url = Uri.parse(emailUri2);
      await launchUrl(url);
    } catch (e) {
      print('Could not launch email client: $e');
   }
  }

  Future<void> _signOutUser() async {
    String message = await context.read<MyAuthProvider>().signOutUser();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor:
        message == "Logout successful" ? Colors.green : Colors.red,
      ),
    );

    if (message == "Logout successful") {
      // context.read<BottomNavigationProvider>().changeSelectedIndex(0);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(),
        ),
            (Route<dynamic> route) => false,
      );
    }
  }

  Widget CustomeSalesCard({
    required record,
  }) {
    return Card(
      margin: EdgeInsets.all(8.0.r),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Item :'),
                SizedBox(width: 2.w),
                Text(
                  '${record['Item Name']} ,',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Stock :'),
                SizedBox(width: 2.w),
                Text(
                  '${record['Item Stock']} ,',
                  style: TextStyle(
                    color: int.parse(record['Item Stock'].split(' ').first) < 50
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text('Item Price :'),
                SizedBox(width: 2.w),
                Text(
                  '${record['Item Price']} ,',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
