
import 'package:fall_watch_app/pages/fallDetect_Information/fallDetectInformationPage.dart';
import 'package:fall_watch_app/services/auth_EmailAndPass.dart';
import 'package:fall_watch_app/widgets/customButton.dart';
import 'package:fall_watch_app/widgets/textFieldDesign.dart';
import 'package:fall_watch_app/widgets/validators.dart';
import 'package:fall_watch_app/widgets/variousDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  void loginEmailAndPassword() async {
    User? user = await _auth.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FallDetectInformationPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
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
              // SizedBox(width: 330, height: 250, child:Image.asset('images/welcome-board.png')),
              const SizedBox(height: 50),
              const Text('Welcome!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
              const SizedBox(height: 10),
              const Text('Sign In to Continue', style: TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextFormField(emailController, false, 'Email', emailValidator),
                    const SizedBox(height: 30),
                    buildTextFormField(passwordController, true, 'Password', passwordValidator),
                  ],
                ),
              ),
              const SizedBox(height: 65),
              Center(
                child: buttonDesign1(
                  'LOG IN', 
                  const Color.fromRGBO(230, 81, 0, 1), 
                  ButtonStyleType.primary, 
                  Colors.white, 
                  () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                      loginEmailAndPassword();
                      });
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 50,),
          
              // dividerWithText('Or'),
              // const SizedBox(height: 30),
              // const Center(child: Text('Sign In With Gmail', style: TextStyle(fontSize: 17, color: Colors.black38, fontWeight: FontWeight.bold))),
              // const SizedBox(height: 20),
              // Center(child: smallImageButton( () { }))
            ],
          ),
        ),
        )
    );
  }
}
