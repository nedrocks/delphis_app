part of 'link_bloc.dart';

abstract class LinkState extends Equatable {
  const LinkState();
}

class EmptyLinkState extends LinkState {
  final DateTime nonce;

  EmptyLinkState() : nonce = DateTime.now();

  @override
  List<Object> get props => [nonce];
}

class ExternalLinkState extends LinkState {
  final String link;
  final DateTime nonce;

  ExternalLinkState({
    this.link,
    this.nonce,
  }) : super();

  @override
  List<Object> get props => [link, nonce];
}
