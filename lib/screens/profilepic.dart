import 'dart:io';
import 'package:classapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  bool imageUploaded = false;
  File? selectedImage;
  List<Map<String, dynamic>> profilePic = [];
  String? _imagepath;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // void refreshProfile() async {
  //   final image = await DPLHelper.getprofilePic();
  //   setState(() {
  //     profilePic = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Center(
            child: Text(
              'Upload Your Profile Picture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Stack(
              children: [
                Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1))
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: _imagepath != null
                        ? ClipOval(child: Image.file(selectedImage!))
                        : Container(
                            child: selectedImage != null
                                ? ClipOval(child: Image.file(selectedImage!))
                                : const Center(
                                    child: Text('Upload an Image'),
                                  ))),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.blue),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (builder) => bottomSheet());
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              )),
                        )))
              ],
            ),
          ),
          Visibility(
              visible: imageUploaded,
              child: const Text('Please Upload an Image to Continue')),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedImage != null) {
                    // updateProfile();
                    toHomeScreen(selectedImage!.path);
                  } else {
                    setState(() {
                      imageUploaded = true;
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text(
                  'Save Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  // Future<void> updateProfile() async {
  //   if (profilePic[0]['image'] != null) {
  //     await DPLHelper.updateProfile(
  //       0,
  //       await selectedImage!.readAsBytes(),
  //     );
  //     refreshProfile();
  //   } else {
  //     await DPLHelper.saveImage(
  //       await selectedImage!.readAsBytes(),
  //     );
  //     refreshProfile();
  //   }
  // }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            'Choose Profile Photo',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    selectImageFromCamera();
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera')),
              ElevatedButton.icon(
                  onPressed: () {
                    selectImageFromGallery();
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'))
            ],
          )
        ],
      ),
    );
  }

  Future selectImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(returnedImage!.path);
      imageUploaded = false;
    });
  }

  Future selectImageFromCamera() async {
    final returnedcamera =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(returnedcamera!.path);
      imageUploaded = false;
    });
  }

  void loadProfile() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = sharedPrefs.getString('imagepath');
      if (_imagepath != null) {
        setState(() {
          selectedImage = File(_imagepath!);
        });
      }
    });
  }

  void toHomeScreen(path) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('SAVE_KEY_LOGIN', 'true');
    await sharedPrefs.setString('imagepath', path);
    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (ctx) {
      return HomeScreen(selectedImage: selectedImage);
    }), (route) => false);
  }
}
