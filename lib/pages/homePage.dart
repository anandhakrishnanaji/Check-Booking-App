import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../providers/auth.dart';
import '../widgets/drawerTile.dart';
import './profilePage.dart';
import '../tabs/homeTab.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Map> _drawerList = [
    {'text': 'Home', 'icon': Icons.home, 'ontap': (BuildContext ctx) => 0},
    {
      'text': 'Logout',
      'icon': Icons.exit_to_app,
      'ontap': (BuildContext ctx) {
        Provider.of<Auth>(ctx, listen: false).logout().then((value) =>
            Navigator.of(ctx)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false));
      }
    }
  ];
  List<Widget> _children;

  @override
  void initState() {
    _children = [HomeTab()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      // key: globalScaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _children[_currentIndex],

      bottomNavigationBar: BottomAppBar(
        child: Container(
            height: 65,
            margin: EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _onTabTapped(0);
                        },
                        iconSize: 27.0,
                        icon: Icon(
                          Icons.home,
                          color: _currentIndex == 0
                              ? Colors.blueAccent[700]
                              : Colors.grey.shade400,
                        ),
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: _currentIndex == 0
                              ? Colors.blueAccent[700]
                              : Colors.grey.shade400,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          String cameraScanResult = await scanner.scan();
                          if (cameraScanResult != null)
                            Navigator.pushNamed(context, ProfilePage.routeName,
                                arguments: cameraScanResult);
                        },
                        iconSize: 27.0,
                        icon: Icon(
                          Icons.stay_current_landscape,
                          color: _currentIndex == 1
                              ? Colors.blueAccent[700]
                              : Colors.grey.shade400,
                        ),
                      ),
                      Text(
                        'Scan QR',
                        style: TextStyle(
                          color: _currentIndex == 1
                              ? Colors.blueAccent[700]
                              : Colors.grey.shade400,
                        ),
                      )
                    ],
                  )
                ])),
        shape: CircularNotchedRectangle(),
      ),

      drawer: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Color.fromRGBO(46, 46, 46, 1)),
        child: Drawer(
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/usericon.jpg',
                      ),
                      radius: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        Provider.of<Auth>(context, listen: false).name,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              ..._drawerList
                  .map((e) => DrawerTile(e['text'], e['icon'], () {
                        Navigator.pop(context);
                        final a = e['ontap'](context);
                        if (a is int)
                          setState(() {
                            _currentIndex = a;
                          });
                      }))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
