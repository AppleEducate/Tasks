import 'package:flutter_web/material.dart';

class MenuWidget extends StatelessWidget {
  final List<String> listNames;
  final String activeList;
  final ValueChanged<String> listChange;
  final VoidCallback createList;
  MenuWidget(
      {this.listNames, this.listChange, this.createList, this.activeList});
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 530.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // UserAccountsDrawerHeader(
            //   currentAccountPicture: DecoratedBox(
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage("assets/user/satya_profile.png"),
            //       ),
            //     ),
            //   ),
            //   margin: EdgeInsets.all(0.0),
            //   accountEmail: Text(
            //     "satyabrat.me@gmail.com",
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //   ),
            //   accountName: Text(
            //     "Satyabrat Sahoo",
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //   ),
            // ),
            Divider(
              height: 4.0,
              indent: 2.0,
            ),
            SizedBox(
              height: listNames.length > 3 ? 200.0 : null,
              child: Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listNames.length,
                    itemBuilder: (context, index) {
                      final _listItem = listNames[index];
                      return GestureDetector(
                        onTap: () {
                          listChange(_listItem);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: (activeList == _listItem)
                                  ? Color(0x4D90CAF9)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                            ),
                            child: ListTile(
                              selected: true,
                              title: Text(
                                _listItem,
                                style: TextStyle(
                                  color: (activeList == _listItem)
                                      ? Colors.blueAccent
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              // left: 8.0,
                              top: 8.0,
                              bottom: 8.0,
                              right: 10.0),
                        ),
                      );
                    }),
              ),
            ),
            Divider(
              height: 4.0,
            ),
            ListTile(
              leading: Icon(
                Icons.add,
              ),
              title: Text(
                "Create list",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: createList,
            ),
            Divider(
              height: 4.0,
            ),
            ListTile(
              leading: Icon(
                Icons.feedback,
              ),
              title: Text(
                "Send feedback",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(
              height: 4.0,
            ),
            ListTile(
              title: Text(
                "Open-source licenses",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    width: 25.0,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      size: 5.0,
                    ),
                  ),
                  //new Icon(
                  //Icons.,
                  //),
                  Text(
                    "Terms of service",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
