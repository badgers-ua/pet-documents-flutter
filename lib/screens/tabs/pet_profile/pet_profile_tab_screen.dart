import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';

class PetProfileTabScreen extends StatelessWidget {
  final Widget child;

  PetProfileTabScreen({required this.child});

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
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  vertical: ThemeConstants.spacing(0.5),
                  horizontal: ThemeConstants.spacing(1),
                ),
                sliver: child
              ),
            ],
          );
        },
      ),
    );
  }
}
