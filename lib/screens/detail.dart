import 'package:classapp/database/db_helper.dart';
import 'package:classapp/screens/add_student.dart';
import 'package:classapp/screens/home_screen.dart';

import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> detailStudents;
  const DetailScreen({super.key, required this.detailStudents});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Details'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
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
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.memory(
                              widget.detailStudents['data'],
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Name',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Age',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['age'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Class',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['classroom'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Division',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['div'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Email',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['email'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Phone Number',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['phonenum'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Text(
                        'Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      title: Text(
                        widget.detailStudents['location'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          showAlertBox(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return AddScreen(
                              id: widget.detailStudents['id'],
                            );
                          }));
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteStudent(int id) async {
    await SQLHelper.deleteItem(id);
  }

  void showAlertBox(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const SingleChildScrollView(
              child: SizedBox(
                  height: 30,
                  child: Text(
                    'Do you want to Delete',
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
              onPressed: () async {
                await deleteStudent(widget.detailStudents['id']);
                Navigator.of(context).pop();
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
