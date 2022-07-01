import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlWidget extends StatefulWidget {
  final bool adjustUp;
  final bool adjustDown;
  final bool adjustLeft;
  final bool adjustRight;
  final bool startStreaming;
  final bool stopStreaming;
  final bool startRecording;
  final bool stopRecording;
  final bool cameraTNA;
  final bool controlTNA;
  final String docId;

  const ControlWidget({
    Key? key,
    required this.adjustUp,
    required this.adjustDown,
    required this.adjustLeft,
    required this.adjustRight,
    required this.startStreaming,
    required this.stopStreaming,
    required this.startRecording,
    required this.stopRecording,
    required this.cameraTNA,
    required this.controlTNA,
    required this.docId,
  }) : super(key: key);

  @override
  State<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  @override
  void initState() {
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (contex) => ControlWidget()),
    //       (Route<dynamic> route) => false);
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ButtonIcon(
              title: "Adjust up",
              icons: Icons.arrow_upward_rounded,
              isIcon: true,
              dblabel: "adjustUp",
              docId: widget.docId,
              dbValue: widget.adjustUp,
            ),
            Row(
              children: <Widget>[
                ButtonIcon(
                  title: "Adjust left",
                  icons: Icons.arrow_left_rounded,
                  isIcon: true,
                  dblabel: "adjustLeft",
                  docId: widget.docId,
                  dbValue: widget.adjustLeft,
                ),
                const Spacer(),
                ButtonIcon(
                  title: "Adjust right",
                  icons: Icons.arrow_right_rounded,
                  isIcon: true,
                  dblabel: "adjustRight",
                  docId: widget.docId,
                  dbValue: widget.adjustRight,
                ),
              ],
            ),
            ButtonIcon(
              title: "Adjust down",
              icons: Icons.arrow_downward_rounded,
              isIcon: true,
              dblabel: "adjustDown",
              docId: widget.docId,
              dbValue: widget.adjustDown,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ButtonIcon(
                  title: "Start streaming",
                  isIcon: false,
                  dblabel: "startStreaming",
                  docId: widget.docId,
                  dbValue: widget.startStreaming,
                ),
                const Spacer(),
                ButtonIcon(
                  title: "Stop streaming",
                  isIcon: false,
                  dblabel: "stopStreaming",
                  docId: widget.docId,
                  dbValue: widget.stopRecording,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ButtonIcon(
                  title: "Start recording",
                  isIcon: false,
                  dblabel: "startRecording",
                  docId: widget.docId,
                  dbValue: widget.startRecording,
                ),
                const Spacer(),
                ButtonIcon(
                  title: "Stop recording",
                  isIcon: false,
                  dblabel: "stopRecording",
                  docId: widget.docId,
                  dbValue: widget.stopRecording,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ButtonIcon(
              title: "Camera team needs assistance",
              isIcon: false,
              isStraightLine: true,
              dblabel: "cameraTNA",
              docId: widget.docId,
              dbValue: widget.cameraTNA,
            ),
            const SizedBox(height: 20),
            ButtonIcon(
              title: "Control team needs assistance",
              isIcon: false,
              isStraightLine: true,
              dblabel: "controlTNA",
              docId: widget.docId,
              dbValue: widget.controlTNA,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonIcon extends StatefulWidget {
  final String title;
  final IconData icons;
  final bool isIcon;
  final bool isStraightLine;
  final String dblabel;
  final String docId;
  final bool dbValue;

  const ButtonIcon({
    super.key,
    required this.title,
    this.icons = Icons.radio_button_on_rounded,
    required this.isIcon,
    this.isStraightLine = false,
    required this.dblabel,
    required this.docId,
    required this.dbValue,
  });

  @override
  State<ButtonIcon> createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> {
  bool _button = false;

  @override
  void initState() {
    bool value;
    setState(() {
      value = widget.dbValue;
      _button = value;
    });
    print(widget.docId);
    super.initState();
  }

  void _toggleButton() {
    setState(() {
      _button = !_button;
    });
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
            color: _button ? Colors.red : Colors.green,
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
    var currentUid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection("/teams/$currentUid/units/")
        .doc(widget.docId)
        .update({
      widget.dblabel: _button,
    });
    print("done");
  }
}
