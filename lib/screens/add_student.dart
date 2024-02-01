import 'dart:io';
import 'dart:typed_data';
import 'package:classapp/database/db_helper.dart';
import 'package:classapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  final int? id;
  const AddScreen({super.key, this.id});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  File? selectedImage;
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> studentsImages = [];

  final _nameKey = GlobalKey<FormState>();
  final _ageKey = GlobalKey<FormState>();
  final _classKey = GlobalKey<FormState>();
  final _divisionKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _phonenumKey = GlobalKey<FormState>();
  final _locationKey = GlobalKey<FormState>();


  late  Uint8List image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _divisionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenumController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshStudents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshStudents();
  }

  void refreshStudents() async {
    final data = await SQLHelper.getItems();
    setState(() {
      students = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      final existingStudent =
          students.firstWhere((element) => element['id'] == widget.id);
       image = existingStudent['data'];
      _nameController.text = existingStudent['name'];
      _ageController.text = existingStudent['age'];
      _classController.text = existingStudent['classroom'];
      _divisionController.text = existingStudent['div'];
      _emailController.text = existingStudent['email'];
      _phonenumController.text = existingStudent['phonenum'];
      _locationController.text = existingStudent['location'];
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.id == null
            ? const Text('Add Student')
            : const Text('Update Student'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 15, top: 0, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
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
                            shape: BoxShape.circle),
                        child: selectedImage != null
                            ? ClipOval(child: Image.file(selectedImage!))
                            : (widget.id != null
                                ? ClipOval(
                                    child: Image.memory(
                                       image))
                                // const Center(
                                //     child: Text(
                                //     'Update the existing Image?',
                                //     textAlign: TextAlign.center,
                                //   ))
                                : const Center(child: Text('Upload an Image'))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: Colors.blue),
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
                const SizedBox(
                  height: 30,
                ),
                buildTextFormField("Full Name", "Enter your Full Name",
                    _nameController, _nameKey, validateName, 100),
                buildTextFormField("Age", "Enter your age in numbers",
                    _ageController, _ageKey, validateAge, 100),
                buildTextFormField("Class", "Class in number", _classController,
                    _classKey, validateClass, 100),
                buildTextFormField("Division", "Division in letter",
                    _divisionController, _divisionKey, validateDivision, 10),
                buildTextFormField("Email", "Email in format", _emailController,
                    _emailKey, validateEmail, 10),
                buildTextFormField("Phone number", "Phone number",
                    _phonenumController, _phonenumKey, validatePhonenum, 10),
                buildTextFormField("Location", "Location", _locationController,
                    _locationKey, validateLocation, 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameKey.currentState!.validate() &&
                            _ageKey.currentState!.validate() &&
                            _classKey.currentState!.validate() &&
                            _divisionKey.currentState!.validate() &&
                            _emailKey.currentState!.validate() &&
                            _phonenumKey.currentState!.validate() &&
                            _locationKey.currentState!.validate() &&
                            selectedImage != null &&
                            widget.id == null) {
                          // saveImage();
                          addStudent();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (ctx) {
                            return const HomeScreen();
                          }), (route) => false);
                        } else if (_nameKey.currentState!.validate() &&
                            _ageKey.currentState!.validate() &&
                            _classKey.currentState!.validate() &&
                            _divisionKey.currentState!.validate() &&
                            _emailKey.currentState!.validate() &&
                            _phonenumKey.currentState!.validate() &&
                            _locationKey.currentState!.validate() &&
                            widget.id != null) {
                          showAlertBox(context);
                        } else if (selectedImage == null) {}
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        widget.id == null ? "SAVE" : "UPDATE",
                        style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addStudent() async {
    await SQLHelper.createItems(
        await selectedImage!.readAsBytes(),
        _nameController.text,
        _ageController.text,
        _classController.text,
        _divisionController.text,
        _emailController.text,
        _phonenumController.text,
        _locationController.text);
    refreshStudents();
  }

  Future<void> updateStudent(int id) async {
    await SQLHelper.updateItem(
        id,
        //await selectedImage!.readAsBytes(),
        _nameController.text,
        _ageController.text,
        _classController.text,
        _divisionController.text,
        _emailController.text,
        _phonenumController.text,
        _locationController.text);
    refreshStudents();
  }

  Future<void> updateImage(int id) async {
    await SQLHelper.updateImageData(
      id,
      await selectedImage!.readAsBytes(),
    );
    refreshStudents();
  }

  // saveImage() async {
  //   final imageBytes = await selectedImage!.readAsBytes();
  //   final imageId = await SQLHelper.saveImage(imageBytes);
  //   refreshStudents();
  // }

  // Future<void> updateImage(int id) async {
  //   final imagebytes = await selectedImage!.readAsBytes();
  //   await SQLHelper.updateImage(id, imagebytes);
  //   refreshStudents();
  // }

  Widget buildTextFormField(
    String labelText,
    String placeholder,
    TextEditingController controllers,
    GlobalKey<FormState> formKey,
    String? Function(String?) validatorFunction,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Form(
            key: formKey,
            child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validatorFunction,
                controller: controllers,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 10,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(5)),
                    contentPadding: const EdgeInsets.only(bottom: 5, left: 8),
                    labelText: labelText,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
          )),
    );
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter your Name';
    } else if (!RegExp(r'^[A-Za-z\s\-]+$').hasMatch(value)) {
      return 'Please Enter Your Correct Name';
    } else {
      return null;
    }
  }

  String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty || value.length > 2) {
      return 'Please Enter your Age';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please Enter Your Correct Age';
    } else {
      return null;
    }
  }

  String? validateClass(String? value) {
    if (value == null || value.trim().isEmpty || value.length > 2) {
      return 'Please Enter your Class';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please Enter Your Correct Class';
    } else {
      return null;
    }
  }

  String? validateDivision(String? value) {
    if (value == null || value.trim().isEmpty || value.length > 1) {
      return 'Please Enter your Class Division(Alphabetic)';
    } else if (!RegExp(r'^[A-Z\s\-]+$').hasMatch(value)) {
      return 'Please Enter Your Correct Division(Must be in Capital Letters)';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'can\'t be empty';
    }
    if (value.length < 4) {
      return 'Too short';
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return ' Please enter a valid email';
    }
    return null;
  }

  String? validatePhonenum(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'phone number can\'t be empty';
    }
    if (value.length < 10) {
      return 'only 10 digits.';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return ' Please enter a valid phone number';
    }
    return null;
  }

  String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location can\'t be empty';
    }
    return null;
  }

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
    });
  }

  selectImageFromCamera() async {
    final returnedcamera =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(returnedcamera!.path);
    });
  }

  void showAlertBox(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Student'),
          content: const SingleChildScrollView(
              child: SizedBox(
                  height: 30,
                  child: Text(
                    'Do you want to Update Data',
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
                updateImage(widget.id!);
                updateStudent(widget.id!);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (ctx) {
                  return const HomeScreen();
                }), (route) => false);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
