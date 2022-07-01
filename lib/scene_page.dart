import 'package:flutter/material.dart';

import 'control_widget.dart';
import 'scene/scene_home_page.dart';

class ScenePage extends StatefulWidget {
  final bool adjustUp;
  final bool adjustDown;
  final bool adjustLeft;
  final bool adjustRight;
  final String unitName;
  final bool startStreaming;
  final bool stopStreaming;
  final bool startRecording;
  final bool stopRecording;
  final bool cameraTNA;
  final bool controlTNA;
  final String docId;

  const ScenePage(
      {Key? key,
      required this.adjustUp,
      required this.adjustDown,
      required this.adjustLeft,
      required this.adjustRight,
      required this.unitName,
      required this.startStreaming,
      required this.stopStreaming,
      required this.startRecording,
      required this.stopRecording,
      required this.cameraTNA,
      required this.controlTNA,
      required this.docId})
      : super(key: key);

  @override
  _ScenePageState createState() => _ScenePageState();
}

class _ScenePageState extends State<ScenePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.unitName,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {},
        child: ControlWidget(
          adjustUp: widget.adjustUp,
          adjustDown: widget.adjustDown,
          adjustLeft: widget.adjustLeft,
          adjustRight: widget.adjustRight,
          startStreaming: widget.startStreaming,
          stopStreaming: widget.stopStreaming,
          startRecording: widget.startRecording,
          stopRecording: widget.stopRecording,
          cameraTNA: widget.cameraTNA,
          controlTNA: widget.controlTNA,
          docId: widget.docId,
        ),
      ),
    );
  }
}
