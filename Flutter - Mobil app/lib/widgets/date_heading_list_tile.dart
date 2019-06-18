import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHeadingListTile extends StatelessWidget {
  DateHeadingListTile({
    Key key,
    @required this.date,
    DateFormat format,
  })  : format = format ?? DateFormat.yMd(),
        super(key: key);

  final DateTime date;
  final DateFormat format;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Text(
          format.format(date),
          style: _buildTextStyle(context),
          textScaleFactor: 1.5,
        ),
      ),
    );
  }

  TextStyle _buildTextStyle(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.copyWith(
            subhead: Theme.of(context).textTheme.subhead.copyWith(
                  color: Theme.of(context).primaryColor.withOpacity(0.38),
                  fontWeight: FontWeight.w500,
                ),
          ),
    );

    return theme.textTheme.subhead;
  }
}
