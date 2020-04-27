part of 'gql_bloc.dart';

abstract class GqlState extends Equatable {
  const GqlState();
}

class GqlInitial extends GqlState {
  @override
  List<Object> get props => [];
}
