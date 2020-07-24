class ChathamDiscussionLinkParams {
  final String discussionID;
  final String vipLinkToken;

  const ChathamDiscussionLinkParams(this.discussionID, this.vipLinkToken);

  bool get isVipLink => vipLinkToken != null;
}

class ChathamLinkParser {
  static ChathamDiscussionLinkParams getChathamDiscussionLinkParams(Uri link) {
    try {
      if (link.path.startsWith('/d')) {
        if (link.pathSegments.length == 2) {
          return ChathamDiscussionLinkParams(link.pathSegments[1], null);
        } else if (link.pathSegments.length == 3) {
          return ChathamDiscussionLinkParams(
              link.pathSegments[1], link.pathSegments[2]);
        } else {
          return null;
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
