class TFirebaseAuthException implements Exception {
  final String code;

  TFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case "email-already-in-use":
        return "The email address is already registered. Please use a different email.";
      case "invalid-email":
        return 'The email address provided is invalid. Please enter a valid email.';
      case "weak-password":
        return 'The password is too weak. Please choose a stronger password.';
      case 'user-disabled':
        return "This user account has been disabled. Please contact support for assistance.";
      case 'user-not-found':
        return 'Invalid login details. User not found.';
      case 'wrong-password':
        return "Incorrect Password.";
      case 'invalid-verification-code':
        return 'Invalid Verification Code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please request a new verification code.';
      case 'quota-exceeded':
        return 'Quota exceeded. Please try again later.';
      case 'email-already-exists':
        return 'The email address already exists. Please use a different email.';
      case 'provider-already-linked':
        return 'The account is already linked with another provider.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again.';
      default:
        return 'Something went wrong.';
    }
    
  }
}
