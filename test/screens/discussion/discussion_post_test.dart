import 'package:delphis_app/design/colors.dart';
import 'package:delphis_app/screens/discussion/discussion_post.dart';
import 'package:delphis_app/screens/discussion/post_title.dart';
import 'package:delphis_app/widgets/anon_profile_image/anon_profile_image.dart';
import 'package:delphis_app/widgets/profile_image/moderator_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';

import '../../test_objects.dart';

void main() {
  // final widgetKey = Key('discussion-post-key');
  // final discussionAsAnon = TestObjects.getDiscussion1(asAnonymous: true);
  // group('DiscussionPost: Text-Only Post', () {
  //   group('Opacity', () {
  //     testWidgets('When rendering a local post it should show 40% opacity',
  //         (WidgetTester tester) async {
  //       await tester.pumpWidget(MaterialApp(
  //           home: Container(
  //               child: DiscussionPost(
  //                   discussion: discussionAsAnon,
  //                   index: 0,
  //                   isLocalPost: true))));

  //       final opacityObj = tester.firstWidget<Opacity>(find.byType(Opacity));
  //       expect(opacityObj.opacity, 0.4);
  //     });

  //     testWidgets('When rendering non-local post it should show 100% opacity',
  //         (WidgetTester tester) async {
  //       await tester.pumpWidget(MaterialApp(
  //           home: Container(
  //               child: DiscussionPost(
  //                   discussion: discussionAsAnon,
  //                   index: 0,
  //                   isLocalPost: false))));

  //       final opacityObj = tester.firstWidget<Opacity>(find.byType(Opacity));
  //       expect(opacityObj.opacity, 1.0);
  //     });
  //   });

  //   group('Participant Images', () {
  //     testWidgets(
  //         'When rendering moderator participant, use moderator gradient and profile image',
  //         (WidgetTester tester) async {
  //       await provideMockedNetworkImages(() async {
  //         await tester.pumpWidget(MaterialApp(
  //             home: Container(
  //                 child: DiscussionPost(
  //                     key: widgetKey,
  //                     discussion: discussionAsAnon,
  //                     index: 1,
  //                     isLocalPost: false))));

  //         final profileImageContainer = tester.firstWidget<Container>(find
  //             .byKey(Key('${widgetKey.toString()}-profile-image-container')));
  //         expect(
  //             profileImageContainer.constraints,
  //             BoxConstraints(
  //                 minWidth: 36.0,
  //                 maxWidth: 36.0,
  //                 minHeight: 36.0,
  //                 maxHeight: 36.0));
  //         expect(profileImageContainer.decoration.runtimeType, BoxDecoration);
  //         final decoration = profileImageContainer.decoration as BoxDecoration;
  //         expect(decoration.shape, BoxShape.circle);
  //         expect(decoration.gradient,
  //             ChathamColors.gradients[moderatorGradientName]);
  //         expect(decoration.border,
  //             Border.all(color: Colors.transparent, width: 1.0));
  //         expect(
  //             profileImageContainer.child.runtimeType, ModeratorProfileImage);
  //         final profileImage =
  //             profileImageContainer.child as ModeratorProfileImage;
  //         expect(profileImage.profileImageURL,
  //             discussionAsAnon.moderator.userProfile.profileImageURL);
  //       });
  //     });

  //     testWidgets(
  //         'When rendering non-moderator, anon participant use the provided gradient and anon profile image',
  //         (WidgetTester tester) async {
  //       await tester.pumpWidget(MaterialApp(
  //           home: Container(
  //               child: DiscussionPost(
  //                   key: widgetKey,
  //                   discussion: discussionAsAnon,
  //                   index: 0,
  //                   isLocalPost: false))));
  //       final profileImageContainer = tester.firstWidget<Container>(
  //           find.byKey(Key('${widgetKey.toString()}-profile-image-container')));
  //       expect(
  //           profileImageContainer.constraints,
  //           BoxConstraints(
  //               minWidth: 36.0,
  //               maxWidth: 36.0,
  //               minHeight: 36.0,
  //               maxHeight: 36.0));
  //       final decoration = profileImageContainer.decoration as BoxDecoration;
  //       expect(decoration.shape, BoxShape.circle);
  //       expect(
  //           decoration.gradient, ChathamColors.gradients[GradientName.TAUPE]);
  //       expect(decoration.border,
  //           Border.all(color: Colors.transparent, width: 1.0));
  //       expect(profileImageContainer.child.runtimeType, AnonProfileImage);
  //     });
  //   });

  //   group('Content Column', () {
  //     testWidgets(
  //         'When rendering content it should show a column with a title and the text',
  //         (WidgetTester tester) async {
  //       await tester.pumpWidget(MaterialApp(
  //           home: Container(
  //               child: DiscussionPost(
  //                   key: widgetKey,
  //                   discussion: discussionAsAnon,
  //                   index: 0,
  //                   isLocalPost: false))));

  //       final contentColumn = tester.firstWidget<Column>(
  //           find.byKey(Key('${widgetKey.toString()}-content-column')));
  //       expect(contentColumn.mainAxisAlignment, MainAxisAlignment.start);
  //       expect(contentColumn.crossAxisAlignment, CrossAxisAlignment.start);
  //       expect(contentColumn.children.length, 2);
  //       expect(contentColumn.children[0].runtimeType, PostTitle);
  //       expect(contentColumn.children[1].runtimeType, Container);

  //       final postTitleWidget = contentColumn.children[0] as PostTitle;
  //       expect(postTitleWidget.moderator, discussionAsAnon.moderator);
  //       expect(postTitleWidget.participant,
  //           discussionAsAnon.getParticipantForPostIdx(0));
  //       // Not sure if we should assert heights / widths yet.
  //       expect(postTitleWidget.height, 20.0);

  //       final postContentContainerParent =
  //           contentColumn.children[1] as Container;
  //       expect(postContentContainerParent.child.runtimeType, Column);
  //       expect((postContentContainerParent.child as Column).children.length, 1);
  //       final postContentContainer =
  //           ((postContentContainerParent.child) as Column).children[0]
  //               as Container;
  //       expect(postContentContainer.child.runtimeType, Text);
  //       expect((postContentContainer.child as Text).data,
  //           discussionAsAnon.postsCache[0].content);
  //     });
  //   });
  // });
}
