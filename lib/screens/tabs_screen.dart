import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/screens/add_edit_pet_screen.dart';
import 'package:pdoc/screens/home_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentTabIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      'Chats',
    ),
  ];

  Widget _getAppBarTitle(BuildContext ctx, int index) {
    final List<String> _appBarTitles = [
      L10n.of(ctx).home_screen_app_bar_text,
      L10n.of(ctx).chats_screen_app_bar_text,
    ];

    return Text(_appBarTitles.elementAt(index));
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getAppBarTitle(context, _currentTabIndex),
      ),
      body: Scrollbar(
        child: _widgetOptions.elementAt(_currentTabIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: L10n.of(context).tabs_screen_home_tab_text,
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: L10n.of(context).tabs_screen_chats_tab_text,
            icon: Icon(Icons.chat),
          ),
        ],
        currentIndex: _currentTabIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _currentTabIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddEditPetScreen.routeName);
        },
        child: Icon(Icons.add),
      ) : null,
    );
  }
}
