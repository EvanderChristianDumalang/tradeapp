import 'package:flutter/material.dart';
import 'package:tradeapp/screens/page/home.dart';
import 'package:tradeapp/screens/page/transaction.dart';
import 'package:tradeapp/screens/page/user.dart';

// ignore: camel_case_types
class bottomNav extends StatefulWidget {
  const bottomNav({super.key});

  @override
  State<bottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<bottomNav> {
  int _selectedIndex = 0;
  final List<Widget> page = [
    const Home(),
    const Transaction(),
    const Users(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_add_sharp),
              label: 'Portfolio',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: 'User',
              backgroundColor: Colors.blue),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(index: _selectedIndex, children: page),
    );
  }
}
