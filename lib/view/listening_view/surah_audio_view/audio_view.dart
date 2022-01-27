import 'package:flutter/material.dart';

class AudioView extends StatelessWidget {
  final String appBarTitle;
  const AudioView({Key key, @required this.appBarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
