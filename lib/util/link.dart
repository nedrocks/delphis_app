class ChathamDiscussionLinkParams {
  final String discussionSlug;

  const ChathamDiscussionLinkParams(this.discussionSlug);
}

class ChathamLinkParser {
  static ChathamDiscussionLinkParams getChathamDiscussionLinkParams(Uri link) {
    try {
      if (link.path.startsWith('/d')) {
        if (link.pathSegments.length == 2) {
          return ChathamDiscussionLinkParams(link.pathSegments[1]);
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
