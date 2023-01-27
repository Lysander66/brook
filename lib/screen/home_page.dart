import 'package:flutter/material.dart';

import 'screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _lastExitTime = DateTime.now();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >=
            const Duration(seconds: 1)) {
          const snack = SnackBar(
            content: Text('Press the back button again to exit the app'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepPurple.shade800,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
