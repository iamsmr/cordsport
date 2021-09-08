import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/enums/enums.dart';
import 'package:codespot/screens/navigation/cubit/bottom_nav_bar_cubit.dart';
import 'package:codespot/screens/navigation/widget/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widget/tab-navigator.dart';

class NavScreen extends StatelessWidget {
  final Map<BottomNavItem, IconData> _items = const {
    BottomNavItem.home: Icons.home_rounded,
    BottomNavItem.chat: Icons.chat_rounded,
    BottomNavItem.profile: Icons.person_rounded,
  };
  static const String routeName = "/navscreen";
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => NavScreen(),
    );
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.home: GlobalKey<NavigatorState>(),
    BottomNavItem.chat: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>()
  };
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
          
            body: Stack(
              children: _items
                  .map((item, _) {
                    return MapEntry(
                      item,
                      _buildOffstageWidget(item, item == state.selctedItem),
                    );
                  })
                  .values
                  .toList(),
            ),
            bottomNavigationBar: !kIsWeb
                ? BottomNavBar(
                    items: _items,
                    selectedItem: state.selctedItem,
                    onTap: (int index) {
                      final selectedItem = _items.keys.toList()[index];
                      _selectBottomNavItem(
                        context,
                        selectedItem,
                        selectedItem == state.selctedItem,
                      );
                    },
                  )
                : null,
          );
        },
      ),
    );
  }

  _selectBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
    bool isSameItem,
  ) {
    if (isSameItem) {
      navigatorKeys[selectedItem]!
          .currentState
          ?.popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelctedItem(selectedItem);
  }

  Widget _buildOffstageWidget(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        item: currentItem,
        navigatorKey: navigatorKeys[currentItem]!,
      ),
    );
  }
}
