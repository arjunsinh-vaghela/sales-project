import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constes/ui_helper.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/passwordfield_togaal_provider.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                SizedBox(height: 40,),
                UiHelper.CustomeElevetedButton(
                  text: "Update Password",
                  onPressed: () async {
                    if(_formKey.currentState?.validate() ?? false){
                      await _ForgotPassword();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));
                    }
                  },
                  fontWeight: FontWeight.bold,
                  // fontSize: 18.sp,
                  textColor: Colors.white,
                  buttonColor: Colors.blue,
                  // onPressed: () {  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _ForgotPassword () async {
    // Await the result of the signUpUser  method
    String message = await context.read<MyAuthProvider>().forgotPassword (
      email: emailController.text,
    );

    // Show a Snackbar with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: message == "Password Updated successful" ? Colors.green : Colors.red ,
      ),
    );

    // Optionally navigate to the login screen if registration is successful
    if (message == "Password Updated successful") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
  }
}
