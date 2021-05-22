import 'package:flutter/material.dart';

import '../constants.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  vertical: ThemeConstants.spacing(0.5),
                  horizontal: ThemeConstants.spacing(1),
                ),
                sliver: SliverFixedExtentList(
                  itemExtent: 50,
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ThemeConstants.spacing(0.5),
                        ),
                        child: Text("1"),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
