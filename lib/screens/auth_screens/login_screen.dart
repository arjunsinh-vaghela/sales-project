import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../constes/responsive_font_size.dart';
import '../../constes/ui_helper.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/passwordfield_togaal_provider.dart';
import '../../providers/show_loder_provider.dart';
import '../bottom_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final showLoader = Provider.of<ShowLoaderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8, // Ensures full screen height
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Sales Notes',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          SizedBox(height: 50.h),
                          UiHelper.CustomTextFormField(
                            controller: emailController,
                            hintText: "Enter Email",
                            suffixIcon: Icon(Icons.email),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email cannot be empty";
                              }
                              String emailPattern =
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                              if (!RegExp(emailPattern).hasMatch(value)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Consumer<PasswordfieldTogaalProvider>(
                            builder: (context, passwordProvider, child) {
                              return UiHelper.CustomTextFormField(
                                controller: passController,
                                hintText: "Enter Password",
                                isHide: passwordProvider.isHide,
                                isPassword: true,
                                suffixIcon: passwordProvider.isHide
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onSuffixIconPressed: () {
                                  passwordProvider.toToggal();
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
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 45.h),
                    UiHelper.CustomeElevetedButton(
                      text: "Login",
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          showLoader.setLoading(true);
                          await _signInUser();
                          showLoader.setLoading(false);
                        }
                      },
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                      buttonColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // body: SingleChildScrollView(
      //   physics: BouncingScrollPhysics(),
      //   child: Center(
      //     child: Padding(
      //       padding: const EdgeInsets.all(12),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Form(
      //             key: _formKey,
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 SizedBox(height: 50.h,),
      //                 // Text('Login', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
      //                 // SizedBox(height: 40,),
      //                 UiHelper.CustomTextFormField(
      //                   controller: emailController,
      //                   hintText: "Enter Email",
      //                   suffixIcon: Icon(Icons.email),
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return "Email cannot be empty";
      //                     }
      //                     // Regex for email validation
      //                     String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      //                     if (!RegExp(emailPattern).hasMatch(value)) {
      //                       return "Enter a valid email address";
      //                     }
      //                     return null;
      //                   },
      //                 ),
      //                 SizedBox(height: 20,),
      //                 Consumer<PasswordfieldTogaalProvider>(
      //                   builder: (context, passwordProvider, child) {
      //                     return UiHelper.CustomTextFormField(
      //                       controller: passController,
      //                       hintText: "Enter Password",
      //                       isHide: passwordProvider.isHide,// Provider-controlled visibility
      //                       isPassword: true,
      //                       // obscureText: passwordProvider.isHide,
      //                       suffixIcon: passwordProvider.isHide
      //                           ?  Icon(Icons.visibility_off)
      //                           : Icon(Icons.visibility), // Change icon dynamically
      //                       onSuffixIconPressed: () {
      //                         passwordProvider.toToggal(); // Toggle visibility
      //                       },
      //                       validator: (value) {
      //                         if (value == null || value.isEmpty) {
      //                           return "Password cannot be empty";
      //                         }
      //                         if (value.length < 3) {
      //                           return "Password must be at least 3 characters";
      //                         }
      //                         return null;
      //                       },
      //                     );
      //                   },
      //                 ),
      //                 SizedBox(height: 10,),
      //                 ConstrainedBox(
      //                   constraints: BoxConstraints(
      //                       maxWidth: 600
      //                   ),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.end,
      //                     children: [
      //                       ConstrainedBox(
      //                         constraints: BoxConstraints(
      //                           maxWidth: 700
      //                         ),
      //                         child: InkWell(
      //                           child: Text('Forgot Password?',
      //                             style: TextStyle(
      //                                 fontWeight: FontWeight.bold,
      //                                 fontSize: 16,    // ResponsiveFontSize.getFontSize(12, 9, 5),
      //                             ),),
      //                           onTap: () {
      //                             Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),));
      //                           },
      //                         ),
      //                       ),
      //                       SizedBox(width: 10,),
      //                     ],
      //                   ),
      //                 ),
      //                 // SizedBox(height: 50,),
      //                 // UiHelper.CustomeElevetedButton(
      //                 //   text: "Login",
      //                 //   onPressed: () async {
      //                 //     if(_formKey.currentState?.validate() ?? false){
      //                 //       await _signInUser();
      //                 //       // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));
      //                 //     }
      //                 //   },
      //                 //   fontWeight: FontWeight.bold,
      //                 //   // fontSize: 18.sp,
      //                 //   textColor: Colors.white,
      //                 //   buttonColor: Colors.blue,
      //                 // ),
      //                 // SizedBox(height: 30,),
      //                 // InkWell(
      //                 //   child: Row(
      //                 //     mainAxisAlignment: MainAxisAlignment.center,
      //                 //     children: [
      //                 //       Text(
      //                 //         "Don't have an account? ",
      //                 //         style: TextStyle(
      //                 //             fontWeight: FontWeight.bold,
      //                 //             fontSize: 18,// ResponsiveFontSize.getFontSize(13, 9, 5),
      //                 //         ),
      //                 //       ),
      //                 //       Text('Sign Up',
      //                 //         style: TextStyle(
      //                 //             fontWeight: FontWeight.bold,
      //                 //             fontSize: 18, //ResponsiveFontSize.getFontSize(13, 9, 5),
      //                 //             color: Colors.cyan
      //                 //         ),
      //                 //       ),
      //                 //     ],
      //                 //   ),
      //                 //   onTap: () {
      //                 //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
      //                 //   },
      //                 // ),
      //
      //             ],
      //             ),
      //           ),
      //           SizedBox(
      //             height: 45.h,
      //           ),
      //           UiHelper.CustomeElevetedButton(
      //             text: "Login",
      //             onPressed: () async {
      //               if(_formKey.currentState?.validate() ?? false){
      //                 showLoader.setLoading(true);
      //                 await _signInUser();
      //                 showLoader.setLoading(false);
      //                 // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));
      //               }
      //             },
      //             fontWeight: FontWeight.bold,
      //             // fontSize: 18.sp,
      //             textColor: Colors.white,
      //             buttonColor: Colors.blue,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> _signInUser () async {
    // Await the result of the signUpUser  method
    String message = await context.read<MyAuthProvider>().signInUser (
      email: emailController.text,
      password: passController.text,
    );

    // Show a Snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.white),),
        duration: Duration(seconds: 3),
        backgroundColor: message == "Login successful" ? Colors.green : Colors.red ,
      ),
    );

    // Optionally navigate
    if (message == "Login successful") {
      Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(builder: (context) => BottomNavigationScreen(),),
            (Route<dynamic> route) => false,
      );
    }
  }

}

// constraints: BoxConstraints(
// maxWidth: 700,
// minWidth: 300// Set a max width (adjust based on design)
// ),