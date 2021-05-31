import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';

class EventRowWidget extends StatelessWidget {
  final EventResDto event;

  EventRowWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
          title: Text(getEventLabel(
            ctx: context,
            event: event.type,
          )),
          subtitle: Text(event.description),
        ),
      ),
    );
  }
}
