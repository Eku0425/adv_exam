import 'dart:async';

import 'package:adv_exam/screen/view/signup.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      Duration(seconds: 5),
      (timer) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignupScreen(),
              // AuthServices.authServices.firebaseAuth.currentUser == null
              //     ? SignupScreen()
              //     : HomeScreen(),
            ));
      },
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset('assets/img/1.png'),
        ),
      ),
    );
  }
}
