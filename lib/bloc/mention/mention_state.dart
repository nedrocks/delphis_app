part of 'mention_bloc.dart';

class MentionState extends Equatable {

  static final String encodedMentionRegexPattern = "(<)([0-9]+)(>)";
  static final String mentionSpecialCharsRegexPattern = "&lt|&gt|&amp";
  static final String participantMentionSymbol = "@";
  static final String discussionMentionSymbol = "#";
  static final String participantMentionRegexPattern = "@[A-Za-z0-9_-]*";
  static final String discussionMentionRegexPattern = "#[A-Za-z0-9_-]*";
  static final String unknownMentionRegexPattern = "[@#]{1}[\.]{3}";
  final Discussion discussion;
  final List<Discussion> discussions;

  MentionState({this.discussion, this.discussions});

  MentionState copyWith({
    discussion,
    discussions,
  }) {
    return MentionState(
      discussion: discussion ?? this.discussion,
      discussions: discussions ?? this.discussions,
    );
  }
  
  bool isReady() {
    return this.discussion != null && this.discussion.participants != null && this.discussions != null;
  }

  @override
  List<Object> get props => [discussion, discussions];

  String metionedToLocalEntityID(String id) {
    if(!id.contains(":"))
      return id;
    return id.split(":")[1];
  }

  String formatParticipantMention(Participant participant) {
    return '${DisplayNames.formatParticipantUnique(discussion.moderator, participant)}';
  }

  String formatDiscussionMention(Discussion discussion) {
    return '${DisplayNames.formatDiscussionUnique(discussion)}';
  }

  String formatParticipantMentionWithSymbol(Participant participant) {
    return '$participantMentionSymbol${DisplayNames.formatParticipantUnique(discussion.moderator, participant)}';
  }

  String formatDiscussionMentionWithSymbol(Discussion discussion) {
    return '$discussionMentionSymbol${DisplayNames.formatDiscussionUnique(discussion)}';
  }

  /* Encodes the content of a post and adds the mentioned entities to the provided list */
  String encodePostContent(String postContent, List<String> mentionedEntities) {
    postContent = postContent.replaceAll("&", "&amp").replaceAll("<", "&lt").replaceAll(">", "&gt");
    for(var participant in discussion.participants) {
      var tag = formatParticipantMentionWithSymbol(participant);
      if(postContent.contains(tag)) {
        var replace = "<${mentionedEntities.length}>";
        var entity = "participant:${participant.id}";
        postContent = postContent.replaceAll(tag, replace);
        mentionedEntities.add(entity);
      }
    }
    for(var discussion in discussions) {
      var tag = formatDiscussionMentionWithSymbol(discussion);
      if(postContent.contains(tag)) {
        var replace = "<${mentionedEntities.length}>";
        var entity = "discussion:${discussion.id}";
        postContent = postContent.replaceAll(tag, replace);
        mentionedEntities.add(entity);
      }
    }
    return postContent;
  }

  String decodePostContent(String postContent, List<Entity> mentionedEntities) {
    postContent = postContent.replaceAll("&lt", "<").replaceAll("&gt", ">").replaceAll("&amp", "&");
    var entitiesCount = mentionedEntities?.length ?? 0;
    
    /* Solve mentions */
    for(var i = 0; i < entitiesCount; i++) {
      var id = mentionedEntities[i].id;
      
      /* Handle participants mentions */
      var p = discussion.participants.firstWhere((e) => e.id.compareTo(id) == 0, orElse: () => null);
      if(p != null && postContent.contains("<$i>")) {
        postContent = postContent.replaceAll("<$i>", formatParticipantMentionWithSymbol(p));
        continue;
      }
      else {
        postContent = postContent.replaceAll("<$i>", Intl.message("$participantMentionSymbol..."));
      }

      /* Handle discussions mentions */
      var d = discussions.firstWhere((e) => e.id.compareTo(id) == 0, orElse: () => null);
      if(d != null && postContent.contains("<$i>")) {
        postContent = postContent.replaceAll("<$i>", formatDiscussionMentionWithSymbol(d));
        continue;
      }
      else {
        postContent = postContent.replaceAll("<$i>", Intl.message("$discussionMentionSymbol..."));
      }
    }

    /* Solve unmatched mentions */
    RegExp mentionRegex = RegExp(encodedMentionRegexPattern);
    if(mentionRegex.hasMatch(postContent)) {
      for(var match in mentionRegex.allMatches(postContent)) {
        postContent = postContent.replaceAll(match.group(0), Intl.message("$participantMentionSymbol..."));
      }
    }

    return postContent;
  }

  String getLastParticipantMentionAttempt(String text) {
    return _getLastMentionAttempt(RegExp(participantMentionRegexPattern), participantMentionSymbol, text);
  }

  String getLastDiscussionMentionAttempt(String text) {
    return _getLastMentionAttempt(RegExp(discussionMentionRegexPattern), discussionMentionSymbol, text);
  }

  String _getLastMentionAttempt(RegExp regex, String mentionSymbol, String text) {
    if(regex.hasMatch(text)) {
      var matches = regex.allMatches(text);
      var match = matches.last.group(0).substring(1);
      if ((match.length == 0 && text.endsWith(mentionSymbol)) || (match.length > 0 && text.endsWith(match)))
        return match;
    }
    return null;
  }

}