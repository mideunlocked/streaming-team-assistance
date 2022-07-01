import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:stream_team_assistance/auth/welcome_page.dart';
import 'package:stream_team_assistance/scene_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_drawer.dart';

class ChooseScene extends StatefulWidget {
  const ChooseScene({super.key});

  @override
  State<ChooseScene> createState() => _ChooseSceneState();
}

class _ChooseSceneState extends State<ChooseScene> {
  final _unitNameController = TextEditingController();

  static String? currentUid = FirebaseAuth.instance.currentUser?.uid;
  final Stream<QuerySnapshot<Map<String, dynamic>>> _units = FirebaseFirestore
      .instance
      .collection('/teams/$currentUid/units')
      .snapshots();
  CollectionReference teams = FirebaseFirestore.instance.collection("teams");

  @override
  void dispose() {
    _unitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change scene",
          style: GoogleFonts.workSans(),
        ),
      ),
      drawer: FutureBuilder<DocumentSnapshot>(
          future: teams.doc(currentUid).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            Map<String, dynamic>? teamData = snapshot.data?.data() as dynamic;
            return CustomDrawer(unitName: teamData?["teamName"] ?? "");
          }),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: _units,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: snapshot.data?.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScenePage(
                                adjustUp: data["adjustUp"] ?? false,
                                adjustDown: data["adjustDown"] ?? false,
                                adjustLeft: data["adjustLeft"] ?? false,
                                adjustRight: data["adjustRight"] ?? false,
                                unitName: data["unitName"] ?? "",
                                startStreaming: data['startStreaming'] ?? false,
                                stopStreaming: data['stopStreaming'] ?? false,
                                startRecording: data['startRecording'] ?? false,
                                stopRecording: data['stopRecording'] ?? false,
                                cameraTNA: data['cameraTNA'] ?? false,
                                controlTNA: data['controlTNA'] ?? false,
                                docId: data['docId'] ?? "",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              data["unitName"],
                              style: GoogleFonts.workSans(),
                            ),
                          ),
                        ),
                      );
                    }).toList() ??
                    [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent[400],
                        ),
                      )
                    ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showBottomSheet,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.grey,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Enter unit name',
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                            textSelectionTheme: const TextSelectionThemeData(
                              selectionColor: Color.fromARGB(255, 30, 64, 47),
                            ),
                          ),
                          child: TextField(
                            autofocus: true,
                            controller: _unitNameController,
                            cursorColor: Theme.of(context).primaryColor,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.greenAccent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.greenAccent),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                addUnit(
                                  _unitNameController.text.trim(),
                                );
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<void> addUnit(String unitName) async {
    String docId = "";
    var currentUid = FirebaseAuth.instance.currentUser?.uid;
    CollectionReference teams =
        FirebaseFirestore.instance.collection("/teams/$currentUid/units");

    DocumentReference docRef = await teams.add({
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
      "unitName": unitName,
    });

    setState(() {
      docId = docRef.id;
    });
    await teams.doc(docId).update({
      'docId': docId,
    });
  }
}
