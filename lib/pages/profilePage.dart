import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

import '../widgets/alertBox.dart';
import '../providers/auth.dart';

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

  static const routeName = '/profilePage';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final prov = Provider.of<Auth>(context, listen: false);
    final String qrtext = ModalRoute.of(context).settings.arguments;
    final String session = prov.session, userid = prov.userid;
    return Scaffold(
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
                return Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Stack(children: [
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Colors.blue[900]),
                          height: 0.4 * height,
                          child: Column(
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
                                    NetworkImage(snapshot.data['mem_photo']),
                                radius: 50,
                              ),
                              Text(snapshot.data['name'],
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 28)),
                              SizedBox(height: 10),
                              Text(snapshot.data['membership_id'],
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white, fontSize: 18))
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: 0.8 * width,
                          height: 0.8 * width,
                          margin: EdgeInsets.only(top: 0.32 * height),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.brown[50],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data['service_name'],
                                        style: GoogleFonts.openSans(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'Demo Club',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data['timing'],
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        snapshot.data['service_date'],
                                        style: GoogleFonts.openSans(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'TICKET NO.',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'PKRZE',
                                        style: GoogleFonts.openSans(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  MaterialButton(
                                    color: Colors.yellow[800],
                                    child: Text('Member'),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('BOOKING DATE',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold)),
                                      Text(snapshot.data['datec']),
                                      SizedBox(
                                        height: 11,
                                      ),
                                      Text('TIME',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        snapshot.data['timing'].toUpperCase(),
                                        style: GoogleFonts.openSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 11,
                                      ),
                                      Text('NO. OF SEATS',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '1',
                                        style: GoogleFonts.openSans(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  QrImage(
                                    data: qrtext,
                                    size: 100,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'IMPORTANT INSTRUCTIONS:',
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              Text(
                                  'Showing this ticket is mandatory in order to use the respective services.Ticket once booked cannot be exchanged, cancelled or refunded',
                                  style: GoogleFonts.openSans())
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                );
              }
            }));
  }
}
