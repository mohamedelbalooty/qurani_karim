import 'package:flutter/material.dart';
import 'package:qurany_karim/utils/constants/colors.dart';

class BuildCircleButton extends StatelessWidget {
  final String symbol;
  final Function onClick;

  const BuildCircleButton(
      {Key key, @required this.symbol, @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        symbol,
        style: const TextStyle(fontSize: 30.0, color: mainColor),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: whiteColor,
        shadowColor: mainColor,
        shape: CircleBorder(),
        padding: const EdgeInsets.all(2.0),
      ),
      onPressed: onClick,
    );
  }
}
