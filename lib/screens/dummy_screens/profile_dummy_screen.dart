// import 'package:flutter/material.dart';
//
// import 'hello_screen.dart';
//
//
// class ProfileDummyScreen extends StatelessWidget {
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
//                   "profile Screen",
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
//                         builder: (context) => helloScreen(),
//                       ),
//                     );
//                   },
//                   child: Text('Go to hello screen'),
//                 ),
//               ],
//             ),
//             ),
//         );
//     }
// }