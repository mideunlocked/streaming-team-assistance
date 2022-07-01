import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/welcome_page.dart';

class CustomDrawer extends StatelessWidget {
  final String unitName;

  const CustomDrawer({
    Key? key,
    required this.unitName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.horizontal(right: Radius.circular(25.0))),
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height / 6,
              width: double.infinity,
              child: Center(
                child: Text(
                  'PPC Media',
                  style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text("Sign out"),
              leading: const Icon(
                Icons.exit_to_app_rounded,
                color: Colors.black,
              ),
              onTap: () {
                signOutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        await FirebaseAuth.instance.signOut().then((value) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (route) => false)
            });
      }
    } catch (e) {
      print(e);
    }
  }

  void signOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign out?"),
            content: const Text(
                "You can always access you contents by signing back in"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  signOut(context);
                },
                child: Text(
                  "Sign out",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        });
  }
}
