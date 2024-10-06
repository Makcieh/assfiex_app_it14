// ignore_for_file: use_build_context_synchronously
import 'package:assfiex_app_it14/manager_side/components/my_textfield.dart';
import 'package:assfiex_app_it14/employee_side/pages/home.dart';
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
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
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
        return const AlertDialog(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              'Invalid Email or Password',
              style: TextStyle(color: Colors.white, fontSize: 20),
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
              color: Color.fromARGB(255, 255, 255, 255),
              size: 100,
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Welcome Manager!",
                      style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
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
                    ElevatedButton(
                      onPressed: signUserIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Sign In',
                          style: TextStyle(color: Colors.white)),
                    ),

                    const SizedBox(height: 15),

                    //enter as employee or guest
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter as',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Employee Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmployeeHome()),
                            );
                          },
                          child: Text(
                            'Employee',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('or'),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Guest Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmployeeHome()),
                            );
                          },
                          child: Text(
                            'Guest',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            //Welcome Manager!
          ],
        ),
      ))),
    );
  }
}
