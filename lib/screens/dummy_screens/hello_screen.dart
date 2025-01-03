//
// import 'package:flutter/material.dart';
//
// import 'basic_screen.dart';
//
//
// class helloScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 // Navigator.pop(context);
//               },
//               icon: Icon(Icons.keyboard_backspace_rounded)),
//         ),
//         body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "hello1 Screen",
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
//                         builder: (context) => basicScreen(),
//                       ),
//                     );
//                   },
//                   child: Text('Go to basic screen'),
//                 ),
//               ],
//             ),
//             ),
//         );
//     }
// }