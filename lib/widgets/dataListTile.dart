import 'package:flutter/material.dart';

import '../pages/detailPage.dart';

class DataListTile extends StatelessWidget {
  final Map element;
  DataListTile(this.element);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/usericon.jpg'),
        ),
        title: Text(element['name']),
        subtitle: Text(element['address']),
        trailing: Text(element['service_date']),
        onTap: () => Navigator.of(context)
            .pushNamed(DetailPage.routeName, arguments: element),
      ),
    );
  }
}
