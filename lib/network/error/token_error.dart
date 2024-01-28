class TokenError {
  String error;
  StackTrace stackTrace;

  TokenError(this.error,this.stackTrace);

  @override
  String toString() {
    return error ?? "Token invalidate!";
  }
}
