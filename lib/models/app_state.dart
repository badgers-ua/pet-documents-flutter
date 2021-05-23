class AppState<T> {
  final bool isLoading;
  final String errorMessage;
  final T? data;

  AppState({
    this.isLoading = false,
    this.errorMessage = '',
    this.data,
  });
}
