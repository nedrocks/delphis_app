enum Environment { DEV, STAGING }

class Constants {
  static Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.STAGING:
        _config = _Config.stagingConstants;
        break;
    }
  }

  // In order to get the auth JWT we need to ensure the redirect is sending
  // us to the correct place. This is the prefix for that URL.
  static get twitterRedirectURLPrefix {
    return _config[_Config.TWITTER_REDIRECT_URL_PREFIX];
  }

  static get twitterLoginURL {
    return _config[_Config.TWITTER_LOGIN_URL];
  }

  static get gqlEndpoint {
    return _config[_Config.GQL_ENDPOINT];
  }

}

class _Config {
  static const TWITTER_REDIRECT_URL_PREFIX = "redirect-url-prefix";
  static const TWITTER_LOGIN_URL = "login-url";
  static const GQL_ENDPOINT = "gql-endpoint";

  static Map<String, dynamic> debugConstants = {
    TWITTER_REDIRECT_URL_PREFIX: "http://local.delphishq.com:8000/",
    TWITTER_LOGIN_URL: "http://localhost:8080/twitter/login",
    GQL_ENDPOINT: "http://localhost:8080/query",
  };

  static Map<String, dynamic> stagingConstants = {
    TWITTER_REDIRECT_URL_PREFIX: "https://app-staging.delphishq.com",
    TWITTER_LOGIN_URL: "https://staging.delphishq.com/twitter/login",
    GQL_ENDPOINT: "https://staging.delphishq.com/query",
  };
}