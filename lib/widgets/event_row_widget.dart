import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';

class EventRowWidget extends StatelessWidget {
  final String prefix;
  final EventResDto event;

  EventRowWidget({
    required this.event,
    this.prefix = '',
  });

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
          title: Row(
            children: [
              if (prefix.isNotEmpty)
                Text(
                  prefix,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              Text(
                getEventLabel(
                  ctx: context,
                  event: event.type,
                ),
              ),
            ],
          ),
          subtitle: Text(event.description),
        ),
      ),
    );
  }
}
