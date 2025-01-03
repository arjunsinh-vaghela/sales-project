import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constes/ui_helper.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/passwordfield_togaal_provider.dart';
import '../bottom_navigation_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Text('Sign Up' ,style: TextStyle(fontSize: 25, color: Colors.cyan),),
              SizedBox(height: 50,),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UiHelper.CustomTextFormField(
                      controller: nameController,
                      hintText: "Enter UserName",
                      suffixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name cannot be empty";
                        }
                        if (value.length < 3) {
                          return "Name must be at least 3 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    Consumer<PasswordfieldTogaalProvider>(
                      builder: (context, passwordProvider, child) {
                        return UiHelper.CustomTextFormField(
                          controller: passController,
                          hintText: "Enter Password",
                          isHide: passwordProvider.isHide,// Provider-controlled visibility
                          isPassword: true,
                          // obscureText: passwordProvider.isHide,
                          suffixIcon: passwordProvider.isHide
                              ?  Icon(Icons.visibility_off)
                              : Icon(Icons.visibility), // Change icon dynamically
                          onSuffixIconPressed: () {
                            passwordProvider.toToggal(); // Toggle visibility
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password cannot be empty";
                            }
                            if (value.length < 3) {
                              return "Password must be at least 3 characters";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20,),
                    UiHelper.CustomTextFormField(
                      controller: emailController,
                      hintText: "Enter Email",
                      suffixIcon: Icon(Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        // // Regex for email validation
                        // String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        // Regex for email validation with a maximum length of 50 characters
                        String emailPattern = r'^(?=.{1,50}$)[a-zA-Z0-9._%+-]+@(gmail|yahoo|outlook|hotmail|icloud|aol|zoho|protonmail|customdomain)\.(com|org|net|edu|gov|io|co|us|in|uk|info|biz)$';
                        if (!RegExp(emailPattern).hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40,),
                    UiHelper.CustomeElevetedButton(
                      text: "Register",
                      onPressed: () async {
                        if(_formKey.currentState?.validate() ?? false){
                          await _signUpUser();
                        }
                      },
                      fontWeight: FontWeight.bold,
                      // fontSize: 18.sp,
                      textColor: Colors.white,
                      buttonColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 70,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r), // border radius here
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () async{
                        await _signInWithGoogle();
                      },
                      child: Image.asset(
                        'assets/images/googleIcon.png',
                        height: 14,
                        width: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    Text('Login', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Colors.cyan),),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUpUser () async {
    // Await the result of the signUpUser  method
    String message = await context.read<MyAuthProvider>().signUpUser (
      email: emailController.text,
      password: passController.text,
      firstName: nameController.text,
    );

    // Show a Snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.white),),
        duration: Duration(seconds: 3),
        backgroundColor: message == "Registration successful" ? Colors.green : Colors.red ,
      ),
    );

   // Optionally navigate to the login screen if registration is successful
    if (message == "Registration successful") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));
    }
  }

  Future<void> _signInWithGoogle() async {
    // Await the result of the signUpUser  method
    String message = await context.read<MyAuthProvider>().signInWithGoogle();

    // Show a Snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.white),),
        duration: Duration(seconds: 3),
        backgroundColor: message == "Successfully Login" ? Colors.green : Colors.red ,
      ),
    );

    // Optionally navigate to the login screen if registration is successful
    if (message == "Successfully Login") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));
    }
  }

}


// {
// "project_info": {
// "project_number": "963477278937",
// "project_id": "first-firebase-eecdc",
// "storage_bucket": "first-firebase-eecdc.firebasestorage.app"
// },
// "client": [
// {
// "client_info": {
// "mobilesdk_app_id": "1:963477278937:android:ad0d7fedbe51bc0a142ec8",
// "android_client_info": {
// "package_name": "com.astar.first_firebase"
// }
// },
// "oauth_client": [
// {
// "client_id": "963477278937-ovil2p8t1s7ktrc8leu69p2u525gjktk.apps.googleusercontent.com",
// "client_type": 1,
// "android_info": {
// "package_name": "com.astar.first_firebase",
// "certificate_hash": "d7a9b9f25d31d58d1069cfd40d7f2491fc291223"
// }
// },
// {
// "client_id": "963477278937-m9kr71rvcnhb9dqnsblv1mmfj332ga1u.apps.googleusercontent.com",
// "client_type": 3
// }
// ],
// "api_key": [
// {
// "current_key": "AIzaSyBOxCP_4FoE0DGjWUWUrXoCxhDfurt3X4s"
// }
// ],
// "services": {
// "appinvite_service": {
// "other_platform_oauth_client": [
// {
// "client_id": "963477278937-m9kr71rvcnhb9dqnsblv1mmfj332ga1u.apps.googleusercontent.com",
// "client_type": 3
// },
// {
// "client_id": "963477278937-d5ebr2ft2j9tr5n92nlgp1mbrkocs8e0.apps.googleusercontent.com",
// "client_type": 2,
// "ios_info": {
// "bundle_id": "com.example.ivonSalesProject"
// }
// }
// ]
// }
// }
// },
// {
// "client_info": {
// "mobilesdk_app_id": "1:963477278937:android:f051d8728aeaceac142ec8",
// "android_client_info": {
// "package_name": "com.ivontechhub.salesapp"
// }
// },
// "oauth_client": [
// {
// "client_id": "963477278937-m9kr71rvcnhb9dqnsblv1mmfj332ga1u.apps.googleusercontent.com",
// "client_type": 3
// }
// ],
// "api_key": [
// {
// "current_key": "AIzaSyBOxCP_4FoE0DGjWUWUrXoCxhDfurt3X4s"
// }
// ],
// "services": {
// "appinvite_service": {
// "other_platform_oauth_client": [
// {
// "client_id": "963477278937-m9kr71rvcnhb9dqnsblv1mmfj332ga1u.apps.googleusercontent.com",
// "client_type": 3
// },
// {
// "client_id": "963477278937-d5ebr2ft2j9tr5n92nlgp1mbrkocs8e0.apps.googleusercontent.com",
// "client_type": 2,
// "ios_info": {
// "bundle_id": "com.example.ivonSalesProject"
// }
// }
// ]
// }
// }
// }
// ],
// "configuration_version": "1"
// }