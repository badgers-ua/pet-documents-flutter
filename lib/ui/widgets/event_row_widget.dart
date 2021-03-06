import 'package:intl/intl.dart' as intl;
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
    Key? key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDateMonth = intl.DateFormat.Md(Localizations.localeOf(context).languageCode)
        .format(DateTime.parse(event.date).toLocal())
        .toString();
    final String formattedYear = intl.DateFormat.y(Localizations.localeOf(context).languageCode)
        .format(DateTime.parse(event.date).toLocal())
        .toString();

    // TODO: [Feature]: Push notifications
    // final Widget? notificationIconWidget = event.isNotification
    //     ? Icon(
    //         Icons.notifications_active_rounded,
    //         color: Colors.grey,
    //       )
    //     : null;

    final Widget listTile = ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).highlightColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDateMonth,
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              formattedYear,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      trailing: onTap != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // TODO: [Feature]: Push notifications
                      // if (notificationIconWidget != null) notificationIconWidget,
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            )
          : null, // TODO: [Feature]: Push notifications // notificationIconWidget,
      title: RichText(
        text: TextSpan(
          style: TextStyle(fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
              text: prefix,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(
              text: getEventLabel(
                ctx: context,
                event: event.type,
              ),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      subtitle: event.description != null ? Text(event.description!) : null,
    );

    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: listTile,
          )
        : Column(
            children: [
              listTile,
              Divider(),
            ],
          );
  }
}
