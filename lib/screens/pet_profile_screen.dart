import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/screens/events_screen.dart';

class PetProfileScreen extends StatefulWidget {
  static const routeName = '/pet-profile';

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  int _currentTabIndex = 0;

  SpeedDial petActionButtons(BuildContext ctx) {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.menu,
      backgroundColor: Theme.of(ctx).accentColor,
      foregroundColor: Theme.of(context).bottomAppBarColor,
      activeIcon: Icons.close,
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility),
          backgroundColor: Colors.red,
          label: 'Edit pet',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('FIRST CHILD'),
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.brush),
          backgroundColor: Colors.blue,
          label: 'Add owner',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice),
          backgroundColor: Colors.green,
          label: 'Remove owner',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice),
          backgroundColor: Colors.green,
          label: 'Delete pet',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            setState(() {
              _currentTabIndex = tabController.index;
            });
          }
        });
        return Scaffold(
          body: Scrollbar(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      title: Text('Jill'),
                      pinned: true,
                      snap: true,
                      floating: true,
                      expandedHeight: 200,
                      forceElevated: innerBoxIsScrolled,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.dstATop,
                              ),
                              image: NetworkImage(
                                'https://www.thesprucepets.com/thmb/DvxumVXUoBY2q0k3VVnOFRRz-dw=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/facts-about-black-cats-554102-hero-7281a22d75584d448290c359780c2ead.jpg',
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottom: TabBar(
                        tabs: [
                          Tab(text: L10n.of(context).pet_profile_screen_info_tab_text),
                          Tab(text: L10n.of(context).pet_profile_screen_chat_tab_text),
                          Tab(text: L10n.of(context).pet_profile_screen_events_tab_text),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  EventsScreen(),
                  EventsScreen(),
                  EventsScreen(),
                ],
              ),
            ),
          ),
          floatingActionButton:
              _currentTabIndex == 0 ? petActionButtons(context) : null,
        );
      }),
    );
  }
}
