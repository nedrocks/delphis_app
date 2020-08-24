import 'package:delphis_app/bloc/me/me_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PendingRequestsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(
      builder: (context, meState) {
        final me = MeBloc.extractMe(meState);
        if (me == null) return SizedBox(height: 0);
        final accessRequests = me.pendingSentAccessRequests;
        if (accessRequests == null || accessRequests.length == 0)
          return SizedBox(height: 0);
        final accessRequestsCount = accessRequests.length;
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/Home/PendingRequestsList');
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SpacingValues.medium,
                vertical: SpacingValues.mediumLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(114, 30, 248, 1.0),
                Color.fromRGBO(177, 79, 186, 1.0),
              ]),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: SpacingValues.medium,
                  ),
                  Expanded(
                    child: Text(
                      accessRequestsCount > 1
                          ? Intl.message(
                              "You have $accessRequestsCount pending access requests...")
                          : Intl.message(
                              "You have $accessRequestsCount pending access request..."),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/forward_chevron.svg',
                    color: Colors.white,
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
