import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/auth.dart';
import '../widgets/alertBox.dart';
import './homePage.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ispnoerror = false, _isloading = false, ispassworderror = false;
  TextEditingController pno, password;

  @override
  void initState() {
    pno = new TextEditingController();
    password = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    pno.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 150,
                width: 150,
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                'Check Booking ',
                style: GoogleFonts.overpass(color: Colors.white, fontSize: 45),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                padding: EdgeInsets.all(30),
                height: 0.8 * width,
                width: 0.8 * width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: pno,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your Username',
                          errorText: ispnoerror ? 'Invalid Username' : null,
                          prefixIcon: Icon(Icons.account_circle),
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your Password',
                          errorText:
                              ispassworderror ? 'Invalid Password' : null,
                          prefixIcon: Icon(Icons.lock),
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    !_isloading
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            width: 0.3 * width,
                            child: MaterialButton(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                print('kona');
                                setState(() {
                                  ispnoerror = pno.text.isEmpty;
                                  ispassworderror = password.text.isEmpty;
                                  print(ispnoerror);
                                  print(ispassworderror);
                                });
                                if (!ispnoerror && !ispassworderror) {
                                  setState(() {
                                    _isloading = true;
                                  });
                                  Provider.of<Auth>(context, listen: false)
                                      .login(pno.text, password.text)
                                      .then((value) {
                                    if (value)
                                      Navigator.of(context)
                                          .pushNamed(HomePage.routeName);
                                    setState(() {
                                      _isloading = false;
                                    });
                                  }).catchError((e) {
                                    setState(() {
                                      _isloading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        child: Alertbox(e.toString()));
                                  });
                                }
                              },
                            ),
                          )
                        : CircularProgressIndicator()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
