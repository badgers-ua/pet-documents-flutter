extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension RequiredValidator on String {
  String? requiredValidator({required String fieldName}) {
    if (this.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return this.length > 5 && this.length < 21;
  }
}

extension BearerTokenFormatter on String {
  String toBearerToken() {
    return 'Bearer $this';
  }
}
