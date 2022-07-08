import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ButtonIcon extends StatefulWidget {
  final String title;
  final IconData icons;
  final bool isIcon;
  final bool isStraightLine;
  final String dblabel;
  final String docId;
  final dynamic dbValue;
  final String url;

  const ButtonIcon({
    super.key,
    required this.title,
    this.icons = Icons.radio_button_on_rounded,
    required this.isIcon,
    this.isStraightLine = false,
    required this.dblabel,
    required this.docId,
    required this.dbValue,
    required this.url,
  });

  @override
  State<ButtonIcon> createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> {
  bool _button = false;

  void getValue() {
    if (_button != widget.dbValue) {
      Vibrate.vibrate();
    }
    setState(() {
      _button = widget.dbValue;
    });
  }

  Timer? timer;

  @override
  void initState() {
    getValue();
    timer = Timer.periodic(
        const Duration(milliseconds: 50), (Timer t) => getValue());

    super.initState();
  }

  void _toggleButton() {
    setState(() {
      _button = !_button;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _toggleButton();
        _toggleDB();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 80,
          width: widget.isStraightLine == true ? double.infinity : 150,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.dbValue ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isIcon == true
                  ? Icon(
                      widget.icons,
                      color: Colors.white,
                    )
                  : const Text(""),
              Flexible(
                child: Text(
                  widget.title,
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleDB() async {
    final url = Uri.parse(widget.url);
    http.patch(url,
        body: json.encode({
          widget.dblabel: _button,
        }));
  }
}
