import 'package:codespot/blocs/blocs.dart';
import 'package:codespot/enums/enums.dart';
import 'package:codespot/screens/home/navigation/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavScreen extends StatelessWidget {
  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.home: Icons.home_rounded,
    BottomNavItem.chat: Icons.chat_rounded,
    BottomNavItem.profile: Icons.person_rounded,
  };
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.notes_rounded),
          ),
          title: const Text(
            "CORDSPOT",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          items: items,
          onTap: (index) {},
          selectedItem: BottomNavItem.home,
        ),
      ),
    );
  }
}
