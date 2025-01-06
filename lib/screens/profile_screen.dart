
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/add_sales_bottom_sheet.dart';
import '../providers/auth_provider/auth_provider.dart';
import '../providers/profile_data_provider.dart';
import 'auth_screens/login_screen.dart';

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
      body: SingleChildScrollView( // Use SingleChildScrollView to allow scrolling
        child: Column(
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
                                await _signOutUser ();
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
            SizedBox(height: 15,),
            providerState.isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
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
                  ],
                ),
              )
                  : Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              String val = value.trim().replaceAll(RegExp(r'\s+'), ' ');
                              providerState.updateSearch(val);
                            },
                            decoration: InputDecoration(
                              hintText: "Search By Item Name",
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: providerState.selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null &&
                                providerState.selectedDate != null &&
                                providerState.selectedDate!.isAtSameMomentAs(pickedDate)) {
                              providerState.updateSelectedDate(null);
                            } else {
                              providerState.updateSelectedDate(pickedDate);
                            }
                          },
                          icon: Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                          label: Text(
                            providerState.selectedDate != null
                                ? "${providerState.selectedDate!.day}/${providerState.selectedDate!.month}/${providerState.selectedDate!.year}"
                                : "Select Date",
                            style: TextStyle(color: Colors.blue),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Consumer<ProfileDataProvider>(
                      builder: (context, value, child ) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: providerState.stockRecordList.length,
                          itemBuilder: (context, index) {
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
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendEmail() async {
    String subject = 'Test Email Subject';
    String body = 'This is the body of the email with spaces.';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'arjunsinh08vaghela@gmail.com', // Recipient email address
      queryParameters: {
        'subject': subject,  // Email subject
        'body': body,  // Email body content
      },
    );
    // Launch the email client with the email URI
    try {
      final emailUri2 = emailUri.toString().replaceAll('+', ' ');
      final url = Uri.parse(emailUri2);
      await launchUrl(url);
    } catch (e) {
      print('Could not launch email client: $e');
    }
  }

  Future<void> _signOutUser () async {
    String message = await context.read<MyAuthProvider>().signOutUser ();

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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_project/screens/auth_screens/login_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../common_widgets/add_sales_bottom_sheet.dart';
// import '../providers/auth_provider/auth_provider.dart';
// import '../providers/bottom_navigation_provider.dart';
// import '../providers/profile_data_provider.dart';
// import 'auth_screens/register_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   TextEditingController priceController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   TextEditingController itemNameController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ProfileDataProvider>(context, listen: false).fetchStockData();
//     });
//   }
//
//   Future<void> _refreshData() async {
//     searchController.clear(); // Clear the search bar text
//     // await Provider.of<ProfileDataProvider>(context, listen: false).fetchStockData();
//     final pro = Provider.of<ProfileDataProvider>(context, listen: false);
//     await pro.updateSearch('');
//     await pro.updateSelectedDate(null);
//     await pro.fetchStockData();
//   }
//
//   void _showBottomSheet({bool isEditing = false, int? editingIndex}) {
//     final providerState = Provider.of<ProfileDataProvider>(context, listen: false);
//     if (isEditing && editingIndex != null) {
//       final record = providerState.stockRecordList[editingIndex];
//       priceController.text = record['Item Price'] ?? '';
//       amountController.text = record['Item Stock'] ?? '';
//       itemNameController.text = record['Item Name'] ?? '';
//     } else {
//       priceController.clear();
//       amountController.clear();
//       itemNameController.clear();
//     }
//
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return AddSalesBottomSheet(
//           priceController: priceController,
//           amountController: amountController,
//           itemNameController: itemNameController,
//           formKey: _formKey,
//           isEditing: isEditing,
//           isPurchase: true,
//           isProfile: true,
//           onAdd: (data) {
//             if (isEditing && editingIndex != null) {
//               providerState.updateStockRecord(editingIndex, data);
//             } else {
//               providerState.addStockData(data);
//             }
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final providerState = Provider.of<ProfileDataProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Colors.grey,
//                   width: 2,
//                   style: BorderStyle.solid,
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Text('Name: '),
//                           SizedBox(width: 5.w),
//                           const Text(
//                             'Vaghela Arjunsinh P.',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 5.h),
//                       Row(
//                         children: [
//                           const Text('Mobile No: '),
//                           SizedBox(width: 5.w),
//                           const Text(
//                             '7226886072',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 5.h),
//                       Row(
//                         children: [
//                           const Text('Email: '),
//                           SizedBox(width: 5.w),
//                           const Text(
//                             'arjun123@gmail.com',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 5.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               await _signOutUser();
//                             },
//                             child: const Text(
//                               'Logout',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () async {
//                               await _sendEmail();
//                             },
//                             child: const Text(
//                               'Email us',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 20,
//                     right: 15,
//                     child: ClipOval(
//                       child: Container(
//                         height: 60,
//                         width: 60,
//                         color: Colors.cyan,
//                         child: const Icon(
//                           Icons.person,
//                           size: 35,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Divider(
//             height: 1,
//             thickness: 1,
//             color: Colors.grey,
//           ),
//           SizedBox(height: 15,),
//           Container(
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // Shrink-wrap the children
//               children: [
//                 Flexible(
//                   child: Stack(
//                     children: [
//                       providerState.isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           :
//                       RefreshIndicator(
//                         onRefresh: _refreshData,
//                         child: providerState.stockRecordList.isEmpty
//                             ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SvgPicture.asset(
//                                 'assets/images/no_data_preview.svg', // Path to your SVG file
//                                 height: 250.h, // Adjust size as needed
//                                 width: 250.w,
//                               ),
//                             ],
//                           ),
//                         )
//                             : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min, // Shrink-wrap the children
//                           //     crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Flexible(
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                         child: TextFormField(
//                                           controller: searchController,
//                                           onChanged: (value) {
//                                             String val = value.trim().replaceAll(RegExp(r'\s+'), ' ');
//                                             providerState.updateSearch(val);
//                                           },
//                                           decoration: InputDecoration(
//                                             hintText: "Search By Item Name",
//                                             prefixIcon: Icon(Icons.search, color: Colors.grey),
//                                             border: OutlineInputBorder(
//                                               borderRadius: BorderRadius.circular(12.0),
//                                             ),
//                                             filled: true,
//                                             fillColor: Colors.grey[200],
//                                             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                       child: OutlinedButton.icon(
//                                         onPressed: () async {
//                                           final DateTime? pickedDate = await showDatePicker(
//                                             context: context,
//                                             initialDate: providerState.selectedDate ?? DateTime.now(),
//                                             firstDate: DateTime(2023),
//                                             lastDate: DateTime.now(),
//                                           );
//
//                                           if (pickedDate != null &&
//                                               providerState.selectedDate != null &&
//                                               providerState.selectedDate!.isAtSameMomentAs(pickedDate)) {
//                                             providerState.updateSelectedDate(null);
//                                           } else {
//                                             providerState.updateSelectedDate(pickedDate);
//                                           }
//                                         },
//                                         icon: Icon(Icons.calendar_today, size: 18, color: Colors.blue),
//                                         label: Text(
//                                           providerState.selectedDate != null
//                                               ? "${providerState.selectedDate!.day}/${providerState.selectedDate!.month}/${providerState.selectedDate!.year}"
//                                               : "Select Date",
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                         style: OutlinedButton.styleFrom(
//                                           side: BorderSide(color: Colors.blue),
//                                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Flexible(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Consumer<ProfileDataProvider>(
//                                   builder: (context, value, child) {
//                                     return ListView.builder(
//                                       itemCount: providerState.stockRecordList.length,
//                                       itemBuilder: (context, index) {
//                                         final record = providerState.stockRecordList[index];
//                                         DateTime timestamp = record['timestamp'] is Timestamp
//                                             ? (record['timestamp'] as Timestamp).toDate()
//                                             : record['timestamp'];
//
//                                         final String formattedDate = DateFormat('dd-MM-yyyy').format(timestamp);
//                                         String date = formattedDate;
//                                         String title = record['Item Name'];
//
//                                         if (providerState.search.isEmpty && providerState.selectedDate == null) {
//                                           return CustomeSalesCard(
//                                               record: record,
//                                           );
//                                         } else if (title
//                                             .toLowerCase()
//                                             .contains(providerState.search.toLowerCase()) &&
//                                             providerState.selectedDate == null) {
//                                           return CustomeSalesCard(
//                                               record: record,
//                                           );
//                                         } else if (providerState.selectedDate != null &&
//                                             title
//                                                 .toLowerCase()
//                                                 .contains(providerState.search.toLowerCase()) &&
//                                             date.contains(DateFormat('dd-MM-yyyy')
//                                                 .format(providerState.selectedDate!))) {
//                                           return CustomeSalesCard(
//                                               record: record,
//                                           );
//                                         } else {
//                                           return Container();
//                                         }
//                                       },
//                                     );
//                                   },
//                                                       ),
//                                                     ),
//                                 ),
//                               ],
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Future<void> _sendEmail() async {
//     String subject = 'Test Email Subject';
//     String body = 'This is the body of the email \+with spaces.';
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: 'arjunsinh08vaghela@gmail.com', // Recipient email address
//       queryParameters: {
//         'subject': subject ,  // Email subject
//         'body': body,  // Email body content
//       },
//     );
//     // Launch the email client with the email URI
//     try {
//      final  emailUri2 = emailUri.toString().replaceAll('+',' ');
//       final url = Uri.parse(emailUri2);
//       await launchUrl(url);
//     } catch (e) {
//       print('Could not launch email client: $e');
//    }
//   }
//
//   Future<void> _signOutUser() async {
//     String message = await context.read<MyAuthProvider>().signOutUser();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(color: Colors.white),
//         ),
//         duration: Duration(seconds: 3),
//         backgroundColor:
//         message == "Logout successful" ? Colors.green : Colors.red,
//       ),
//     );
//
//     if (message == "Logout successful") {
//       // context.read<BottomNavigationProvider>().changeSelectedIndex(0);
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           // builder: (context) => RegisterScreen(),
//           builder: (context) => LoginScreen(),
//         ),
//             (Route<dynamic> route) => false,
//       );
//     }
//   }
//
//   Widget CustomeSalesCard({
//     required record,
//   }) {
//     return Card(
//       margin: EdgeInsets.all(8.0.r),
//       child: ListTile(
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('Item :'),
//                 SizedBox(width: 2.w),
//                 Text(
//                   '${record['Item Name']} ,',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Stock :'),
//                 SizedBox(width: 2.w),
//                 Text(
//                   '${record['Item Stock']} ,',
//                   style: TextStyle(
//                     color: int.parse(record['Item Stock'].split(' ').first) < 50
//                         ? Colors.red
//                         : Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Row(
//               children: [
//                 Text('Item Price :'),
//                 SizedBox(width: 2.w),
//                 Text(
//                   '${record['Item Price']} ,',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
