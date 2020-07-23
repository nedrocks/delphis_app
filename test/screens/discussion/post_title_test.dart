import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/post_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';

import '../../test_objects.dart';

void main() {
  // final moderatorParticipant = TestObjects.moderatorParticipant;
  // final moderator = TestObjects.moderator;
  // final moderatorUserProfile = TestObjects.moderatorUserProfile;
  // final noFlairParticipant = TestObjects.noFlairParticipant;
  // final participantWithFlair = TestObjects.participantWithFlair;
  // final flair = TestObjects.flair;
  // group('PostTitle tests', () {
  //   testWidgets('when participant ID is 0 the moderator title is shown',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(MaterialApp(
  //         home: Container(
  //             child: PostTitle(
  //                 height: 20.0,
  //                 participant: moderatorParticipant,
  //                 moderator: moderator))));

  //     final rowObj = tester.firstWidget<Row>(find.byType(Row));
  //     final textObj = tester.firstWidget<Text>(find.byType(Text));

  //     expect(textObj.data, moderatorUserProfile.displayName);
  //     expect(textObj.style, TextThemes.discussionPostAuthorNonAnon);

  //     expect(rowObj.crossAxisAlignment, CrossAxisAlignment.center);
  //     expect(rowObj.children.length, 3);
  //   });

  //   // NOTE: this will break once we start rendering non-anon correctly.
  //   // Update this to be for a non-anon.
  //   testWidgets('when participant ID is not 0 it shows the generated name',
  //       (WidgetTester tester) async {
  //     await tester.pumpWidget(MaterialApp(
  //         home: Container(
  //             child: PostTitle(
  //                 height: 20.0,
  //                 participant: noFlairParticipant,
  //                 moderator: moderator))));

  //     final rowObj = tester.firstWidget<Row>(find.byType(Row));
  //     final textObj = tester.firstWidget<Text>(find.byType(Text));

  //     expect(textObj.data,
  //         '${noFlairParticipant.gradientColor} #${noFlairParticipant.participantID}');
  //     expect(textObj.style, TextThemes.discussionPostAuthorAnon);

  //     expect(rowObj.crossAxisAlignment, CrossAxisAlignment.center);
  //     expect(rowObj.children.length, 3);
  //   });
  // });

  // group('PostTitleFlair tests', () {
  //   testWidgets('when flair is not set, empty flair object is shown',
  //       (WidgetTester tester) async {
  //     final widgetKey = Key('post-title-key');
  //     await tester.pumpWidget(MaterialApp(
  //         home: Container(
  //             child: PostTitle(
  //                 key: widgetKey,
  //                 height: 20.0,
  //                 participant: noFlairParticipant,
  //                 moderator: moderator))));

  //     final flairWidget = tester.firstWidget<PostTitleFlair>(
  //         find.byKey(Key('${widgetKey.toString()}-flair')));
  //     expect(flairWidget.flair, isNull);

  //     final emptyContainerWidget = tester.firstWidget<Container>(
  //         find.byKey(Key('${flairWidget.key.toString()}-empty-container')));
  //     expect(emptyContainerWidget, isNotNull);
  //     expect(emptyContainerWidget.constraints.widthConstraints(),
  //         BoxConstraints(maxWidth: 0));
  //   });

  //   testWidgets('when flair is set, it should render the flair',
  //       (WidgetTester tester) async {
  //     final widgetKey = Key('post-title-key');
  //     await provideMockedNetworkImages(() async {
  //       await tester.pumpWidget(MaterialApp(
  //           home: Container(
  //               child: PostTitle(
  //                   key: widgetKey,
  //                   height: 20.0,
  //                   participant: participantWithFlair,
  //                   moderator: moderator))));
  //     });

  //     final flairWidget = tester.firstWidget<PostTitleFlair>(
  //         find.byKey(Key('${widgetKey.toString()}-flair')));
  //     expect(flairWidget.flair, flair);

  //     final iconImageWidget = tester.firstWidget<Container>(
  //         find.byKey(Key('${flairWidget.key.toString()}-icon')));
  //     expect(
  //         iconImageWidget.decoration,
  //         BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           color: Colors.transparent,
  //           image: DecorationImage(
  //             fit: BoxFit.fill,
  //             alignment: Alignment.center,
  //             image: NetworkImage(flair.imageURL),
  //           ),
  //         ));
  //     final displayNameWidget = tester.firstWidget<Text>(
  //         find.byKey(Key('${flairWidget.key.toString()}-display-name')));
  //     expect(displayNameWidget.data, flair.displayName);
  //     expect(displayNameWidget.style, kThemeData.textTheme.headline3);
  //   });
  // });
}
