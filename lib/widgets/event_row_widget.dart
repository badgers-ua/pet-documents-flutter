import 'package:flutter/material.dart';
import 'package:pdoc/models/dto/response/event_res_dto.dart';

class EventRowWidget extends StatelessWidget {
  final EventResDto event;
  final GestureTapCallback? onTap;
  final String prefix;

  EventRowWidget({
    required this.event,
    this.onTap,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    final Widget listTile = ListTile(
      trailing: onTap != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            )
          : null,
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
      subtitle: event.description != null ? Text(event.description!) : null,
    );
    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: listTile,
          )
        : listTile;
  }
}
