import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stream_team_assistance/auth/welcome_page.dart';
import 'package:stream_team_assistance/scene/scene_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streaming Team Assistance',
      theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: AppBarTheme(
            color: Colors.black,
            elevation: 0,
            titleTextStyle: GoogleFonts.workSans(),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
          )),
      // home: const WelcomePage(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ChooseScene();
            } else {
              return const WelcomePage();
            }
          }),
    );
  }
}
