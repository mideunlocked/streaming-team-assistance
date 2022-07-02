import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:stream_team_assistance/features/custom_progress.dart';
import 'package:stream_team_assistance/scene/scene_home_page.dart';

import 'login_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final _teamNameController = TextEditingController();

  final _passwordNode = FocusNode();
  final _confPasswordnode = FocusNode();
  final _emailNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  bool isProcessing = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confPasswordnode.dispose();
    _teamNameController.dispose();

    _passwordNode.dispose();
    _confPasswordnode.dispose();
    _emailNode.dispose();

    super.dispose();
  }

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
      isProcessing = false;
    });
  }

  Future signUp() async {
    UserCredential userCredential;

    final isValid = _formKey.currentState!.validate();
    try {
      if (isValid == false) {
        return;
      } else {
        setState(() {
          isProcessing = true;
        });

        _formKey.currentState!.save();
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        var userCred = userCredential.user;

        await FirebaseFirestore.instance
            .collection("teams")
            .doc(userCredential.user?.uid)
            .set({
          "teamName": _teamNameController.text.trim(),
        });
      }

      String docId = "";

      CollectionReference teams = FirebaseFirestore.instance
          .collection("/teams/${userCredential.user?.uid}/units");

      DocumentReference docRef = await teams.add({
        "unitName": "Main unit",
      });

      setState(() {
        docId = docRef.id;
      });
      await teams.doc(docId).update({
        'docId': docId,
      });

      String unitUrl = "";
      final url = Uri.parse(
          "https://streaming-team-assistance-default-rtdb.firebaseio.com/teams/${userCredential.user?.uid}.json");

      await http
          .post(url,
              body: jsonEncode({
                "adjustUp": false,
                "adjustDown": false,
                "adjustLeft": false,
                "adjustRight": false,
                "startStreaming": false,
                "stopStreaming": false,
                "startRecording": false,
                "stopRecording": false,
                "cameraTNA": false,
                "controlTNA": false,
                "unitName": "Main unit",
                "docId": docId,
              }))
          .then((response) {
        setState(() {
          unitUrl = json.decode(response.body)["name"];
        });
      });
      print(unitUrl);
      await teams.doc(docId).update({
        "unitUrl": unitUrl,
      });

      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (contex) => const ChooseScene()),
            (Route<dynamic> route) => false);
      });
    } on FirebaseAuthException catch (err) {
      String? message = "An error occured, please check your credentials";

      if (err.message != null) {
        message = err.message;
      }
      showSnackBar(message!);
    } catch (err) {
      showSnackBar(err.toString());
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var workSans = GoogleFonts.workSans(
      fontSize: 15,
      color: Colors.black,
    );
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Hi!",
                            style: GoogleFonts.workSans(
                              color: Colors.black,
                              fontSize: 40,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Create a new account",
                            style: workSans,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: _teamNameController,
                                style: Theme.of(context).textTheme.bodyText2,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Team name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailNode,
                                style: Theme.of(context).textTheme.bodyText2,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter a email address";
                                  } else if (!value.endsWith("@gmail.com")) {
                                    return "please enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                focusNode: _passwordNode,
                                controller: _passwordController,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_confPasswordnode);
                                },
                                style: Theme.of(context).textTheme.bodyText2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter password";
                                  } else if (value.length <= 4) {
                                    return "Password can't be less than 5 characters";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                focusNode: _confPasswordnode,
                                controller: _confPasswordController,
                                obscureText: true,
                                style: Theme.of(context).textTheme.bodyText2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "confirm password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter password";
                                  } else if (value.trim() !=
                                      _passwordController.text.trim()) {
                                    return "Password doesn't match";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'By continuing, you agree to our ',
                                  style: workSans,
                                ),
                                TextSpan(
                                    text: 'Terms of Service',
                                    style: workSans.copyWith(
                                      color: Colors.greenAccent[400],
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {}),
                                TextSpan(
                                  text: ' and ',
                                  style: workSans,
                                ),
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: workSans.copyWith(
                                      color: Colors.greenAccent[400],
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {}),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          FloatingActionButton.extended(
                            onPressed: () {
                              signUp();
                            },
                            label: isProcessing == true
                                ? const CustomProgressIndicator()
                                : Text(
                                    "Sign up",
                                    style:
                                        workSans.copyWith(color: Colors.white),
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have an account?",
                                style: workSans,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false);
                                },
                                child: Text(
                                  " Sign in",
                                  style: workSans.copyWith(
                                    color: Colors.greenAccent[400],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
