import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/welcome.jpg",
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.colorBurn,
            ),
          ),
          Container(
            color: Colors.black54,
          ),
          Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: SizedBox(
              width: 400,
              child: Column(
                children: [
                  Text(
                    "Streaming Team Assistance",
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The right communication tool for media production with 0 noise.",
                    style: GoogleFonts.workSans(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: "button1",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const LoginScreen()),
                            ));
                      },
                      label: Text(
                        "Login",
                        style: GoogleFonts.workSans(
                          color: Colors.white,
                        ),
                      ),
                      foregroundColor: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton.extended(
                      heroTag: "button2",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const SignupScreen()),
                            ));
                      },
                      label: Text(
                        "Signup",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
