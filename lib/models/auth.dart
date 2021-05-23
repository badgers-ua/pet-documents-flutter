import 'package:pdoc/models/app_state.dart';

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

class AuthState extends AppState {
  final bool isLoadingAccessToken;
  final String errorMessageAccessToken;

  AuthState({
    this.isLoadingAccessToken = false,
    this.errorMessageAccessToken = '',
    bool isLoading = false,
    String errorMessage = '',
    Auth? data,
  }) : super(data: data, errorMessage: errorMessage, isLoading: isLoading);
}
