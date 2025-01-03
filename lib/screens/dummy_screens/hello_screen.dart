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

/// main.yml file for ci/cd
// on:
// pull_request:
// branches:
// - main
// - master
// push:
// branches:
// - main
// - master
// - develop
// name: "Build & Release"
// jobs:
// build:
// name: Build & Release
// runs-on: windows-latest
// steps:
// - uses: actions/checkout@v3
// - uses: actions/setup-java@v3
// with:
// distribution: 'zulu'
// java-version: '12'
// - uses: subosito/flutter-action@v2
// with:
// channel: 'stable'
// architecture: x64
//
// - run: flutter build apk --release --split-per-abi
// - run: |
// flutter build ios --no-codesign
// cd build/ios/iphoneos
// mkdir Payload
// cd Payload
// ln -s ../Runner.app
// cd ..
// zip -r app.ipa Payload
// - name: Push to Releases
// uses: ncipollo/release-action@v1
// with:
// artifacts: "build/app/outputs/apk/release/*,build/ios/iphoneos/app.ipa"
// tag: v1.0.${{ github.run_number }}
// token: ${{ secrets.SALES_TOKEN }}