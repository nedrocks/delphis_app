class ChathamLinkParser {
  static bool isNormalDiscussionLink(Uri link) {
    try {
      final pathParts = link.path.split('/');
      if (link.path.startsWith('/d') && (pathParts.length == 2)) {
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  static bool isVIPDiscussionLink(Uri link) {
    try {
      final pathParts = link.path.split('/');
      if (link.path.startsWith('/d') && (pathParts.length == 3)) {
        return true;
      }
    } catch (_) {
      return false;
    }
  }
}
