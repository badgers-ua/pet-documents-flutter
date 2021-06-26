import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';

class PetChatSliverListScreen extends StatelessWidget {
  final List<String> _list = [
    "daskdms dasmdj nafj dshf hdsbf hbdhg bdshjgb js",
    "123123231 4324234534546 456 456 56 456 546 345 45435 79347 5489375 8437 5034 ",
    "˜BCHCNFNIUDNFIOASNIFOSAjphljokpoj kojklkop ljhop kljohpk ojkjho pgjkihogkjio ghkijo ghioj ghjgh",
  ];

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(
              top: ThemeConstants.spacing(0.5),
              bottom: ThemeConstants.spacing(0.5),
            ),
            child: Row(
              mainAxisAlignment:
                  index.isOdd ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: index.isOdd ? Theme.of(context).backgroundColor : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: index.isOdd
                            ? Radius.circular(20)
                            : Radius.circular(0),
                        bottomRight: index.isOdd
                            ? Radius.circular(0)
                            : Radius.circular(20),
                      )),
                  padding: EdgeInsets.all(ThemeConstants.spacing(0.5)),
                  child: Text(_list[index]),
                  width: MediaQuery.of(context).size.width / 2,
                )
              ],
            ),
          );
        },
        childCount: _list.length,
      ),
    );
  }
}
