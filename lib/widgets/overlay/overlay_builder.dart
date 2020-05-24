import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChathamOverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Function(BuildContext) overlayBuilder;
  final Widget child;

  ChathamOverlayBuilder({
    @required this.overlayBuilder,
    this.showOverlay = false,
    this.child,
  }) : super();

  @override
  _ChathamOverlayBuilderState createState() => _ChathamOverlayBuilderState();
}

class _ChathamOverlayBuilderState extends State<ChathamOverlayBuilder> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      SchedulerBinding.instance.addPostFrameCallback((_) => this.showOverlay());
    }
  }

  bool isShowingOverlay() => this.overlayEntry != null;

  @override
  void didUpdateWidget(ChathamOverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance
        .addPostFrameCallback((_) => this.syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => this.syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (this.isShowingOverlay()) {
      this.hideOverlay();
    }

    super.dispose();
  }

  void showOverlay() {
    this.overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder,
    );
    this.addToOverlay(this.overlayEntry);
  }

  void addToOverlay(OverlayEntry entry) async {
    Overlay.of(this.context).insert(entry);
  }

  void hideOverlay() {
    this.overlayEntry.remove();
    this.overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (this.isShowingOverlay() && !this.widget.showOverlay) {
      this.hideOverlay();
    } else if (!this.isShowingOverlay() && this.widget.showOverlay) {
      this.showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.child ?? Container(width: 0, height: 0);
  }
}
