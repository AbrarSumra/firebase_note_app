import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_firebase/models/note_model.dart';
import 'package:wscube_firebase/screens/drawer_page.dart';
import 'package:wscube_firebase/screens/login_page.dart';
import 'package:wscube_firebase/screens/on_boarding/user_profile.dart';
import 'package:wscube_firebase/widget_constant/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.userName = ""});
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? userId;
  String userName = "";
  String userEmail = "";
  String? userProfilePic;
  bool isSearching = false;

  late FirebaseFirestore fireStore;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> mData = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredData = [];

  @override
  void initState() {
    super.initState();
    fireStore = FirebaseFirestore.instance;
    mData;
    getUidFromPrefs();
    getProfilePic();
    setState(() {});
  }

  void getProfilePic() async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LoginScreen.LOGIN_PREFS_KEY)!;

    var user = await fireStore.collection("users").doc(userId).get();
    userProfilePic = user.data()!["profilePic"];
    setState(() {});
  }

  getUidFromPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LoginScreen.LOGIN_PREFS_KEY)!;
    var user = await fireStore.collection("users").doc(userId).get();
    userName = user.data()!["name"];
    userEmail = user.data()!["email"];
    setState(() {});
  }

  /// For Search
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filterNotes(
      String query, List<QueryDocumentSnapshot<Map<String, dynamic>>> notes) {
    if (query.isEmpty) {
      return notes;
    }
    return notes.where((note) {
      var data = note.data();
      var currNote = NoteModel.fromMap(data.cast<String, dynamic>());
      return currNote.title.toLowerCase().contains(query.toLowerCase()) ||
          currNote.desc.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: isSearching
            ? SizedBox(
                height: 40,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (query) {
                    setState(() {
                      filteredData = filterNotes(query, mData);
                    });
                  },
                ),
              )
            : const Text(
                "Firebase Note App",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
            setState(() {});
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                          profilePicUrl: userProfilePic ?? "")));
            },
            child: userProfilePic != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      userProfilePic!,
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
          ),
          SizedBox(width: 10),
        ],
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: fireStore
            .collection("users")
            .doc(userId)
            .collection("notes")
            .orderBy("time", descending: true)
            .get(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Note not loaded ${snapshot.hasError}"),
            );
          } else if (snapshot.hasData) {
            mData = snapshot.data!.docs;
            filteredData = filterNotes(searchController.text, mData);
            return filteredData.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (_, index) {
                      NoteModel currNote =
                          NoteModel.fromMap(filteredData[index].data());
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            currNote.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(currNote.desc),
                          /* subtitle: Text(DateFormat("dd-MM-yyyy").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(currNote.time)))),*/
                          trailing: Column(
                            children: [
                              PopupMenuButton(itemBuilder: (_) {
                                return [
                                  PopupMenuItem(
                                    child: const Text("Edit"),
                                    onTap: () {
                                      /// Update to Next Page
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NewNoteScreen(
                                              userId: userId!,
                                              isUpdate: true,
                                              title: currNote.title,
                                              desc: currNote.desc,
                                              docId: mData[index].id,
                                            ),
                                          ));*/
                                      /// Update to Bottom Sheet
                                      bottomSheet(
                                        isUpdate: true,
                                        title: currNote.title,
                                        desc: currNote.desc,
                                        docId: mData[index].id,
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text("Delete"),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Delete?"),
                                              content: const Text(
                                                  "Are you want to sure delete?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    fireStore
                                                        .collection("users")
                                                        .doc(userId)
                                                        .collection("notes")
                                                        .doc(mData[index].id)
                                                        .delete();
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No"),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                  )
                                ];
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No notes yet!!!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  );
          }
          return Container();
        },
      ),
      drawer: DrawerPage(userProfilePic: userProfilePic),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () async {
          bottomSheet();
          /* var newNote = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => NewNoteScreen(
                        userId: userId!,
                      )));
          if (newNote != null) {
            setState(() {});
          }*/
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 34,
        ),
      ),
    );
  }

  void bottomSheet({
    bool isUpdate = false,
    String title = "",
    String desc = "",
    String docId = "",
  }) {
    titleController.text = title;
    descController.text = desc;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
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
                          if (isUpdate) {
                            /// For Update Note
                            collRef
                                .doc(userId)
                                .collection("notes")
                                .doc(docId)
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
                                .doc(userId)
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
                        isUpdate ? "Update" : "Add",
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
          );
        });
  }
}
