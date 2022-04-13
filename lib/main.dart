import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hash_tag/provider/google_sign_in.dart';
import 'package:hash_tag/screens/home_screen.dart';
import 'package:hash_tag/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future main() async {
  print("1");
  WidgetsFlutterBinding.ensureInitialized();
  print("2");
  await Firebase.initializeApp();
  print("3");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
     return Provider(
       create: (context) => GoogleAuth(),
       child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {HomeScreen.routeName: (ctx) => HomeScreen()},
         ),
     );
  }
}
