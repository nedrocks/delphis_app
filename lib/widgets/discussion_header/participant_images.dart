import 'dart:math';

import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/widgets/profile_image/profile_image.dart';
import 'package:flutter/material.dart';
import './additional_pariticipants.dart';

class ParticipantImages extends StatelessWidget {
  static const emptyParticipantList = <Participant>[];

  final double height;
  final List<Participant> participants;
  final int maxNonAnonToShow;

  const ParticipantImages({
    @required this.height,
    @required participants,
    this.maxNonAnonToShow = 5,
  })  : this.participants =
            participants == null ? emptyParticipantList : participants,
        super();

  List<Widget> generateProfileImages(
      List<Participant> anon, List<Participant> nonAnon) {
    final List<Widget> response = List<Widget>();
    final numWidgetsToCreate = min(nonAnon.length, this.maxNonAnonToShow);
    for (int i = 0; i < numWidgetsToCreate; i++) {
      response.add(ProfileImage(
        height: this.height,
        width: this.height,
        // TODO: Change this once we have profile images for non-anon.
        profileImageURL:
            'https://pbs.twimg.com/profile_images/569623151382765568/IXqTQzHo_normal.jpeg',
      ));
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final anonParticipants =
        this.participants.where((p) => p.isAnonymous).toList();
    final nonAnonParticipants =
        this.participants.where((p) => !p.isAnonymous).toList();
    final notShownParticipants = anonParticipants.length +
        max(nonAnonParticipants.length - this.maxNonAnonToShow, 0);

    final bool hasNonAnon = nonAnonParticipants.length > 0;
    final bool hasNotShown = notShownParticipants > 0;

    final double width = this.height *
        (hasNonAnon
            ? (min(nonAnonParticipants.length, this.maxNonAnonToShow) + 2) * 0.5
            : 0 + ((hasNotShown && !hasNonAnon) ? 1.0 : 0));

    final List<Widget> profiles =
        this.generateProfileImages(anonParticipants, nonAnonParticipants);
    if (hasNotShown) {
      profiles.add(AdditionalParticipants(
        diameter: this.height,
        numAdditional: notShownParticipants,
      ));
    }

    final List<Widget> profilesWithLayout = List<Widget>();
    for (int i = 0; i < profiles.length; i++) {
      profilesWithLayout.add(Container(
        alignment:
            Alignment(-1 + i * 2 * (1.0 / max(profiles.length - 1, 1)), 0.0),
        child: profiles[i],
      ));
    }

    return Container(
      width: width,
      height: this.height,
      child: profilesWithLayout.length > 0
          ? Stack(children: profilesWithLayout)
          : null,
    );
  }
}
