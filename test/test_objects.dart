import 'package:delphis_app/data/repository/discussion.dart';
import 'package:delphis_app/data/repository/flair.dart';
import 'package:delphis_app/data/repository/moderator.dart';
import 'package:delphis_app/data/repository/participant.dart';
import 'package:delphis_app/data/repository/post.dart';
import 'package:delphis_app/data/repository/user_profile.dart';
import 'package:lipsum/lipsum.dart' as lipsum;

class TestObjects {
  static final yesterday = DateTime.now().subtract(Duration(days: 1));
  static final anHourAgo = DateTime.now().subtract(Duration(hours: 1));
  static final now = DateTime.now();

  static final moderatorParticipant = Participant(
    gradientColor: 'taupe',
    participantID: 0,
    isAnonymous: false,
    flair: null,
  );
  static final noFlairParticipant = Participant(
    gradientColor: 'taupe',
    participantID: 1,
    isAnonymous: false,
    flair: null,
  );
  static final noFlairParticipantAnon = Participant(
    gradientColor: 'taupe',
    participantID: 2,
    isAnonymous: true,
    flair: null,
  );
  static final participantWithFlair = Participant(
    gradientColor: 'taupe',
    participantID: 2,
    isAnonymous: false,
    flair: flair,
  );

  static final flair =
      Flair(imageURL: 'http://an.image/foo.jpg', displayName: 'Some Flair!');

  static final moderatorUserProfile = UserProfile(
    displayName: 'A person\'s name',
    profileImageURL: 'https://a.profile.url/image.jpg',
  );
  static final moderator = Moderator(userProfile: moderatorUserProfile);

  static final _discussion1 = Discussion(
    id: 'discussion-1',
    moderator: moderator,
    anonymityType: AnonymityType.WEAK,
    posts: [],
    participants: [noFlairParticipant, moderatorParticipant],
    title: lipsum.createWord(numWords: 2),
    createdAt: yesterday.toIso8601String(),
    updatedAt: yesterday.toIso8601String(),
    meParticipant: noFlairParticipantAnon,
    meAvailableParticipants: [noFlairParticipant, noFlairParticipantAnon],
  );

  static final post1 = Post(
    id: 'post-1',
    participant: noFlairParticipant,
    isDeleted: false,
    deletedReasonCode: null,
    content: 'post-1: ${lipsum.createText(numParagraphs: 1, numSentences: 3)}',
    discussion: _discussion1,
    createdAt: yesterday.toIso8601String(),
    updatedAt: yesterday.toIso8601String(),
  );
  static final post2 = Post(
    id: 'post-2',
    participant: moderatorParticipant,
    isDeleted: false,
    deletedReasonCode: null,
    content: 'post-2: ${lipsum.createText(numSentences: 1)}',
    discussion: _discussion1,
    createdAt: anHourAgo.toIso8601String(),
    updatedAt: anHourAgo.toIso8601String(),
  );

  static bool _isInitialized = false;

  static Discussion getDiscussion1({
    bool asModerator = false,
    bool asAnonymous = true,
  }) {
    if (asModerator && asAnonymous) {
      throw Exception('Cannot be an anonymous moderator');
    }
    if (!_isInitialized) {
      TestObjects.initialize();
    }
    return _discussion1.copyWith(
      meParticipant: asModerator
          ? moderatorParticipant
          : (asAnonymous ? noFlairParticipantAnon : noFlairParticipant),
    );
  }

  static void initialize() {
    _discussion1.posts.addAll([post1, post2]);
    _isInitialized = true;
  }
}
