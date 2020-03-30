import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DelphisTextInput extends StatelessWidget {
  Key _inputKey = new GlobalKey();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextField(
        key: _inputKey,
        controller: this._controller,
        decoration: InputDecoration(
          labelText: "Input something",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }
}