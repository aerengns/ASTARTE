import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  invalidEmail,
  userNotFound,
  tooManyRequests,
  networkRequestFailed,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      case "network-request-failed":
        status = AuthStatus.networkRequestFailed;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.userNotFound:
        errorMessage = 'There is no user with the provided email address.';
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = 'The request has been rate-limited. Please try again later.';
        break;
      case AuthStatus.networkRequestFailed:
        errorMessage = 'A network error occurred while sending the email.';
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}