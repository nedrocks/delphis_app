part of 'link_bloc.dart';

abstract class LinkState extends Equatable {
  const LinkState();
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
