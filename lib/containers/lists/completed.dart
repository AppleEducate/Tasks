import 'package:flutter/material.dart';
import '../../model/task.dart';
import '../../pages/task_details.dart';

class CompletedList extends StatelessWidget {
  final List<Task> items;
  final VoidCallback listRefresh;
  CompletedList({this.items, this.listRefresh});
  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty) return SliverFillRemaining();
    return SliverToBoxAdapter(
      child: ExpansionTile(
        title: Text('Completed (${items.length})'),
        backgroundColor: Colors.white,
        children: <Widget>[
          Container(
            height: 60.0 * items.length,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.check,
                          color: Colors.blue,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        onTap: () async {
                          var route = MaterialPageRoute(
                              builder: (BuildContext context) {
                            return TaskDetailsPage(item.title, item.id);
                          });
                          var value = await Navigator.of(context).push(route);
                          if (value == null) listRefresh();
                        },
                      ),
                    ),
                    Divider(
                      height: 1.0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}