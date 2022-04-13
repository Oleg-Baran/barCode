import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Expanded(child: Row(children: [
        Container(color: Colors.green,)
      ])),
    ));
  }
}
