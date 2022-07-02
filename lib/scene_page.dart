import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'control_widget.dart';
import 'scene/scene_home_page.dart';

class ScenePage extends StatefulWidget {
  // final bool adjustUp;
  // final bool adjustDown;
  // final bool adjustLeft;
  // final bool adjustRight;
  final String unitName;
  final String unitUrl;
  // final bool startStreaming;
  // final bool stopStreaming;
  // final bool startRecording;
  // final bool stopRecording;
  // final bool cameraTNA;
  // final bool controlTNA;
  final String docId;

  const ScenePage({
    Key? key,
    required this.unitName,
    required this.docId,
    required this.unitUrl,
  }) : super(key: key);

  @override
  _ScenePageState createState() => _ScenePageState();
}

class _ScenePageState extends State<ScenePage> {
  Map<String, dynamic> unitScreenData = {};
  String? currentUid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> fetchAndSetValues() async {
    final url = widget.unitUrl;
    final urlParse = Uri.parse(
        "https://streaming-team-assistance-default-rtdb.firebaseio.com/teams/$currentUid/${widget.unitUrl}.json");

    try {
      final response = await http.get(urlParse);
      final extractedValue = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        unitScreenData = extractedValue;
      });
    } catch (error) {
      rethrow;
    }
  }

  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(milliseconds: 50), (Timer t) => fetchAndSetValues());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var url =
        "https://streaming-team-assistance-default-rtdb.firebaseio.com/teams/$currentUid/${widget.unitUrl}.json";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.unitName,
        ),
      ),
      body: Padding(
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
                url: url,
                dbValue: unitScreenData["adjustUp"] ?? true,
              ),
              Row(
                children: <Widget>[
                  ButtonIcon(
                    title: "Adjust left",
                    icons: Icons.arrow_left_rounded,
                    isIcon: true,
                    dblabel: "adjustLeft",
                    docId: widget.docId,
                    url: url,
                    dbValue: unitScreenData["adjustLeft"] ?? true,
                  ),
                  const Spacer(),
                  ButtonIcon(
                    title: "Adjust right",
                    icons: Icons.arrow_right_rounded,
                    isIcon: true,
                    dblabel: "adjustRight",
                    docId: widget.docId,
                    url: url,
                    dbValue: unitScreenData["adjustRight"] ?? true,
                  ),
                ],
              ),
              ButtonIcon(
                title: "Adjust down",
                icons: Icons.arrow_downward_rounded,
                isIcon: true,
                dblabel: "adjustDown",
                docId: widget.docId,
                url: url,
                dbValue: unitScreenData["adjustDown"] ?? true,
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
                    url: url,
                    dbValue: unitScreenData["startStreaming"] ?? true,
                  ),
                  const Spacer(),
                  ButtonIcon(
                    title: "Stop streaming",
                    isIcon: false,
                    dblabel: "stopStreaming",
                    docId: widget.docId,
                    url: url,
                    dbValue: unitScreenData["stopStreaming"] ?? true,
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
                    url: url,
                    dbValue: unitScreenData["startRecording"] ?? true,
                  ),
                  const Spacer(),
                  ButtonIcon(
                    title: "Stop recording",
                    isIcon: false,
                    dblabel: "stopRecording",
                    docId: widget.docId,
                    url: url,
                    dbValue: unitScreenData["stopRecording"] ?? true,
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
                url: url,
                dbValue: unitScreenData["cameraTNA"] ?? true,
              ),
              const SizedBox(height: 20),
              ButtonIcon(
                title: "Control team needs assistance",
                isIcon: false,
                isStraightLine: true,
                dblabel: "controlTNA",
                docId: widget.docId,
                url: url,
                dbValue: unitScreenData["controlTNA"] ?? true,
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
