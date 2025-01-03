import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../constes/responsive_font_size.dart';
import '../../constes/ui_helper.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/passwordfield_togaal_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 120,),
                Text('Login', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(height: 40,),
                UiHelper.CustomTextFormField(
                  controller: emailController,
                  hintText: "Enter Email",
                  suffixIcon: Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    // Regex for email validation
                    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    if (!RegExp(emailPattern).hasMatch(value)) {
                      return "Enter a valid email address";
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: 600
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 700
                        ),
                        child: InkWell(
                          child: Text('Forgot Password?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,    // ResponsiveFontSize.getFontSize(12, 9, 5),
                            ),),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),));
                          },
                        ),
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                UiHelper.CustomeElevetedButton(
                  text: "Login",
                  onPressed: () async {
                    if(_formKey.currentState?.validate() ?? false){
                      await _signInUser();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));
                    }
                  },
                  fontWeight: FontWeight.bold,
                  // fontSize: 18.sp,
                  textColor: Colors.white,
                  buttonColor: Colors.blue,
                ),
                SizedBox(height: 30,),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,// ResponsiveFontSize.getFontSize(13, 9, 5),
                        ),
                      ),
                      Text('Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18, //ResponsiveFontSize.getFontSize(13, 9, 5),
                            color: Colors.cyan
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                  },
                ),

            ],
            ),
          ),
        ),
      ),
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