
import 'dart:io'; // For platform checks
import 'package:flutter/foundation.dart' show kIsWeb; // For web checks
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'data/firestore/upload_image.dart';
import 'providers/auth_provider/auth_provider.dart';
import 'providers/bottom_navigation_provider.dart';
import 'providers/passwordfield_togaal_provider.dart';
import 'providers/profile_data_provider.dart';
import 'providers/purchase_data_provider.dart';
import 'providers/sales_data_provider.dart';
import 'providers/tax_type_provider.dart';
import 'screens/auth_screens/register_screen.dart';
import 'screens/bottom_navigation_screen.dart';
import 'firebase_options.dart';
import 'screens/dummy_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase based on platform
  if (kIsWeb) {
    // Web platform
    print("Initializing Firebase for Web...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Mobile platforms
    if (Firebase.apps.isEmpty) {
      print("Initializing Firebase for Mobile...");
      await Firebase.initializeApp();
    } else {
      print("Firebase already initialized for Mobile.");
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAuthProvider()),
        // ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context) => SalesDataProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseDataProvider()),
        ChangeNotifierProvider(create: (context) => PasswordfieldTogaalProvider()),
        ChangeNotifierProvider(create: (context) => ProfileDataProvider()),
        ChangeNotifierProvider(create: (context) => TaxTypeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if a user is logged in
    final User? user = FirebaseAuth.instance.currentUser;

   // Navigate based on user authentication status
    if (user != null) {
      return BottomNavigationScreen(); // User is logged in
    } else {
      return RegisterScreen(); // User is not logged in
    }
   // //  return UploadImage();
   //  return DummyTest();

  }
}
