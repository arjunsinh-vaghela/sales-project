// import 'package:flutter/material.dart';
//
// import '../bottom_navigation_screen.dart';
//
//
//
// class basicScreen extends StatefulWidget {
//   const basicScreen({super.key});
//
//   @override
//   State<basicScreen> createState() => _basicScreenState();
// }
//
// class _basicScreenState extends State<basicScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "basic Screen",
//                   style: TextStyle(
//                     fontSize: 24, // Set the font size to 24
//                     fontWeight: FontWeight.bold, // Make the font bold
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Redirect to SettingsScreen
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => BottomNavBar(
//                           selectedIndex: 1,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text('Go to Settings to bottomnavigation screen'),
//                 ),
//               ],
//             ),
//             ),
//         );
//     }
// }