import 'package:flutter_web/material.dart';

import '../../../data/classes/task.dart';
import '../../tasks/index.dart';

class CompletedList extends StatelessWidget {
  final List<Task> items;
  final String listName;
  final VoidCallback listRefresh;
  final ValueChanged<Task> restoreTask;
  CompletedList(
      {this.items, this.listRefresh, this.listName, this.restoreTask});
  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty) return SliverFillRemaining();
    return SliverToBoxAdapter(
      child: ExpansionTile(
        title: Text('Completed (${items.length})'),
        backgroundColor: Colors.white,
        children: <Widget>[
          Container(
            height: 70.0 * items.length,
            child: ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.check, color: Colors.blue),
                          onPressed: () => restoreTask(item),
                        ),
                        title: Text(
                          item.title,
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        subtitle: item?.subtitle == null ||
                                (item?.subtitle?.isEmpty ?? true)
                            ? null
                            : Text(item.subtitle),
                        onTap: () async {
                          var route = MaterialPageRoute(
                              builder: (BuildContext context) {
                            return TaskDetailsPage(listName, item);
                          });
                          var value = await Navigator.of(context).push(route);
                          if (value != null) listRefresh();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1.0),
        ],
      ),
    );
  }
}
