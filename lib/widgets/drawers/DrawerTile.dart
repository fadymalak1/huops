import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile(
      { required this.title,
         required this.icon,
         required this.onTap,
        this.isSelected = false,
        this.iconColor =  Colors.blue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function(),
      child: Container(
          padding: EdgeInsets.all(  16 ),
          decoration: BoxDecoration(
              color:   Colors.transparent ,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: [
              Icon(icon,
                  size: 24,
                  color: this.iconColor),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: title.text.bold
                    .maxLines(1)
                    .size(14)
                    .overflow(TextOverflow.ellipsis)
                    .make(),
              )
            ],
          )),
    );
  }
}