import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/locator.dart';
import 'package:pdoc/services/analytics_service.dart';
import 'package:pdoc/ui/screens/tabs/settings_screen.dart';

import 'add_edit_pet_screen.dart';
import 'tabs/home_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/main-tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentTabIndex = 0;

  final FirebaseAnalyticsObserver observer = locator<AnalyticsService>().getAnalyticsObserver();

  void _sendCurrentTabToAnalytics() {
    observer.analytics.setCurrentScreen(
      screenName: '${TabsScreen.routeName}/$_currentTabIndex',
    );
  }

  @override
  void initState() {
    super.initState();
    _sendCurrentTabToAnalytics();
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // TODO: [FEATURE] Chat
    // Text(
    //   'Chats',
    // ),
    SettingsScreen(),
  ];

  Widget _getAppBarTitle(BuildContext ctx, int index) {
    final List<String> _appBarTitles = [
      L10n.of(ctx).home_screen_app_bar_text,
      // L10n.of(ctx).chats_screen_app_bar_text,
      L10n.of(ctx).settings_screen_app_bar_text,
    ];

    return Text(_appBarTitles.elementAt(index));
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    _sendCurrentTabToAnalytics();
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
          // TODO: [FEATURE] Chat
          // BottomNavigationBarItem(
          //   label: L10n.of(context).tabs_screen_chats_tab_text,
          //   icon: Icon(Icons.chat),
          // ),
          BottomNavigationBarItem(
            label: L10n.of(context).tabs_screen_settings_tab_text,
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: _currentTabIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditPetScreen.routeName);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
