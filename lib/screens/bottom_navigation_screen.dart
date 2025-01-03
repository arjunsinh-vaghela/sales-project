
import 'package:flutter/material.dart';
import 'package:sales_project/screens/sales_screen.dart';

import 'profile_screen.dart';
import 'purchase_screen.dart';


class BottomNavigationScreen extends StatefulWidget {
  final int selectedIndex;
 // for go to following main screens change selected index to screen and push BottomNavigationScreen
  BottomNavigationScreen({this.selectedIndex = 0}); // Default to 0 if not provided

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  late int _selectedIndex; // current page
  final Set<int> _visitedScreens = {}; // unique visited screen for add
  final Set<int> _visited = {}; // Set to ensure unique screen visits for remove
  final List<int> _navigationOrder = []; // track all visited screen
  late List<int> onlyNavigateScreen = []; // latest reversed track
  final List<int> addnavigationscreen = []; // reverse _navigationOrder
  int cnt = 0;

  @override
  void initState() {
    super.initState();
    onlyNavigateScreen.add(0); // add home page in at starting for last screen
    _selectedIndex = widget.selectedIndex; // Initialize with the passed index
  }

  final List<Widget> _screens = [
    const SalesScreen(),
    const PurchaseScreen(),
    const ProfileScreen(),
  ];

  // when tapped on bttom navigation item
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index , change screen
      if (_visitedScreens.isEmpty) { // if no screen is available add home screen
        _visitedScreens.add(0);
        _navigationOrder.add(0);
      }
      // Add the tab to the set if it hasn't been visited already
      if (!(_visitedScreens.contains(index))) {
        _visitedScreens.add(index);
      }
      _navigationOrder.add(index);
      // cnt++; // Keep track of the order of visits
      // print(cnt);
      print('visited screen ${_visitedScreens}');
      print('navigation screen ${_navigationOrder}');
    });
  }

  Future<bool> _onWillPop() async {
    setState(() {
      // last se unique find kar raha hai
      while (_navigationOrder.length > 1) {
        if (!addnavigationscreen.contains(_navigationOrder.last)) {
          addnavigationscreen.add(_navigationOrder.last);
        }
        _navigationOrder.removeLast();
      }

    });
    setState(() {
      // onlyNavigateScreen.add(0);
      // store reverced addnavigationscreen in onlyNavigateScreen
      while (addnavigationscreen.isNotEmpty) {
        onlyNavigateScreen.add(addnavigationscreen.last);
        addnavigationscreen.removeLast();
      }
    });

    print('onlyNavigateScreen Screen is : $onlyNavigateScreen');

    // // If there's more than one screen in the order, remove the current screen and go bad
    if (onlyNavigateScreen.length == 1) {
      onlyNavigateScreen.clear();
      _navigationOrder.clear();
      // _navigationOrder.add(0);
    }


    if (onlyNavigateScreen.isNotEmpty) {
      // remove finallize screen
      print('navigationoredr length : ${onlyNavigateScreen.length}');
      if (!_visited.contains(onlyNavigateScreen.last)) {
        setState(() {
          _visited.add(onlyNavigateScreen.last);
          onlyNavigateScreen.removeLast();
          _selectedIndex = onlyNavigateScreen.last;
        });
      }

     // reset all variables or list
      if (_navigationOrder.isEmpty) {
        _visited.clear();
        _selectedIndex = 0;
        onlyNavigateScreen.clear();
        _visitedScreens.clear();
        addnavigationscreen.clear();
      }

      print('visited remove ${_visited}');
      // print('cnt is = ${cnt}');
      print('selected index = $_selectedIndex');
      print('after removing array is ${_navigationOrder}');

      return false; // Prevent app exit
    } else {
      return true;
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,

                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Sales',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag),
                    label: 'Purchase',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
              ),
        ));
    }
}



//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/bottom_navigation_provider.dart';
// import 'profile_screen.dart';
// import 'purchase_screen.dart';
// import 'sales_screen.dart';
//
//
// class BottomNavigationScreen extends StatefulWidget {
//   final int selectedIndex;
//
//   BottomNavigationScreen({super.key,this.selectedIndex = 0}); // Default to 0 if not provided
//   // const BottomNavigationScreen({super.key, required this.selectedIndex});
//
//   static final List<Widget> _mainScreensOfApp = <Widget>[
//     const SalesScreen(),
//     const PurchaseScreen(),
//     const ProfileScreen(),
//   ];
//
//   @override
//   State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
// }
//
// class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
//   Future<bool> _onWillPop(BuildContext context) async {
//     final providerState = Provider.of<BottomNavigationProvider>(context, listen: false);
//     if (providerState.selectedIndex != 0) {
//       providerState.changeSelectedIndex(0); // Navigate back to the Sales screen
//       return false; // Prevent the app from closing
//     }
//     return true; // Allow the app to close if already on the SalesScreen
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _onWillPop(context),
//       child: Scaffold(
//         body: Consumer<BottomNavigationProvider>(
//           builder: (context, providerState, child) {
//             return IndexedStack(
//               index: providerState.selectedIndex,
//               children: BottomNavigationScreen._mainScreensOfApp,
//             );
//           },
//         ),
//         bottomNavigationBar: Consumer<BottomNavigationProvider>(
//           builder: (context, providerState, child) {
//             return BottomNavigationBar(
//               selectedItemColor: Colors.green,
//               unselectedItemColor: Colors.grey,
//               currentIndex: providerState.selectedIndex,
//               onTap: (index) => providerState.changeSelectedIndex(index),
//               items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.shopping_cart),
//                   label: 'Sales',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.shopping_bag),
//                   label: 'Purchase',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: 'Profile',
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



