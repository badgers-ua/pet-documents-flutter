class Auth {
  final String? accessToken;
  final String? refreshToken;
  final int expiresAt;
  final bool isAuthenticated;

  Auth({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.isAuthenticated = false,
  });
}