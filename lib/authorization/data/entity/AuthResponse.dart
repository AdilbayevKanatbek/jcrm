class AuthResponse {
  final String accessToken;
  final String tokenType;
  final String refreshToken;
  final num expireIn;
  final String scope;

  AuthResponse(
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expireIn,
    this.scope,
  );

  AuthResponse.fromJson(Map<String, dynamic> map)
      : accessToken = map['access_token'],
        tokenType = map['token_type'],
        refreshToken = map['refresh_token'],
        expireIn = map['expire_in'],
        scope = map['scope'];
}
