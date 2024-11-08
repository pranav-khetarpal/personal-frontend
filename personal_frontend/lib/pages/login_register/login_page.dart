import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/pages/base_layout.dart';
import 'package:personal_frontend/authorization/forgot_password_page.dart';
import 'package:personal_frontend/pages/main_scaffold.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserInteractionServices userServices = UserInteractionServices();

  // Login method
  Future<void> login() async {
    // Show loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      
      // Sign in user
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // // Fetch user profile
      // final userDoc = await userServices.fetchUserProfile(userCredential.user!.uid);

      // Ensure the widget is still mounted before popping the loading dialog
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (await userServices.fetchUserProfile((userCredential.user!.uid)) != null) {
          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScaffold(),
            ),
          );
        } else {
          // User document doesn't exist, log out and show error
          await FirebaseAuth.instance.signOut();

          // Display error message
          displayMessageToUser("User profile not found. Please register.", context);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Ensure the widget is still mounted before popping the loading dialog
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Display error message
        displayMessageToUser(e.message ?? "Authentication failed", context);
      }
    } catch (e) {
      // Ensure the widget is still mounted before popping the loading dialog
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Display general error message
        displayMessageToUser("An error occurred. Please try again.", context);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            
                  // app name
                  const Text(
                    "MarketGather",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 50),
                  // email textfield
                  MySquareTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                    maxLength: 254,
                    allowSpaces: false,
                  ),
                  const SizedBox(height: 10),
                  // password textfield
                  MySquareTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                    maxLength: 100,
                    allowSpaces: false,
                  ),
                  const SizedBox(height: 10),
                  // forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
            
                      // Inside your LoginPage build method
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
            
            
                      // Text(
                      //   "Forgot Password?",
                      //   style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      // ),
            
                    ],
                  ),
                  const SizedBox(height: 25),
                  // sign in button
                  MyLargeButton(
                    text: "Login",
                    onTap: login,
                  ),
                  const SizedBox(height: 25),
                  // don't have an account? Register here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