//
//
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:sales_project/screens/sales_screen.dart';
// //
// // import '../providers/bottom_navigation_provider.dart';
// // import 'profile_screen.dart';
// // import 'purchase_screen.dart';
// //
// // class BottomNavScreen extends StatefulWidget {
// //   @override
// //   _BottomNavScreenState createState() => _BottomNavScreenState();
// // }
// //
// // class _BottomNavScreenState extends State<BottomNavScreen> {
// //   int _currentIndex = 0; // To track the current index of the bottom nav
// //
// //   final List<Widget> _screens = [
// //     const SalesScreen(),
// //     const PurchaseScreen(),
// //     const ProfileScreen(),
// //   ];
// //
// //   void navigateToScreen(int index) {
// //     final providerState = Provider.of<BottomNavigationProvider>(context, listen: false);
// //     providerState.changeSelectedIndex(index);
// //     // if (providerState.selectedIndex != 0) {
// //     //   providerState.changeSelectedIndex(0); // Navigate back to the Sales screen
// //     //   // return false; // Prevent the app from closing
// //     // }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //           title: Text('Bottom Navigation Demo'),
// //           actions: [
// //             PopupMenuButton<String>(
// //               onSelected: (value) {
// //                 if (value == 'Settings') {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => SettingsScreen(
// //                         navigateToBottomNav: navigateToScreen,
// //                       ),
// //                     ),
// //                   );
// //                 } else if (value == 'Home') {
// //                   setState(() {
// //                     _currentIndex = 0; // Navigate to the Home screen
// //                   });
// //                 }
// //               },
// //               itemBuilder: (context) {
// //                 return ['Home', 'Settings'].map((String choice) {
// //                   return PopupMenuItem<String>(
// //                     value: choice,
// //                     child: Text(choice),
// //                   );
// //                 }).toList();
// //               },
// //             ),
// //           ],
// //         ),
// //         body: _screens[_currentIndex], // Display the current screen
// //         bottomNavigationBar: BottomNavigationBar(
// //             currentIndex: _currentIndex,
// //             onTap: (index) {
// //               setState(() {
// //                 _currentIndex = index;
// //               });
// //             },
// //             selectedItemColor: Colors.black, // Color of the selected item
// //             unselectedItemColor: Colors.grey, // Color of unselected items
// //             selectedLabelStyle: TextStyle(
// //               fontWeight: FontWeight.bold, // Bold style for selected label
// //             ),
// //             unselectedLabelStyle: TextStyle(
// //               fontWeight: FontWeight.normal, // Normal style for unselected label
// //             ),
// //             items: const [
// //               BottomNavigationBarItem(
// //                 icon: Icon(
// //                   Icons.home,
// //                   color: Colors.green,
// //                 ),
// //                 label: 'Home',
// //               ),
// //               BottomNavigationBarItem(
// //                 icon: Icon(Icons.call, color: Colors.green),
// //                 label: 'Second',
// //               ),
// //               BottomNavigationBarItem(
// //                 icon: Icon(Icons.person, color: Colors.green),
// //                 label: 'Third',
// //               ),
// //             ],
// //             ),
// //         );
// //     }
// // }


// import 'package:flutter/material.dart';
//
// import 'dummy_screens/home_screen.dart';
// import 'dummy_screens/profile_dummy_screen.dart';
// import 'dummy_screens/setting_screen.dart';
//
//
//
// class BottomNavBar extends StatefulWidget {
//   final int selectedIndex;
//
//   BottomNavBar({this.selectedIndex = 0}); // Default to 0 if not provided
//
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   late int _selectedIndex;
//   final Set<int> _visitedScreens = {}; // Set to ensure unique screen visits
//   final List<int> _navigationOrder = [];
//   late List<int> lasttwo = [];
//   final List<int> revTwo = [];
//   int cnt = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.selectedIndex; // Initialize with the passed index
//   }
//
//   final List<Widget> _screens = [
//     homeScreen(),
//     settingScreen(),
//     ProfileDummyScreen()
//   ];
//
//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index; // Update the selected tab index
//       // if (_visitedScreens.isEmpty && !_visitedScreens.contains(0)) {
//       //   _visitedScreens.add(index);
//       //   _navigationOrder.add(index);
//       // }
//       // Add the tab to the set if it hasn't been visited already
//       if (!_visitedScreens.contains(index)) {
//         _visitedScreens.add(index);
//       }
//       _navigationOrder.add(index);
//       cnt++; // Keep track of the order of visits
//       print(cnt);
//       print('visited screen ${_visitedScreens}');
//       print('navigation screen ${_navigationOrder}');
//     });
//   }
//
//   Future<bool> _onWillPop() async {
//     // If there's more than one screen in the order, remove the current screen and go back
//     if (_navigationOrder.length > cnt - 2) {
//       setState(() {
//         _navigationOrder.removeLast();
//         _selectedIndex = _navigationOrder.last;
//         print(
//             'selected index ${_selectedIndex}'); // Go back to the last visited tab
//       });
//       return false; // Prevent app exit
//     } else {
//       return true;
//     }
//
//     // When back is pressed on the first screen (Screen 1) and no other screens are in stack, exit the app
//     if (_navigationOrder.length == 1) {
//       return true; // Allow exit when on the first screen
//     }
//
//     return false; // Default case to prevent exit
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: _onWillPop,
//         child: Scaffold(
//             body: _screens[_selectedIndex],
//             bottomNavigationBar: BottomNavigationBar(
//               items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   label: 'Home',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.settings),
//                   label: 'Settings',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: 'Profile',
//                 ),
//               ],
//               currentIndex: _selectedIndex,
//               onTap: _onTabTapped,
//             ),
//         ));
//     }
// }