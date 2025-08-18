class Validate {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email format';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
