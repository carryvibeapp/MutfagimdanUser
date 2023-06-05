import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SlotWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;
  SlotWidget({@required this.title, @required this.isSelected, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [BoxShadow(
              color: Colors.grey[Provider.of<ThemeProvider>(context, listen: false).darkTheme ? 800 : 200],
              spreadRadius: 0.5, blurRadius: 0.5,
            )],
          ),
          child: Text(
            title,
            style: rubikRegular.copyWith(color: isSelected ? Theme.of(context).cardColor : Theme.of(context).textTheme.bodyLarge.color),
          ),
        ),
      ),
    );
  }
}
