import 'dart:io';
import 'package:classapp/database/db_helper.dart';
import 'package:classapp/screens/add_student.dart';
import 'package:classapp/screens/login.dart';
import 'package:classapp/screens/profilepic.dart';
import 'package:classapp/screens/student_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final File? selectedImage;
  const HomeScreen({super.key, this.selectedImage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<Uint8List?> _getImageData() async {
  // final List<Map<String, dynamic>> result = await DPLHelper.getprofilePic();

  //   if (result.isNotEmpty) {
  //     final imageData = result[0]['image'] as Uint8List?;
  //     return imageData;
  //   }

  //   return null;
  // }

  // List<Map<String, dynamic>> profilePic = [];
  String? _imagepath;

  @override
  void initState() {
    super.initState();
    refreshProfile();
  }

  void refreshProfile() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = sharedPrefs.getString('imagepath');
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _getImageData();
  // }

  // void refreshProfile() async {
  //   final data = await DPLHelper.getprofilePic();
  //   setState(() {
  //     profilePic = data;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        leading: SizedBox(
          height: 200,
          child: PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            color: Colors.white,
            position: PopupMenuPosition.under,
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                  height: 40,
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text('Settings'),
                      ),
                    ],
                  )),
              PopupMenuItem(
                  height: 40,
                  child: Row(
                    children: [
                      const Icon(Icons.dark_mode_outlined),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text('Dark Mode'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Transform.scale(
                          scale: 0.7,
                        ),
                      )
                    ],
                  )),
              PopupMenuItem(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (ctx) {
                      return const ProfilePic();
                    }));
                  },
                  height: 40,
                  child: const Row(
                    children: [
                      Icon(Icons.person),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text('Change Profile Pic'),
                      ),
                    ],
                  )),
              PopupMenuItem(
                  onTap: () {
                    SQLHelper.deleteAll();
                    showAlertBox(context);
                  },
                  height: 40,
                  child: const Row(
                    children: [
                      Icon(Icons.send_to_mobile),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text('Sign Out'),
                      ),
                    ],
                  )),
            ],
            child: const Icon(Icons.menu),
          ),
        ),
        title: const Text('Class'),
        actions: [
          if (_imagepath != null)
            InkWell(
              onTap: () {},
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(child: Image.file(File(_imagepath!))),
              ),
            )
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(100.0),
                        ),
                        elevation: MaterialStateProperty.all<double?>(10.0),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const listScreen();
                        }));
                      },
                      icon: const Icon(Icons.list_alt_outlined),
                      label: const Text('View All Student'),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(100.0),
                  ),
                  elevation: MaterialStateProperty.all<double?>(10.0),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx1) {
                    return const AddScreen();
                  }));
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Add Student'))
          ],
        ),
      )),
    );
  }

  void showAlertBox(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const SingleChildScrollView(
              child: SizedBox(
                  height: 30,
                  child: Text(
                    'Do you want to Sign Out',
                    style: TextStyle(fontSize: 15),
                  ))),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                signOut(ctx);
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  signOut(BuildContext ctx) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('SAVE_KEY_LOGIN', 'false');
    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const LoginScreen()),
        (route) => false);
  }
}
