import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/auth.dart';
import '../widgets/alertBox.dart';
import '../widgets/dataListTile.dart';

class ListPage extends StatelessWidget {
  static const routeName = '/listPage';

  Future<List> obtainList(String session, String userid, String csid) async {
    try {
      final response = await http.get(
          'https://genapi.bluapps.in/Serv_v3/club_booking?user_id=$userid&session_id=$session&club_service_id=$csid');
      final jresponse = json.decode(response.body);
      if (jresponse['status'] == 'failed')
        throw jresponse['message'];
      return jresponse['data'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Auth>(context, listen: false);
    final Map args = ModalRoute.of(context).settings.arguments;
    final session = prov.session, userid = prov.userid, csid = args['id'];
    return Scaffold(
        appBar: AppBar(title: Text(args['title'])),
        body: FutureBuilder(
            future: obtainList(session, userid, csid),
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
              }
              else{
               return ListView.builder(itemCount: snapshot.data.length ,itemBuilder:(context, index) => DataListTile(snapshot.data[index]) ,  );
              }
            }));
  }
}
