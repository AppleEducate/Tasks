import 'package:flutter_web/material.dart';

import '../../../data/classes/index.dart';
import '../../tasks/index.dart';
import '../index.dart';

class PendingList extends StatelessWidget {
  final List<Task> items;
  final ValueChanged<Task> dismissedTask;
  final VoidCallback listRefresh;
  final String listName;
  PendingList(
      {this.items, this.dismissedTask, this.listRefresh, this.listName});
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List<Dismissible>.generate(
          items.length,
          (int index) {
            final item = items[index];
            return Dismissible(
              direction: DismissDirection.startToEnd,
              key: Key(item.id.toString()),
              onDismissed: (direction) => dismissedTask(item),
              background: Container(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(
                    //   left: 5.0,
                    //   right: 5.0,
                    // ),
                    child: ListTile(
                      onTap: () async {
                        var route =
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TaskDetailsPage(listName, item);
                        });
                        var detailsPage =
                            await Navigator.of(context).push(route);
                        if (detailsPage != null) {
                          listRefresh();
                        }
                      },
                      leading: IconButton(
                        icon: Icon(Icons.radio_button_unchecked),
                        onPressed: () => dismissedTask(item),
                      ),
                      title: Text(item?.title ?? ""),
                      subtitle: item?.subtitle == null ||
                              (item?.subtitle?.isEmpty ?? true)
                          ? null
                          : Text(item.subtitle),
                    ),
                  ),
                  item.date != null
                      ? ListTile(
                          leading: Icon(Icons.info, color: Colors.transparent),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[DateViewWidget(date: item.date)],
                          ),
                        )
                      : Container(height: 0.0),
                  Divider(height: 1.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
