import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/screens/home_page/home_page_topbar.dart';
import 'package:delphis_app/screens/pending_requests_list/requests_list_view.dart';
import 'package:delphis_app/widgets/pressable/pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PendingRequestsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final windowPadding = MediaQuery.of(context).padding;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(11, 12, 16, 1.0),
      body: Padding(
        padding: EdgeInsets.only(bottom: windowPadding.bottom),
        child: Column(
          children: [
            Container(
              height: windowPadding.top,
              color: ChathamColors.topBarBackgroundColor,
            ),
            Container(
              color: ChathamColors.topBarBackgroundColor,
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Pressable(
                    height: null,
                    width: null,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: SpacingValues.medium,
                        bottom: SpacingValues.medium,
                        left: SpacingValues.large,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: SpacingValues.mediumLarge),
                        child: SvgPicture.asset(
                          'assets/svg/back_chevron.svg',
                          color: Colors.white,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  HomePageTopBar(
                    height: null,
                    title: Intl.message("Pending Invites"),
                    backgroundColor: ChathamColors.topBarBackgroundColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RequestsListView(),
            ),
          ],
        ),
      ),
    );
  }
}
