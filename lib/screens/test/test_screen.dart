import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Foo"),
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          height: 350,
          child: UiKitView(viewType: "FooView"),
        ),
      ),
    );
  }
}
