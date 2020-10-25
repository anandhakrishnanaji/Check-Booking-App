import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../providers/auth.dart';
import '../widgets/alertBox.dart';
import '../widgets/dataListTile.dart';

class ListPage extends StatefulWidget {
  static const routeName = '/listPage';

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DateTime selectedDate = null;
  Future<List> obtainList(
      String session, String userid, String csid, DateTime sdate) async {
    try {
      String url =
          'https://genapi.bluapps.in/Serv_v3/club_booking?user_id=$userid&session_id=$session&club_service_id=$csid';
      if (sdate != null) {
        String formatted = DateFormat('yyyy-MM-dd').format(sdate);
        url += '&date=$formatted';
      }
      print(url);
      final response = await http.get(url);
      final jresponse = json.decode(response.body);
      if (jresponse['status'] == 'failed') throw jresponse['message'];
      return jresponse['data'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (selectedDate == null) selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Auth>(context, listen: false);
    final Map args = ModalRoute.of(context).settings.arguments;
    final session = prov.session, userid = prov.userid, csid = args['id'];
    return Scaffold(
      appBar: AppBar(title: Text(args['title'])),
      body: FutureBuilder(
          future: obtainList(session, userid, csid, selectedDate),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (snapshot.hasError) {
              Future.delayed(
                  Duration.zero,
                  () => showDialog(
                      context: _, child: Alertbox(snapshot.error.toString())));
              return SizedBox();
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) =>
                          DataListTile(snapshot.data[index]),
                    ),
                  ],
                ),
              );
            }
          }),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        // visible: _dialVisible,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.all_inclusive),
              backgroundColor: Colors.red,
              label: 'Show All',
              onTap: () {
                if (selectedDate != null) {
                  setState(() {
                    selectedDate = null;
                  });
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.calendar_today),
              backgroundColor: Colors.blue,
              label: 'Pick date',
              onTap: () async => await _selectDate(context)),
        ],
      ),
    );
  }
}
