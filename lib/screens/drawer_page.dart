import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'on_boarding/user_profile.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key, this.userProfilePic});

  final String? userProfilePic;

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  String? userId;
  String userName = "";
  String userEmail = "";
  String? userProfilePic;

  late FirebaseFirestore fireStore;

  @override
  void initState() {
    super.initState();
    fireStore = FirebaseFirestore.instance;

    getUidFromPrefs();
    getProfilePic();
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Note App",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
              const Divider(color: Colors.black),
              ListTile(
                leading: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                                profilePicUrl: widget.userProfilePic ?? "")));
                  },
                  child: widget.userProfilePic != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            widget.userProfilePic!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                ),
                title: Text(
                  userName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                subtitle: Text(
                  userEmail,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
              const Divider(indent: 80),
              iconTextButton(
                onTap: () {
                  Navigator.pop(context);
                },
                icon: Icons.lightbulb_outline,
                name: "Notes",
              ),
              iconTextButton(
                onTap: () {},
                icon: Icons.add_alert_rounded,
                name: "Reminders",
              ),
              const Divider(indent: 45),
              iconTextButton(
                onTap: () {},
                icon: Icons.settings,
                name: "Settings",
              ),
              iconTextButton(
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Logout?"),
                          content: const Text("Are sure want to logout ?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                var pref =
                                    await SharedPreferences.getInstance();
                                pref.setString(LoginScreen.LOGIN_PREFS_KEY, "");

                                await FirebaseAuth.instance.signOut();

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const LoginScreen()));
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: Icons.logout,
                name: "Logout",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconTextButton(
      {required VoidCallback onTap,
      required IconData icon,
      required String name}) {
    return TextButton.icon(
      onPressed: onTap,
      label: Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
      ),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
