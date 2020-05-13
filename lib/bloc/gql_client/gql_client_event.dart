part of 'gql_client_bloc.dart';

abstract class GqlClientEvent extends Equatable {
  const GqlClientEvent();
}

class GqlClientAuthChanged extends GqlClientEvent {
  final String authString;
  final bool isAuthed;

  const GqlClientAuthChanged({this.authString, @required this.isAuthed})
      : assert(!isAuthed || authString != null,
            "Cannot be authed wihtout auth string"),
        super();

  List<Object> get props => [this.authString, this.isAuthed];
}
