import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Theme state
  ThemeMode _currentThemeMode = ThemeMode.light;
  Color _primaryColor = Colors.blue;
  final List<Color> _availableColors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  void _logout() {
    _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No new notifications'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _currentThemeMode = _currentThemeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  void _changePrimaryColor(Color newColor) {
    setState(() {
      _primaryColor = newColor;
    });
  }

  void _showThemeOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Theme Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Theme Mode Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Theme Mode', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _currentThemeMode == ThemeMode.dark,
                    onChanged: (value) {
                      setState(() {
                        _currentThemeMode = value
                            ? ThemeMode.dark
                            : ThemeMode.light;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: _primaryColor,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                'Primary Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              // Color Selection Grid
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableColors.length,
                  itemBuilder: (context, index) {
                    final color = _availableColors[index];
                    return GestureDetector(
                      onTap: () {
                        _changePrimaryColor(color);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: _primaryColor == color
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _primaryColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToFeature(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName - Coming Soon!'),
        duration: const Duration(seconds: 2),
        backgroundColor: _primaryColor,
      ),
    );
  }

  // Custom theme data based on user selection
  ThemeData get _lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.light(primary: _primaryColor),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(primary: _primaryColor),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return MaterialApp(
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _currentThemeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            // Theme Settings Button
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: _showThemeOptions,
              tooltip: 'Theme Settings',
            ),
            // Theme Toggle Button
            IconButton(
              icon: Icon(
                _currentThemeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
            // Notifications Button
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: _showNotifications,
              tooltip: 'Notifications',
            ),
            // Logout Button
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section with Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Welcome Icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.waving_hand,
                              size: 32,
                              color: _primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Welcome Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.fullName ?? 'User',
                                  style: TextStyle(
                                    fontSize: 24, // Reduced from 28
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ready to make today amazing!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Reduced from 32
                // Current Theme Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12), // Reduced padding
                    child: Row(
                      children: [
                        Icon(
                          _currentThemeMode == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: _primaryColor,
                          size: 20, // Smaller icon
                        ),
                        const SizedBox(width: 8), // Reduced spacing
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Theme: ${_currentThemeMode == ThemeMode.dark ? 'Dark' : 'Light'}',
                                style: const TextStyle(
                                  fontSize: 14, // Smaller font
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Color: ${_primaryColor.value.toRadixString(16).toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 10, // Smaller font
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            _currentThemeMode == ThemeMode.dark
                                ? 'DARK'
                                : 'LIGHT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10, // Smaller font
                            ),
                          ),
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ), // Less padding
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Features Grid with constrained height
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12, // Reduced spacing
                      mainAxisSpacing: 12, // Reduced spacing
                      childAspectRatio: 1.1, // Slightly more compact
                      shrinkWrap: true, // Important for SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // Important for SingleChildScrollView
                      children: [
                        // Daily Motivational Quote
                        _FeatureCard(
                          icon: Icons.psychology,
                          title: 'Daily Motivational\nQuote',
                          color: _primaryColor,
                          onTap: () =>
                              _navigateToFeature('Daily Motivational Quote'),
                        ),

                        // AI-generated daily tasks
                        _FeatureCard(
                          icon: Icons.auto_awesome,
                          title: 'AI-generated\nDaily Tasks',
                          color: _primaryColor,
                          onTap: () =>
                              _navigateToFeature('AI-generated Daily Tasks'),
                        ),

                        // Mood tracker
                        _FeatureCard(
                          icon: Icons.sentiment_satisfied_alt,
                          title: 'Mood\nTracker',
                          color: _primaryColor,
                          onTap: () => _navigateToFeature('Mood Tracker'),
                        ),

                        // Streak tracker
                        _FeatureCard(
                          icon: Icons.local_fire_department,
                          title: 'Streak\nTracker',
                          color: _primaryColor,
                          onTap: () => _navigateToFeature('Streak Tracker'),
                        ),

                        // Calendar reminders
                        _FeatureCard(
                          icon: Icons.calendar_today,
                          title: 'Calendar\nReminders',
                          color: _primaryColor,
                          onTap: () => _navigateToFeature('Calendar Reminders'),
                        ),

                        // AI chat
                        _FeatureCard(
                          icon: Icons.chat,
                          title: 'AI Chat\nAssistant',
                          color: _primaryColor,
                          onTap: () => _navigateToFeature('AI Chat'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Add some bottom padding for better scrolling
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showThemeOptions,
          backgroundColor: _primaryColor,
          child: const Icon(Icons.palette, color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Feature Card Widget - Made more compact
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Slightly smaller radius
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon - Smaller
              Container(
                padding: const EdgeInsets.all(10), // Reduced padding
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28, // Smaller icon
                  color: color,
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14, // Smaller font
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
