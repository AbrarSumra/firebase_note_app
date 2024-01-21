import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../widget_constant/custom_textfield.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({
    super.key,
    required this.userId,
    this.title = "",
    this.desc = "",
    this.docId = "",
    this.isUpdate = false,
  });
  final bool isUpdate;
  final String title;
  final String desc;
  final String docId;
  final String userId;

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.title;
    descController.text = widget.desc;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    NoteTextField(
                      label: "Enter title",
                      controller: titleController,
                    ),
                    NoteTextField(
                      label: "Enter description",
                      controller: descController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty &&
                                descController.text.isNotEmpty) {
                              var collRef = fireStore.collection("users");

                              if (widget.isUpdate) {
                                /// For Update Note
                                collRef
                                    .doc(widget.userId)
                                    .collection("notes")
                                    .doc(widget.docId)
                                    .update(NoteModel(
                                      title: titleController.text.toString(),
                                      desc: descController.text.toString(),
                                      time: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                    ).toMap());
                              } else {
                                /// For Add New Note

                                collRef
                                    .doc(widget.userId)
                                    .collection("notes")
                                    .add(NoteModel(
                                      title: titleController.text.toString(),
                                      desc: descController.text.toString(),
                                      time: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                    ).toMap());
                              }
                              titleController.clear();
                              descController.clear();
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: Text(
                            widget.isUpdate ? "Update" : "Add",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
