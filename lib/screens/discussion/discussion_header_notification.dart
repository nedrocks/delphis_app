import 'package:delphis_app/bloc/discussion/discussion_bloc.dart';
import 'package:delphis_app/design/sizes.dart';
import 'package:delphis_app/design/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscussionHeaderNotification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DiscussionHeaderNotificationState();
}

class _DiscussionHeaderNotificationState
    extends State<DiscussionHeaderNotification> with TickerProviderStateMixin {
  Ticker _ticker;
  Duration _lastTick;
  DateTime _start;

  @override
  void initState() {
    this._lastTick = Duration(seconds: 0);
    this._ticker = createTicker(this.tick);
    this._ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    this._ticker.dispose();
    super.dispose();
  }

  void tick(Duration elapsed) {
    if (elapsed.inMilliseconds - this._lastTick.inMilliseconds >= 500) {
      setState(() {
        this._lastTick = elapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionBloc, DiscussionState>(
        builder: (context, state) {
      if (state is! DiscussionLoadedState) {
        if (this._ticker.isActive) {
          this._ticker.stop();
        }
        return Container();
      }

      final discussion = state.getDiscussion();
      if (discussion == null) {
        if (this._ticker.isActive) {
          this._ticker.stop();
        }
        return Container();
      }

      // We have 2 potential notifications: muted until and upcoming shuffle.
      if (discussion.meParticipant != null &&
          discussion.meParticipant.mutedUntil != null &&
          discussion.meParticipant.mutedUntil.isAfter(DateTime.now())) {
        if (!this._ticker.isActive) {
          this._ticker.start();
        }
        final delta =
            discussion.meParticipant.mutedUntil.difference(DateTime.now());
        final durationString =
            '${delta.inHours.toString().padLeft(2, '0')}:${delta.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(delta.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
        return Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromRGBO(151, 151, 151, 0.4))),
            color: Color.fromRGBO(87, 87, 95, 1.0),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: SpacingValues.medium,
              vertical: SpacingValues.extraSmall),
          width: double.infinity,
          child: Text(
            'You are muted for $durationString',
            style: TextThemes.discussionHeaderNotification,
          ),
        );
      }

      if (discussion.nextShuffleTime != null &&
          discussion.nextShuffleTime.isAfter(DateTime.now())) {
        if (!this._ticker.isActive) {
          this._ticker.start();
        }
        final delta = discussion.nextShuffleTime.difference(DateTime.now());
        final durationString =
            '${delta.inHours.toString().padLeft(2, '0')}:${delta.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(delta.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
        return Container(
          width: double.infinity,
          child: Text(
            'Next name shuffle in $durationString',
          ),
        );
      }

      if (this._ticker.isActive) {
        this._ticker.stop();
      }

      return Container();
    });
  }
}
