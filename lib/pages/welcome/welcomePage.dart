
import 'package:fall_watch_app/pages/logIn/loginPage.dart';
import 'package:fall_watch_app/pages/signUp/signUpPage.dart';
import 'package:fall_watch_app/widgets/customButton.dart';
import 'package:flutter/material.dart';


class WelcomePage extends StatelessWidget {
  
  Widget buttonDesign1 (String text1, Color color, ButtonStyleType buttonStyleType, Color textColor, VoidCallback actionPress){
    return Container(
        height: 48,
        constraints: const BoxConstraints(minWidth: 250),
        child: CustomButton(actionPressed: actionPress, 
        text: text1, 
        styleType: buttonStyleType, 
        textColor: textColor, 
        backgroundColor: color,
        ) ,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 50,),
            // SizedBox(width: 330, height: 250, child:Image.asset('images/welcome-board.png')),
            Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(color: Colors.orange[50]),
                  child: Image.asset(
                    'images/FallWatch.png',
                    fit: BoxFit.cover,
                  ),
                ),
            // const Center(child: Text('Hello', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40))),
            const Center(
              child:Text(
                'Welcome to FallWatch!\nYour peace of mind, our priority.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
                overflow: TextOverflow.visible,
              )),
            const SizedBox(height: 30,),
            buttonDesign1('LOG IN', Color.fromRGBO(230, 81, 0, 1), ButtonStyleType.primary, Colors.white, 
            (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));}),
            const SizedBox(height: 15,),
            // buttonDesign1('Sign Up', Color.fromRGBO(230, 81, 0, 1), ButtonStyleType.outline, Color.fromRGBO(230, 81, 0, 1),
            // (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));}
            // )
          ],
        )
        )
      );
  }
}