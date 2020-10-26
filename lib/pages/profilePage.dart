import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../widgets/confirmationDialog.dart';
import 'dart:convert';

import '../widgets/alertBox.dart';
import '../providers/auth.dart';

final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

class ProfilePage extends StatelessWidget {
  Future<Map> obtainDetails(
      String session, String userid, String qrtext) async {
    final url =
        'https://genapi.bluapps.in/Serv_v3/club_qrcode?user_id=$userid&session_id=$session&text=$qrtext';
    final response = await http.get(url);
    final jresponse = json.decode(response.body);
    if (jresponse['status'] == 'failed') throw jresponse['message'];
    return jresponse['data'][0];
  }

  Future<bool> useTicket(String session, String userid, String ticketid) async {
    final url =
        'https://genapi.bluapps.in/Serv_v3/club_use?user_id=$userid&session_id=$session&ticketid=$ticketid';
    final response = await http.get(url);
    final jresponse = json.decode(response.body);
    if (jresponse['status'] == 'failed') throw jresponse['message'];
    return jresponse['status'] == 'success';
  }

  static const routeName = '/profilePage';

  @override
  Widget build(BuildContext context) {
    const Map colors = {
      'green': Colors.green,
      'yellow': Colors.yellow,
      'blue': Colors.blue,
      'black': Colors.black,
      'purple': Colors.purple,
      'red': Colors.red
    };
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final prov = Provider.of<Auth>(context, listen: false);
    final String qrtext = ModalRoute.of(context).settings.arguments;
    final String session = prov.session, userid = prov.userid;
    return Scaffold(
        key: _scaffoldkey,
        body: FutureBuilder(
            future: obtainDetails(session, userid, qrtext),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (snapshot.hasError) {
                Future.delayed(
                    Duration.zero,
                    () => showDialog(
                        context: _,
                        child: Alertbox(snapshot.error.toString())));
                return SizedBox();
              } else {
                final Map element = snapshot.data;
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 0.4 * height,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.blue[900]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ]),
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(element['mem_photo']),
                                radius: 70,
                              ),
                              Text(element['name'],
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 24)),
                              Text(element['membership_id'],
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 17))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'ADDRESS',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          element['address'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'SERVICE DATE',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          element['service_date'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'SERVICE NAME',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          element['service_name'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'COURT',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          element['court_name'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'TIMING',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          element['timing'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'NO. OF PERSON',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        element['no_of_member'],
                                        style: GoogleFonts.openSans(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              element['showbtn'] == 'Y'
                                  ? MaterialButton(
                                      padding: EdgeInsets.all(10),
                                      minWidth: 0.9 * width,
                                      color: colors[
                                          element['btncolor'].toLowerCase()],
                                      child: Text(
                                        element['btntxt'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        if (element['allowclick'] == 'Y')
                                          await showDialog(
                                                  context: context,
                                                  child: ConfirmationDialog())
                                              .then((value) {
                                            if (value)
                                              useTicket(session, userid,
                                                      element['ticketid'])
                                                  .then((value) => _scaffoldkey
                                                      .currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Ticket Used'))))
                                                  .catchError((e) => showDialog(
                                                      context: context,
                                                      child: Alertbox(
                                                          e.toString())));
                                          });
                                      },
                                    )
                                  : SizedBox()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
