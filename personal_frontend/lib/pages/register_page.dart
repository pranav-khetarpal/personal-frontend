import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_button.dart';
import 'package:personal_frontend/components/my_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // login method
  void register() async {
    // show loading circle
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure the passwords match
    if (passwordController.text == confirmPasswordController.text) {
      // try creating the user
      try {
        // create the user
        UserCredential? userCredential = 
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text, 
              password: passwordController.text,
            );
        
        // // create a user and add to firestore
        // createUserDocument(userCredential);
        
        // pop loading circle
        if (context.mounted) Navigator.pop(context);

      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.code, context);
      }
    } else {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Password's don't match", context);
    }
  }

  // // create a user document and collect them in firestore
  // Future<void> createUserDocument(UserCredential? userCredential) async {
  //   if (userCredential != null && userCredential.user != null) {
  //     await FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc(userCredential.user!.email)
  //         .set({
  //           'email': userCredential.user!.email,
  //           'username': usernameController.text,
  //         });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
          
              const SizedBox(height: 25),
          
              // app name
              const Text(
                "M I N I M A L",
                style: TextStyle(fontSize: 20,),
              ),
          
              const SizedBox(height: 50),

              // username textfield
              MyTextField(
                hintText: "Username", 
                obscureText: false, 
                controller: usernameController,
              ),

              const SizedBox(height: 10),
          
              // email textfield
              MyTextField(
                hintText: "Email", 
                obscureText: false, 
                controller: emailController,
              ),

              const SizedBox(height: 10),
          
              // password textfield
               MyTextField(
                hintText: "Password", 
                obscureText: true, 
                controller: passwordController,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
               MyTextField(
                hintText: "Confirm Password", 
                obscureText: true, 
                controller: confirmPasswordController,
              ),

              const SizedBox(height: 10),
          
              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary)
                  ),
                ],
              ),

              const SizedBox(height: 25),
          
              // register button
              MyButton(
                text: "Register", 
                onTap: register,
              ),

              const SizedBox(height: 25),
          
              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
