import 'package:classapp/screens/home_screen.dart';
import 'package:classapp/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(1, 255, 255, 255)),
      body: SafeArea(
          child: Center(
        child: Image.asset(
          'assets/images/school.png',
          height: 150,
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPrefs.getString('SAVE_KEY_LOGIN');
    if (userLoggedIn == 'false') {
      loginwait();
    } else {
      await sharedPrefs.setString('SAVE_KEY_LOGIN', 'true');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    }
  }

  Future<void> loginwait() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement((context), MaterialPageRoute(builder: (ctx) {
      return const LoginScreen();
    }));
  }
}
