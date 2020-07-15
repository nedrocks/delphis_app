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

  static get uploadImageUrl {
    return _config[_Config.UPLOAD_IMAGE_URL];
  }

  static get gqlEndpoint {
    return _config[_Config.GQL_ENDPOINT];
  }

  static get wsEndpoint {
    return _config[_Config.WS_ENDPOINT];
  }

  static get appleAuthLoginEndpoint {
    return _config[_Config.APPLE_AUTH_LOGIN_ENDPOINT];
  }
}

class _Config {
  static const TWITTER_REDIRECT_URL_PREFIX = "redirect-url-prefix";
  static const TWITTER_LOGIN_URL = "login-url";
  static const UPLOAD_IMAGE_URL = "upload-image";
  static const GQL_ENDPOINT = "gql-endpoint";
  static const WS_ENDPOINT = "ws-endpoint";
  static const APPLE_AUTH_LOGIN_ENDPOINT = "apple-auth-login-endpoint";

  static Map<String, dynamic> debugConstants = {
    TWITTER_REDIRECT_URL_PREFIX: "delphis-chatham://local.delphishq.com:8000/",
    TWITTER_LOGIN_URL: "http://localhost:8080/twitter/login",
    UPLOAD_IMAGE_URL: "http://localhost:8080/upload_image",
    GQL_ENDPOINT: "http://localhost:8080/query",
    WS_ENDPOINT: "ws://localhost:8080/query",
    APPLE_AUTH_LOGIN_ENDPOINT: "http://localhost:8080/apple/authLogin",
  };

  static Map<String, dynamic> stagingConstants = {
    TWITTER_REDIRECT_URL_PREFIX: "delphis-chatham://app-staging.delphishq.com",
    TWITTER_LOGIN_URL: "https://staging.delphishq.com/twitter/login",
    UPLOAD_IMAGE_URL: "https://staging.delphishq.com/upload_image",
    GQL_ENDPOINT: "https://staging.delphishq.com/query",
    WS_ENDPOINT: "wss://staging.delphishq.com/query",
    APPLE_AUTH_LOGIN_ENDPOINT: "https://stating.delphishq.com/apple/authLogin",
  };
}
