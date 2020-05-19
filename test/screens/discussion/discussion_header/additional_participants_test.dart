import 'dart:math';

import 'package:delphis_app/design/text_theme.dart';
import 'package:delphis_app/screens/discussion/discussion_header/additional_pariticipants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_objects.dart';

void main() {
  final widgetKey = Key('additional_participants_key');
  final discussionAsAnon = TestObjects.getDiscussion1(asAnonymous: true);
  group('AdditionalParticipants', () {
    testWidgets('With 0 additional, an empty container should be returned',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Container(
              child: AdditionalParticipants(
                  key: widgetKey, diameter: 10.0, numAdditional: 0))));

      final containerObj = tester.firstWidget<Container>(
          find.byKey(Key('${widgetKey.toString()}-participant-container')));
      expect(
          containerObj.constraints, BoxConstraints(maxWidth: 0, maxHeight: 0));
    });

    testWidgets('With 0 <= additional participants < 100',
        (WidgetTester tester) async {
      final numAdditional = Random().nextInt(100);
      await tester.pumpWidget(MaterialApp(
          home: Container(
              child: AdditionalParticipants(
                  key: widgetKey,
                  diameter: 10.0,
                  numAdditional: numAdditional))));

      final containerObj = tester.firstWidget<Container>(
          find.byKey(Key('${widgetKey.toString()}-participant-container')));
      expect(
          containerObj.constraints,
          BoxConstraints(
              maxWidth: 10.0,
              maxHeight: 10.0,
              minWidth: 10.0,
              minHeight: 10.0));
      expect((containerObj.decoration as BoxDecoration).shape, BoxShape.circle);
      expect(containerObj.child.runtimeType, RichText);
      final richText = containerObj.child as RichText;
      expect(richText.text.runtimeType, TextSpan);
      final textSpan = richText.text as TextSpan;
      expect(textSpan.children.length, 2);
      expect((textSpan.children[0] as TextSpan).text, '+');
      expect((textSpan.children[0] as TextSpan).style,
          TextThemes.discussionAdditionalParticipantsPlusSign);
      expect((textSpan.children[1] as TextSpan).text, numAdditional.toString());
      expect((textSpan.children[1] as TextSpan).style,
          TextThemes.discussionAdditionalParticipants);
    });

    testWidgets('With >= 100 participants', (WidgetTester tester) async {
      // Should be minimum 100.
      final numAdditional = Random().nextInt(100) + 100;
      await tester.pumpWidget(MaterialApp(
          home: Container(
              child: AdditionalParticipants(
                  key: widgetKey,
                  diameter: 10.0,
                  numAdditional: numAdditional))));

      final richText = tester.firstWidget<RichText>(find.byType(RichText));
      final textSpans = (richText.text as TextSpan).children;
      bool found = false;
      for (int i = 0; i < textSpans.length; i++) {
        final currTextSpan = textSpans[i] as TextSpan;
        if (currTextSpan.style == TextThemes.discussionAdditionalParticipants) {
          found = true;
          expect(currTextSpan.text, '99');
        }
      }
      expect(found, true);
    });
  });
}
