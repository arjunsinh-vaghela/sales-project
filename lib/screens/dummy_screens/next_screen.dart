// import 'package:flutter/material.dart';
//
// import '../bottom_navigation_screen.dart';
//
//
// class nextScreen extends StatefulWidget {
//   const nextScreen({super.key});
//
//   @override
//   State<nextScreen> createState() => _nextScreenState();
// }
//
// class _nextScreenState extends State<nextScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.keyboard_backspace_rounded)),
//         ),
//         body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "next Screen",
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
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => BottomNavBar(
//                           selectedIndex: 2,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text('Go to profile screen  to bottomnavigation screen'),
//                 ),
//               ],
//             ),
//             ),
//         );
//     }
// }