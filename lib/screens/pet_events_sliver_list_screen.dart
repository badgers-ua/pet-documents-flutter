import 'package:flutter/material.dart';
import 'package:pdoc/widgets/pet_info_row_widget.dart';

class PetEventsSLiverListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            child: PetInfoRowWidget(),
          );
        },
        childCount: 20,
      ),
    );
  }
}
