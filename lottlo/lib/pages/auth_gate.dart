import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'third_page.dart';

// ignore: must_be_immutable
class AuthGate extends StatelessWidget {
 bool checkWhat = false;

  AuthGate({super.key});

 @override
 Widget build(BuildContext context) {
   return StreamBuilder<User?>(
     stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context, snapshot) {
       if (!snapshot.hasData) {
         return Theme(
           data: Theme.of(context).copyWith(
             scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255), // Set your desired background color here
           ),
           child: SignInScreen(
             providers: [
               EmailAuthProvider(),
              //  GoogleProvider(clientId: "715833886581-74so992ov82qguaaadrkdcbf0lv0bb2d.apps.googleusercontent.com"),
             ],
             headerBuilder: (context, constraints, shrinkOffset) {
               return Padding(
                 padding: const EdgeInsets.all(20),
                 child: AspectRatio(
                   aspectRatio: 1,
                   child: Image.asset('assets/authIcon.png'),
                 ),
               );
             },
             subtitleBuilder: (context, action) {
               checkWhat = action == AuthAction.signIn? true:false;
               return Padding(
                 padding: const EdgeInsets.symmetric(vertical: 8.0),
                 child: action == AuthAction.signIn
                     ? const Text('Welcome to Lottlo Fashion App, please sign in!')
                     : const Text('Welcome to Lottlo Fashion App, please sign up!'),
               );
             },
             footerBuilder: (context, action) {
               return const Padding(
                 padding: EdgeInsets.only(top: 16),
                 child: Text(
                   'By signing in, you agree to our terms and conditions.',
                   style: TextStyle(color: Colors.grey),
                 ),
               );
             },
             sideBuilder: (context, shrinkOffset) {
               return Padding(
                 padding: const EdgeInsets.all(20),
                 child: AspectRatio(
                   aspectRatio: 1,
                   child: Image.asset('assets/authIcon.png'),
                 ),
               );
             },
           ),
         );
       }

       if (checkWhat){
          return const Home();
       } else{
        return  ThirdPage();
       }
     },
   );
 }
}
