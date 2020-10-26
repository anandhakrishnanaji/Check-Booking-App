import 'package:flutter/material.dart';

import '../pages/detailPage.dart';

class DataListTile extends StatelessWidget {
  final Map element;
  final int index;
  DataListTile(this.element, this.index);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: index % 2 == 0 ? Colors.blue[50] : Colors.white,
        child: ListTile(
          isThreeLine: true,
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/usericon.jpg'),
          ),
          title: Text(element['name']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(element['address']),
              Text('Status: ${element['used']}'),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(element['service_date']),
              Text(element['court_name']),
              Text(element['timing'])
            ],
          ),
          onTap: () => Navigator.of(context)
              .pushNamed(DetailPage.routeName, arguments: element),
        ),
      ),
    );
  }
}
