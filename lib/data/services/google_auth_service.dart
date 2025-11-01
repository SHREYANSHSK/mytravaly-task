class GoogleAuthService {
  Future<Map<String, String>?> signInWithGoogle() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      return {
        'displayName': 'Demo User',
        'email': 'demo@example.com',
        'photoUrl': 'https://via.placeholder.com/150',
      };
    } catch (e) {
      throw Exception('Google Sign In failed: $e');
    }
  }

  Future<void> signOut() async {}
}