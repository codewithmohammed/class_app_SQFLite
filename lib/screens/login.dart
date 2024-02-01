import 'package:classapp/screens/logup.dart';
import 'package:classapp/screens/profilepic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDataMatched = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/school.png',
                    height: 200,
                  ),
                  const SizedBox(
                    child: Text(
                      'Sign in as Teacher',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    width: 300,
                    child: Text(
                      'Please confirm your Email adress and enter your password.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(66, 51, 143, 236),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(224, 2, 53, 105),
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.fromLTRB(4, 1, 0, 0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 93, 91, 91))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: Color.fromARGB(224, 2, 53, 105),
                        )),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 255, 0, 0))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 255, 0, 0)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please Enter the correct Email';
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
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(66, 51, 143, 236),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(224, 2, 53, 105),
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.fromLTRB(4, 1, 0, 0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 93, 91, 91))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: Color.fromARGB(224, 2, 53, 105),
                        )),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(224, 236, 51, 51))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(224, 236, 51, 51)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please Enter the correct Password';
                      }
                      if (value.length < 7) {
                        return 'should include minimum 8 characters ';
                      }
                      return null;
                    },
                  ),
                  Container(
                    alignment: const Alignment(0.9, 0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push((context),
                              MaterialPageRoute(builder: (ctx) {
                            return const LogupScreen();
                          }));
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  Visibility(
                    visible: !_isDataMatched,
                    child: const Text(
                      'Username and Password is not Matched.',
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          backgroundColor: Color.fromARGB(171, 255, 0, 0)),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          checkSignin(context);
                        } else {}
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(224, 2, 53, 105),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkSignin(BuildContext ctx) async {
    final logupsharedPrefs = await SharedPreferences.getInstance();
    final enteredusername = _usernameController.text;
    final enteredpassword = _passwordController.text;
    final savedusername = logupsharedPrefs.getString('saved_username');
    final savedpassword = logupsharedPrefs.getString('saved_password');
    if (enteredusername == savedusername && enteredpassword == savedpassword) {
      // print('PAss is matched');
      Navigator.of(ctx)
          .push(MaterialPageRoute(builder: (context) => const ProfilePic()));
    } else {
      // print('PAss not matched');
      setState(() {
        _isDataMatched = false;
      });
    }
  }
}
