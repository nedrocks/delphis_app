
import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';

class DisplayNames {

  static String formatParticipant(Moderator moderator, Participant participant) {
    var name = '${participant.gradientColor} #${participant.participantID}';
    if (participant.participantID == 0) {
      name = moderator.userProfile.displayName;
    } else if (!(participant.isAnonymous ?? true) &&
        participant.userProfile != null) {
      name = participant.userProfile.displayName;
    }
    return name;
  }

  static String formatParticipantUnique(Moderator moderator, Participant participant) {
    var name = '${participant.gradientColor.toLowerCase()}${participant.participantID}';
    if (participant.participantID == 0) {
      name = moderator.userProfile.twitterURL.displayText.substring(1);
    } else if (!(participant.isAnonymous ?? true) &&
        participant.userProfile != null) {
      name = participant.userProfile.twitterURL.displayText.substring(1);
    }

    name = name.replaceAll(" ", "");
    return name;
  }

  static String formatDiscussion(Discussion discussion) {
    return discussion.title;
  }

  static String formatDiscussionUnique(Discussion discussion) {
    var name = discussion.title;

    name = name.replaceAll(" ", "-").toLowerCase();
    name = name.replaceAll("#", "").toLowerCase();
    return name;
  }
  
}