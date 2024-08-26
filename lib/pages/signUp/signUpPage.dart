
import 'package:fall_watch_app/pages/logIn/loginPage.dart';
import 'package:fall_watch_app/services/auth_EmailAndPass.dart';
import 'package:fall_watch_app/widgets/customButton.dart';
import 'package:fall_watch_app/widgets/textFieldDesign.dart';
import 'package:fall_watch_app/widgets/validators.dart';
import 'package:fall_watch_app/widgets/variousDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  void signUpWithEmailAndPassword() async {
    try {
      User? user = await _auth.registerWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.arrow_back, color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(width: 330, height: 250, child: Image.asset('images/welcome-board.png')),
              const SizedBox(height: 30),
              const Text('Hi!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
              const SizedBox(height: 10),
              const Text(
                'Create a New Account',
                style: TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextFormField(nameController, false, 'Full Name', nameValidator),
                    const SizedBox(height: 30),
                    buildTextFormField(emailController, false, 'Email', emailValidator),
                    const SizedBox(height: 30),
                    buildTextFormField(passwordController, true, 'Password', passwordValidator),
                  ],
                ),
              ),
              const SizedBox(height: 65),
              Center(
                child: buttonDesign1(
                  'SIGN UP', 
                  const Color(0xFF5246bc), 
                  ButtonStyleType.primary, 
                  Colors.white, 
                  () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        signUpWithEmailAndPassword();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Sign Up With Gmail',
                  style: TextStyle(fontSize: 17, color: Colors.black38, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: smallImageButton(() {})),
            ],
          ),
        ),
      ),
    );
  }
}
