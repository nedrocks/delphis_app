import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:delphis_app/models/auth.dart';

import 'unauthed.dart';

class DelphisBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Intl.message("Delphis App")),
      ), 
      body: Consumer<DelphisAuth>(
        builder: (context, authModel, child) {
          if (!authModel.isAuthed) {
            print('Not authed');
            return DelphisUnauthedBaseView();
          }
          print('Authed');
          return DelphisUnauthedBaseView();
        },
      ),
    );
  }
}