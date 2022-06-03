import 'package:flutter/material.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/models/event_row.dart';
import 'package:pdoc/ui/screens/add_edit_event_screen.dart';
import 'package:pdoc/ui/widgets/event_row_widget.dart';

import '../../../../../constants.dart';

class PetEventsSLiverListScreen extends StatelessWidget {
  final List<EventRow> eventRows;

  PetEventsSLiverListScreen({required this.eventRows});

  @override
  Widget build(BuildContext context) {
    if (eventRows.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(L10n.of(context).no_events_text),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final EventRow event = eventRows[index];

          final Widget row = EventRowWidget(
            event: event,
            onTap: () => Navigator.of(context)
                .pushNamed(AddEditEventScreen.routeName, arguments: AddEditEventScreenProps(event: event)),
          );

          final String title = event.title;

          return Container(
            key: ValueKey(event.id),
            child: title.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(ThemeConstants.spacing(0.5)),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      row,
                    ],
                  )
                : row,
          );
        },
        childCount: eventRows.length,
      ),
    );
    ;
  }
}