import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/screens/discussion/discussion_post.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';

import '../../test_objects.dart';

void main() {
  final widgetKey = Key('discussion-post-key');
  final discussionAsAnon = TestObjects.getDiscussion1(asAnonymous: true);
  group('DiscussionPost: Text-Only Post', () {
    group('Opacity', () {
      testWidgets('When rendering a local post it should show 40% opacity',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
            home: Container(
                child: DiscussionPost(
                    discussion: discussionAsAnon,
                    index: 0,
                    isLocalPost: true))));

        final opacityObj = tester.firstWidget<Opacity>(find.byType(Opacity));
        expect(opacityObj.opacity, 0.4);
      });

      testWidgets('When rendering non-local post it should show 100% opacity',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
            home: Container(
                child: DiscussionPost(
                    discussion: discussionAsAnon,
                    index: 0,
                    isLocalPost: false))));

        final opacityObj = tester.firstWidget<Opacity>(find.byType(Opacity));
        expect(opacityObj.opacity, 1.0);
      });
    });

    group('Participant Images', () {
      testWidgets(
          'When rendering moderator participant, use moderator gradient and profile image',
          (WidgetTester tester) async {
        await provideMockedNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
              home: Container(
                  child: DiscussionPost(
                      key: widgetKey,
                      discussion: discussionAsAnon,
                      index: 1,
                      isLocalPost: false))));

          final profileImageContainer = tester.firstWidget<Container>(find
              .byKey(Key('${widgetKey.toString()}-profile-image-container')));
          expect(
              profileImageContainer.constraints,
              BoxConstraints(
                  minWidth: 36.0,
                  maxWidth: 36.0,
                  minHeight: 36.0,
                  maxHeight: 36.0));
          expect(profileImageContainer.decoration.runtimeType, BoxDecoration);
          final decoration = profileImageContainer.decoration as BoxDecoration;
          expect(decoration.shape, BoxShape.circle);
          expect(decoration.gradient,
              ChathamColors.gradients[moderatorGradientName]);
          expect(decoration.border,
              Border.all(color: Colors.transparent, width: 2.0));
          expect(
              profileImageContainer.child.runtimeType, ModeratorProfileImage);
          final profileImage =
              profileImageContainer.child as ModeratorProfileImage;
          expect(profileImage.profileImageURL,
              discussionAsAnon.moderator.userProfile.profileImageURL);
        });
      });
    });
  });
}
