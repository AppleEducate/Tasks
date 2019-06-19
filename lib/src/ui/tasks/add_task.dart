import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

import '../../data/classes/task.dart';
import '../common/index.dart';

class AddTaskWidget extends StatefulWidget {
  @override
  AddTaskWidgetState createState() => AddTaskWidgetState();
}

class AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerDetails = TextEditingController();
  final FocusNode _detailsFocus = FocusNode();
  bool _showDetails = false;
  DateTime _date;

  @override
  void initState() {
    super.initState();
    _showDetails = false;
    _controller.clear();
    _controllerDetails.clear();
  }

  @override
  void dispose() {
    _detailsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0))),
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'New Task',
              ),
              autocorrect: false,
              keyboardType: TextInputType.text,
            ),
            _showDetails
                ? TextField(
                    controller: _controllerDetails,
                    focusNode: _detailsFocus,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add details',
                      hintStyle: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                  )
                : Container(
                    height: 0.0,
                  ),
            _date == null
                ? Container(height: 0.0)
                : DateViewWidget(
                    date: _date,
                    onClose: () {
                      setState(() {
                        _date = null;
                      });
                    },
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FancyFab(
                  icon: Icons.add,
                  detailsPressed: () {
                    setState(() => _showDetails = true);
                    // FocusScope.of(context).requestFocus(_detailsFocus);
                  },
                  datePressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _date ?? DateTime.now(),
                      firstDate: (_date ?? DateTime.now())
                          .subtract(Duration(days: 30)),
                      lastDate:
                          (_date ?? DateTime.now()).add(Duration(days: 365)),
                    ).then((value) {
                      if (value == null) return;
                      print("Date: ${value.toIso8601String()}");
                      setState(() {
                        _date = value;
                      });
                    }).catchError((error) {
                      print(error.toString());
                    });
                  },
                ),
                FlatButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context,
                        Task(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: _controller.text.toString(),
                          subtitle: _controllerDetails.text.toString(),
                          date: _date,
                        ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
