import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/alertBox.dart';
import '../pages/listPage.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).obtainIcons(),
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
            return Container(
              padding: EdgeInsets.all(15),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(context)
                            .pushNamed(ListPage.routeName, arguments: {
                          'id': snapshot.data[index]['club_service_id'],
                          'title': snapshot.data[index]['service_name']
                        }),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Image.network(snapshot.data[index]['service_logo']),
                          Text(snapshot.data[index]['service_name'])
                        ],
                      ),
                    )),
              ),
            );
          }
        });
  }
}
