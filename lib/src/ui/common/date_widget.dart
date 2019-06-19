import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

class DateViewWidget extends StatelessWidget {
  final VoidCallback onClose;
  final DateTime date;

  DateViewWidget({this.date, this.onClose});

  String getDateLabel() {
    if (date == null) return "";
    if (DateTime.now().year == date.year) {
      // -- Same Year --
      if (DateTime.now().month == date.month) {
        // -- Same Month --
        if (DateTime.now().day == date.day) {
          // -- Same Day --
          return "Today";
        }
        if (DateTime.now().day == date.day - 1) {
          // -- Same Day --
          return "Tomorrow";
        }
        if (DateTime.now().day >= date.day + 1) {
          // -- Same Day --
          final count = DateTime.now().day - date.day;
          if (count == 1) return "$count Day Ago";
          return "$count Days Ago";
        }
        // return DateFormat('MM-dd').format(date);
      }
      return DateFormat('EEE, MMM d').format(date);
    }
    return DateFormat('MM-dd-yyyy').format(date);
  }

  Color getDateColor() {
    // if (DateTime.now().year == date.year) {
    //   if (DateTime.now().month == date.month) {
    //     if (DateTime.now().day == date.day) {}
    //   }
    // }
    if (DateTime.now().millisecondsSinceEpoch > date.millisecondsSinceEpoch) {
      return Colors.red;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.grey[200],
          borderRadius: new BorderRadius.all(
            const Radius.circular(5.0),
          )),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.event_available,
              color: getDateColor(),
            ),
            Container(width: 5.0),
            Text(getDateLabel()),
            onClose == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: onClose,
                  )
          ],
        ),
      ),
    );
  }
}
