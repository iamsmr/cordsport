import 'package:flutter/material.dart';

import 'package:codespot/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;
  const BottomNavBar({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      currentIndex: items.keys.toList().indexOf(selectedItem),
      showUnselectedLabels: false,
      selectedItemColor: const Color(0xffFBD737),
      items: items
          .map(
            (item, icon) => MapEntry(
              item.toString(),
              BottomNavigationBarItem(icon: Icon(icon), label: ""),
            ),
          )
          .values
          .toList(),
    );
  }
}
