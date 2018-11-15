import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/fancy_fab.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';

class AddTaskWidget extends StatefulWidget {
  @override
  AddTaskWidgetState createState() => AddTaskWidgetState();
}

class AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerDetails = TextEditingController();
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
                    autofocus: true,
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
                : Container(
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
                            color: Colors.blue,
                          ),
                          Container(width: 5.0),
                          Text(DateFormat('MM-dd-yyyy').format(_date)),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _date = null;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FancyFab(
                  icon: Icons.add,
                  detailsPressed: () => setState(() => _showDetails = true),
                  datePressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(
                        days: 30,
                      )),
                      lastDate: DateTime.now().add(
                        Duration(
                          days: 30,
                        ),
                      ),
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
                          _controller.text.toString(),
                          "PENDING",
                          _controllerDetails.text.toString(),
                          _date.toString(),
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