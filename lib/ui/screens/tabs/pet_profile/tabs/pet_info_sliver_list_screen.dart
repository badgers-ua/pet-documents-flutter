import 'package:flutter/material.dart';
import 'package:pdoc/ui/widgets/pet_info_row_widget.dart';

class PetInfoSliverListScreen extends StatelessWidget {
  final List<PetInfoRowWidgetProps> petRowList;

  PetInfoSliverListScreen({
    required this.petRowList,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            child: PetInfoRowWidget(props: petRowList[index]),
          );
        },
        childCount: petRowList.length,
      ),
    );
  }
}
