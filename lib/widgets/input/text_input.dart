import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DelphisTextInput extends StatelessWidget {
  final TextEditingController controller;
  int numRows;
  final double height;
  final FocusNode focusNode;

  DelphisTextInput({
    this.controller,
    this.numRows,
    this.height,
    this.focusNode,
  }): super();

  @override
  Widget build(BuildContext context) {
    print('rerendering');
    return Container(
      width: double.infinity,
      height: this.height,
      decoration: BoxDecoration(border: Border.all(color: Colors.green)),
      child: TextField(
        controller: this.controller,
        decoration: InputDecoration(
          labelText: "Input something",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: this.numRows,
      ),
    );
  }
}