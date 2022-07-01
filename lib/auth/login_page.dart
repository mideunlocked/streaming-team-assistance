import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_team_assistance/scene/scene_home_page.dart';

import 'forgot-password.dart';
import 'signup_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userEmailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  var _isVisible = true;

  final _passwordNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  var _isLoading = false;

  void showSnackBar(String message) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future signIn() async {
    final isValid = _formKey.currentState!.validate();
    try {
      if (isValid == false) {
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState!.save();
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userEmailTextController.text.trim(),
          password: _passwordTextController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (err) {
      String? message = "An error occured, please check your credentials";

      if (err.message != null) {
        message = err.message;
      }
      showSnackBar(message!);
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChooseScene()),
        (route) => false);
  }

  @override
  void dispose() {
    _userEmailTextController.dispose();
    _passwordTextController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var workSans = GoogleFonts.workSans(
      color: Colors.black,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackButton(),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Welcome!",
                          style: GoogleFonts.workSans(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Sign in to continue",
                          style: GoogleFonts.workSans(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          key: const ValueKey('Email'),
                          focusNode: _passwordNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.contains('@') ||
                                !value.contains(".com")) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userEmailTextController.text = value!;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          key: const ValueKey('Password'),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                              icon: Icon(
                                _isVisible == false
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          obscureText: _isVisible,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Please enter a password of at least 7 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passwordTextController.text = value!;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () {
                                    signIn();
                                  },
                                  label: Padding(
                                    padding: const EdgeInsets.all(80),
                                    child: _isLoading == true
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .textSelectionTheme
                                                  .cursorColor,
                                            ),
                                          )
                                        : Text(
                                            "Login",
                                            style: GoogleFonts.workSans(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (contex) {
                                      return const ForgotPassword();
                                    }));
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: workSans,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Don't have an account?",
                                      style: workSans,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignupScreen()),
                                            (route) => false);
                                      },
                                      child: Text(
                                        " Register Now",
                                        style: workSans.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
