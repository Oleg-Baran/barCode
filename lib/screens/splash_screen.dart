import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hash_tag/provider/google_sign_in.dart';
import 'package:hash_tag/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var googleAuth = Provider.of<GoogleAuth>(context, listen: false);
    googleAuth.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }
}

Widget body(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: signUpButton(context),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget signUpButton(BuildContext context) {
  final googleAuth = Provider.of<GoogleAuth>(context);
  return Center(
    child: SignInButton(
      Buttons.Google,
      onPressed: () => googleAuth.loginGoogle(),
    ),
  );
}
