import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delphis_app/constants.dart';
import 'package:delphis_app/data/repository/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DelphisAuthRepository repository;
  StreamSubscription _deepLinkSubscription;

  AuthBloc(this.repository) : super(LoggedOutAuthState()) {
    _deepLinkSubscription =
        getLinksStream().listen(this._handleLinkToken, onError: (err) {
      throw err;
    });
  }

  @override
  Future<void> close() {
    _deepLinkSubscription?.cancel();
    return super.close();
  }

  void _handleLinkToken(String link) {
    /* Check for Twitter auth token */
    if (link.startsWith(Constants.twitterRedirectURLPrefix) ||
        link.startsWith(Constants.twitterRedirectLegacyURLPrefix)) {
      String token = RegExp("\\?dc=(.*)").firstMatch(link)?.group(1) ?? null;
      if (token != null) {
        this.add(SetTokenAuthEvent(token));
      }
    }
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    var thisState = this.state;
    if (event is SetTokenAuthEvent) {
      await closeWebView();
      this.repository.authString = event.token;
      yield SignedInAuthState(event.token, true);
    } else if (event is TwitterSignInAuthEvent) {
      yield LoadingAuthState();
      try {
        var url = Constants.twitterLoginURL;
        if (await canLaunch(url)) {
          /* This is needed when the user first signs in with Apple, and then with
             Twitter.*/
          if (thisState is SignedInAuthState) {
            await launch(url,
                headers: {"Authorization": "Bearer ${thisState.authString}"});
          } else {
            await launch(url);
          }
        } else {
          throw 'Could not launch $url';
        }
      } catch (err) {
        yield ErrorAuthState(err);
      }
    } else if (event is AppleSignInAuthEvent) {
      /* TODO: This event is unhandled because all the Apple authentication
         flow is encoded the SignInWithAppleButton widget.
         This is not the best practice but it serves its purpose for now, future
         refactorings will need to encode the Apple auth flow in this BLoC too.
      */
    } else if (event is LocalSignInAuthEvent) {
      yield LoadingAuthState();
      final isAuthed = await this.repository.loadFromStorage();
      if (isAuthed) {
        yield SignedInAuthState(this.repository.authString, true);
      } else {
        yield LoggedOutAuthState();
      }
    } else if (event is LogoutAuthEvent) {
      yield LoadingAuthState();
      await this.repository.logout();
      yield LoggedOutAuthState();
    }
  }
}
