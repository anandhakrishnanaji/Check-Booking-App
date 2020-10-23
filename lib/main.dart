import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './pages/homePage.dart';
import 'pages/loginPage.dart';
import './pages/detailPage.dart';
import './pages/listPage.dart';
import './pages/profilePage.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (context) => Auth(),
        child: Consumer<Auth>(
          builder: (context, value, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Checkbook App',
            theme: ThemeData(
              primaryColor: Colors.black,
              accentColor: Colors.grey[600],
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routes: {
              "/": (ctx) => FutureBuilder(
                  future: value.isloggedin(),
                  builder: (_, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold()
                          : (snapshot.data != null && snapshot.data)
                              ? HomePage()
                              : LoginPage()),
              HomePage.routeName: (ctx) => HomePage(),
              LoginPage.routeName: (ctx) => LoginPage(),
              DetailPage.routeName: (ctx) => DetailPage(),
              ListPage.routeName: (ctx) => ListPage(),
              ProfilePage.routeName: (ctx) => ProfilePage()
            },
          ),
        ));
  }
}
