// ignore_for_file: use_build_context_synchronously

import 'package:assfiex_app_it14/components/my_button.dart';
import 'package:assfiex_app_it14/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async {
    //loading screen
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //trying to sign in

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading screen
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading screen
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect Password"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 18),
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            //logo
            const Icon(
              Icons.lock,
              color: Colors.white,
              size: 100,
            ),

            const SizedBox(height: 50),

            //Welcome Manager!
            const Text(
              "Welcome Manager!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),

            const SizedBox(height: 25),

            //email
            MyTextfield(
              controller: emailController,
              hintText: 'Username',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            //password
            MyTextfield(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(
              height: 10,
            ),

            //forgot pass
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            //sign in button
            MyButton(
              onTap: signUserIn,
            ),

            const SizedBox(height: 15),
            //register new manager
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Are you a new', style: TextStyle(color: Colors.white)),
                SizedBox(width: 4),
                Text('Manager?',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            //enter as employee or guest
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter as', style: TextStyle(color: Colors.white)),
                SizedBox(width: 4),
                Text('Employee or Guest',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ))),
    );
  }
}
