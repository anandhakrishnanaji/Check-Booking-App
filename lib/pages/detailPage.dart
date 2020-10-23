import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  static const routeName = 'detailPage';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Map element = ModalRoute.of(context).settings.arguments;
    return Scaffold(
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
