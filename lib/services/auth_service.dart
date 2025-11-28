import '../models/user.dart';

class AuthService {
  // Mock user database
  final List<User> _mockUsers = [
    User(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'hiree@gmail.com',
      workType: 'Private',
    ),
    User(
      id: '2',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane@example.com',
      workType: 'Government',
    ),
  ];

  User? _currentUser;

  User? get currentUser => _currentUser;

  // Mock login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    final user = _mockUsers.firstWhere(
      (user) => user.email == email,
      orElse: () =>
          User(id: '', firstName: '', lastName: '', email: '', workType: ''),
    );

    if (user.id.isNotEmpty && password == 'password123') {
      // Mock password
      _currentUser = user;
      return true;
    }
    return false;
  }

  // Mock create account
  Future<bool> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String workType,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Check if email already exists
    if (_mockUsers.any((user) => user.email == email)) {
      return false;
    }

    // Create new user
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      workType: workType,
    );

    _mockUsers.add(newUser);
    _currentUser = newUser;
    return true;
  }

  // Mock logout
  void logout() {
    _currentUser = null;
  }
}
