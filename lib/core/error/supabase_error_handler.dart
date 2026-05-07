import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized error handler for Supabase-related exceptions.
/// Maps technical error codes and messages to user-friendly strings.
class SupabaseErrorHandler {
  /// Handles any error and returns a user-friendly message.
  static String handle(dynamic error) {
    if (error is AuthException) {
      return _handleAuthException(error);
    } else if (error is PostgrestException) {
      return _handlePostgrestException(error);
    } else if (error is StorageException) {
      return _handleStorageException(error);
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static String _handleAuthException(AuthException error) {
    // Specifically handle the database saving error mentioned by the user
    if (error.message.contains('Database error saving new user')) {
      return 'We encountered a problem creating your account. This usually '
          'happens if the username is already taken or there is a server '
          'configuration issue. Please try a different username or '
          'contact support.';
    }

    switch (error.code) {
      case 'user_already_exists':
        return 'This email is already registered. Try signing in instead.';
      case 'invalid_credentials':
        return 'Invalid email or password. Please check your credentials and '
            'try again.';
      case 'over_email_send_rate_limit':
        return 'Too many requests. Please wait a few minutes before '
            'trying again.';
      case 'email_not_confirmed':
        return 'Please verify your email address. Check your inbox for a '
            'confirmation link.';
      case 'network_error':
        return 'Network error. Please check your internet connection.';
      case 'signup_disabled':
        return 'Sign up is currently disabled. Please contact support.';
      case 'bad_code_verifier':
        return 'Authentication session expired. Please try signing in again.';
      case 'unexpected_failure':
        return 'A server error occurred during authentication. Please '
            'try again later.';
      default:
        // Return original message if no specific mapping exists
        return error.message;
    }
  }

  static String _handlePostgrestException(PostgrestException error) {
    switch (error.code) {
      case '23505': // unique_violation
        return 'This record already exists.';
      case '23503': // foreign_key_violation
        return 'This operation is not allowed because of related data.';
      case '42P01': // undefined_table
        return 'A database configuration error occurred. Please '
            'contact support.';
      case 'PGRST116': // single() but no rows or multiple rows
        return 'The requested record was not found.';
      case '42501': // insufficient_privilege
        return 'You do not have permission to perform this action.';
      default:
        return 'Database error: ${error.message}';
    }
  }

  static String _handleStorageException(StorageException error) {
    return 'Storage error: ${error.message}';
  }
}
