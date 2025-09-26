import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final  Email = TextEditingController();
  final  Password = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

 final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility1() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  Future<void> _signUp() async {
    // Validate email and password
    if (Email.text.isEmpty || Password.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

    if (!Email.text.contains('@')) {
      _showErrorDialog("Please enter a valid email address");
      return;
    }

    if (Password.text.length < 6) {
      _showErrorDialog("Password should be at least 6 characters long");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: Email.text.trim(),
        password: Password.text,
      );

      // Success - navigate to login page or home page
      _showSuccessDialog("Account created successfully!");

    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred during sign up";

      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak. Please use a stronger password.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "An account already exists with this email address. Please sign in instead.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid. Please check and try again.";
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = "Email/password accounts are not enabled. Please contact support.";
      } else if (e.code == 'network-request-failed') {
        errorMessage = "Network error. Please check your internet connection and try again.";
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog("An unexpected error occurred. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sign Up Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success!"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text("Continue to Login"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create An Account"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_person, size: 60, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    "Create an Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Fill in your details to get started",
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: Email,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      fillColor: Colors.grey,
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: Password,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.grey,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: togglePasswordVisibility1,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: 280,
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : TextButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text("Sign In"),
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