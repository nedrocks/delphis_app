import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth.dart';
import './widgets/loginWithTwitterButton/index.dart';

class DelphisUnauthedBaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Center(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(Intl.message("You need to login with Twitter to see Delphis.")),
                LoginWithTwitterButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
    );
  }
}

