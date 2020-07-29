import 'package:delphis_app/bloc/create_chat/create_chat_bloc.dart';
import 'package:delphis_app/screens/create_chat/title_and_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChatScreen extends StatelessWidget {
  const CreateChatScreen() : super();

  @override
  Widget build(BuildContext context) {
    // TODO: Should this Bloc exist above this widget? If not we can be entirely
    // self contained. However it could lead to some annoyances of interacting
    // with it.
    return BlocProvider<CreateChatBloc>(
        create: (context) => CreateChatBloc(),
        child: BlocBuilder<CreateChatBloc, CreateChatState>(
            builder: (context, state) {
          if (state is CreateChatFlowNotActive) {
            // We start the flow here!
            BlocProvider.of<CreateChatBloc>(context)
                .add(StartCreateChatFlow(equatableID: DateTime.now()));
            return Container();
          }

          if (state is CreateChatFlowState) {
            switch (state.currentPage) {
              case CreateChatPage.TITLE_AND_DESCRIPTION:
                return CreateChatTitleAndDescriptionScreen();
              default:
                return Container();
            }
          }
          return Container();
        }));
  }
}
