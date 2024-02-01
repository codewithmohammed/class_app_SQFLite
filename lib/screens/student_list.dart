import 'package:classapp/database/db_helper.dart';
import 'package:classapp/screens/add_student.dart';
import 'package:classapp/screens/detail.dart';
import 'package:flutter/material.dart';

class listScreen extends StatefulWidget {
  const listScreen({super.key});

  @override
  State<listScreen> createState() => _listScreenState();
}

class _listScreenState extends State<listScreen> {
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> _foundStudents = [];
  @override
  void initState() {
    super.initState();
    refreshStudents();
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.trim().isEmpty) {
      results = students;
    } else {
      results = students
          .where((student) => student['name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundStudents = results;
    });
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
      _foundStudents = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              onChanged: (value) => runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //  Image.memory(imageWidgets[index]['data']),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  color: const Color.fromARGB(224, 2, 53, 105),
                  margin: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return DetailScreen(
                          detailStudents: _foundStudents[index],
                        );
                      }));
                    },
                    child: ListTile(
                      leading: ClipOval(
                          child: Image.memory(
                        _foundStudents[index]['data'],
                        height: 45,
                      )),
                      title: Text(
                        _foundStudents[index]['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  showAlertBox(context, index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (ctx) {
                                  return AddScreen(
                                    id: _foundStudents[index]['id'],
                                  );
                                }));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _foundStudents.length,
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
            return const AddScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteStudent(int id) async {
    await SQLHelper.deleteItem(id);
    refreshStudents();
  }

  void showAlertBox(BuildContext ctx, int index) {
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
                await deleteStudent(_foundStudents[index]['id']);
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
