
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';

class DisplayNames {

  static final String participantMentionSymbol = "@";
  static final String discussiomMentionSymbol = "#";
  static final String participantMentionRegexPattern = "@[A-Za-z0-9_-]*";
  static final String discussionMentionRegexPattern = "#[A-Za-z0-9_-]*";

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

  static String formatParticipantMention(Moderator moderator, Participant participant) {
    var name = '${participant.gradientColor}';
    if (participant.participantID == 0) {
      name = moderator.userProfile.displayName;
    } else if (!(participant.isAnonymous ?? true) &&
        participant.userProfile != null) {
      name = participant.userProfile.displayName;
    }

    name = name.replaceAll(" ", "");
    name = '$name${participant.participantID}';
    return name;
  }

  static String formatParticipantMentionWithSymbol(Moderator moderator, Participant participant) {
    return '$participantMentionSymbol${formatParticipantMention(moderator, participant)}';
  }
  
}