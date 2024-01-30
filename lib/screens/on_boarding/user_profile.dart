import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_firebase/widget_constant/button.dart';

import '../login_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.profilePicUrl});

  final String? profilePicUrl;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  CroppedFile? croppedImg;
  String? userId;
  FirebaseFirestore? fireStore;

  @override
  void initState() {
    super.initState();
    fireStore = FirebaseFirestore.instance;
    getUserId();
  }

  void getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LoginScreen.LOGIN_PREFS_KEY)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              croppedImg != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        File(croppedImg!.path),
                        height: 100,
                        width: 100,
                      ),
                    )
                  : widget.profilePicUrl != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            widget.profilePicUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Icon(
                          CupertinoIcons.profile_circled,
                          size: 100,
                        ),
              const SizedBox(height: 21),
              CustomButton(
                label: "Choose image",
                onTap: () {
                  openImagePicker();
                },
              ),
              const SizedBox(height: 21),
              croppedImg != null
                  ? CustomButton(
                      label: "Upload image",
                      onTap: () {
                        uploadImage();
                      },
                    )
                  : const Text("Select an image to Upload"),
              const SizedBox(height: 11),
              const SizedBox(height: 11),
              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: fireStore!
                    .collection("users")
                    .doc(userId)
                    .collection("profilePics")
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (_, index) {
                          var eachImage =
                              snapshot.data!.docs[index].data()["image"];
                          return Image.network(eachImage);
                        });
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void openImagePicker() async {
    var pickedImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImg != null) {
      croppedImg = await ImageCropper().cropImage(
        sourcePath: pickedImg.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      setState(() {});
    }
  }

  void uploadImage() async {
    var currTime = DateTime.now().millisecondsSinceEpoch;

    var storage = FirebaseStorage.instance;

    var storageRef = storage.ref().child("image/profilePicture/IMG_$currTime");

    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString(LoginScreen.LOGIN_PREFS_KEY);

    try {
      storageRef.putFile(File(croppedImg!.path)).then((value) async {
        /// Creating Image Url
        var imgUrl = await value.ref.getDownloadURL();

        /// When uploading is completed
        var fireStore = FirebaseFirestore.instance;

        /// Update Current Profile pic
        fireStore
            .collection("users")
            .doc(userId)
            .update({"profilePic": imgUrl});

        /// Adding Profile url in Collection
        fireStore
            .collection("users")
            .doc(userId)
            .collection("profilePics")
            .add({
          "image": imgUrl,
          "uploadedAt": currTime,
        });
      });
    } on FirebaseException catch (e) {
      print("Error: $e");
    }
    setState(() {});

    Navigator.pop(context);
  }
}
