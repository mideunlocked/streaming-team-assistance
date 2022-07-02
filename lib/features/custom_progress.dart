import "package:flutter/material.dart";
import 'package:avatar_glow/avatar_glow.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvatarGlow(
        glowColor: Colors.black54,
        endRadius: 90.0,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: Material(
          elevation: 8.0,
          shape: const CircleBorder(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Image.asset(
                "assets/Minimal tech company logo.gif",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
