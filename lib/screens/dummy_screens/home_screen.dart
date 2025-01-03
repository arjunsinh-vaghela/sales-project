// import 'package:flutter/material.dart';
//
// import 'next_screen.dart';
//
//
//
// class homeScreen extends StatefulWidget {
//   const homeScreen({super.key});
//
//   @override
//   State<homeScreen> createState() => _homeScreenState();
// }
//
// class _homeScreenState extends State<homeScreen> {
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
//         body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "home  Screen",
//                 style: TextStyle(
//                   fontSize: 24, // Set the font size to 24
//                   fontWeight: FontWeight.bold, // Make the font bold
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Redirect to SettingsScreen
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => nextScreen(),
//                     ),
//                   );
//                 },
//                 child: Text('Go to next screen'),
//               ),
//             ],
//          ),
//         );
//    }
// }