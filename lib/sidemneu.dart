import 'package:flutter/material.dart';


class MySideMenuScreen extends StatefulWidget {
  @override
  _MySideMenuScreenState createState() => _MySideMenuScreenState();
}

class _MySideMenuScreenState extends State<MySideMenuScreen> {
  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SideMenu Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: toggleMenu, // Toggles the menu
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: toggleMenu,
              child: Text(isMenuOpen ? 'Close Menu' : 'Open Menu'),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            right: isMenuOpen ? 0 : -250, // Adjust width as per your menu size
            top: 0,
            bottom: 0,
            child: Container(
              width: 250,
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  'Ammer',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
