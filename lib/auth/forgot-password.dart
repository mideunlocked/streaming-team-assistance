import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Password reset link sent to email",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Error message",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              content: Text(
                e.message.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var workSans = GoogleFonts.workSans(color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Reset password',
          style: workSans.copyWith(
            color: Colors.black,
          ),
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Enter your email and we will send you a password reset link",
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: HexColor("#506079"),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    style: Theme.of(context).textTheme.bodyText2,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    textInputAction: TextInputAction.done,
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
              MaterialButton(
                onPressed: () {
                  passwordReset();
                },
                color: Colors.greenAccent[400],
                child: Text(
                  "Reset password",
                  style: workSans,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
