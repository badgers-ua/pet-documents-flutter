import 'package:flutter/material.dart';

class PetEventsSLiverListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            child: _EventRowWidget(),
          );
        },
        childCount: 20,
      ),
    );
  }
}

class _EventRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

