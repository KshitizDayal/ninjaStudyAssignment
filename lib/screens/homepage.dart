import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ninja_study/resources/auth_methods.dart';
import 'package:ninja_study/screens/history.dart';
import 'package:ninja_study/screens/login_screen.dart';
import 'package:ninja_study/screens/random.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logOut() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _page = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTaped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> homeScreenItems = [
    const RandomTalk(),
    const History(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_auth.currentUser!.displayName as String),
        actions: [
          IconButton(
            onPressed: logOut,
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: _page == 0 ? Colors.purpleAccent : Colors.black,
            ),
            label: 'Start Chating',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: _page == 1 ? Colors.purpleAccent : Colors.black,
            ),
            label: 'Chat History',
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTaped,
      ),
    );
  }
}
