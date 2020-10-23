import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function ontap;
  DrawerTile(this.text, this.icon, this.ontap);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => ontap(),
      child: Container(
          padding: EdgeInsets.all(0.02 * height),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.06 * width),
                child: Text(
                  text,
                  style:
                      TextStyle(color: Colors.white, fontSize: 0.027 * height),
                ),
              )
            ],
          )),
    );
  }
}
