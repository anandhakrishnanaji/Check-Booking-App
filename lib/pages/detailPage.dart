import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/alertBox.dart';

final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

class DetailPage extends StatelessWidget {
  Future<bool> useTicket(String session, String userid, String ticketid) async {
    final url =
        'https://genapi.bluapps.in/Serv_v3/club_use?user_id=$userid&session_id=$session&ticketid=$ticketid';
    final response = await http.get(url);
    final jresponse = json.decode(response.body);
    if (jresponse['status'] == 'failed') throw jresponse['message'];
    return jresponse['status'] == 'success';
  }

  static const routeName = '/detailPage';
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
    final String session = prov.session, userid = prov.userid;
    final Map element = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text('Details')),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 0.3 * height,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue[900]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/usericon.jpg'),
                    radius: 50,
                  ),
                  Text(element['name'],
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 28)),
                  Text(element['membership_id'],
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 18))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
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
                                fontSize: 21, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Column(
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
                                fontSize: 21, fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
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
                                fontSize: 21, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Column(
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
                                fontSize: 21, fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    element['timing'],
                    style: GoogleFonts.openSans(
                        fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  element['showbtn'] == 'Y'
                      ? MaterialButton(
                          color: colors[element['btncolor'].toLowerCase()],
                          child: Text(
                            element['btntxt'],
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => useTicket(
                                  session, userid, element['ticketid'])
                              .then((value) => _scaffoldkey.currentState
                                  .showSnackBar(
                                      SnackBar(content: Text('Ticket Used'))))
                              .catchError((e) => showDialog(
                                  context: context,
                                  child: Alertbox(e.toString()))),
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
}
