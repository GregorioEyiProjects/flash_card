import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onTabSelected;
  final int selectedIndex;
  const CustomNavigationBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  //Get the the index by default
  //var _selectedTab = SelectedTab.home;

  //Items for the bottom navigation bar (BottomNavigationBar)
  final items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
      backgroundColor: Colors.purple,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorite',
      backgroundColor: Colors.pink,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
      backgroundColor: Colors.blue,
    ),
  ];

  //SelectedTab.values.indexOf(_selectedTab),
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onTabSelected,
      items: items,
    );
  }
}
