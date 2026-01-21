import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'settings/notification_settings_screen.dart';
import 'settings/edit_profile_screen.dart';
import 'settings/change_password_screen.dart';
import 'settings/language_screen.dart';
import 'settings/theme_screen.dart';
import 'settings/help_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: _getThemeColor(authProvider.role),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getThemeColor(authProvider.role),
                    _getThemeColor(authProvider.role).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      _getRoleIcon(authProvider.role),
                      size: 50,
                      color: _getThemeColor(authProvider.role),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      authProvider.role.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Account Settings
            _buildSection(
              context,
              'Account Settings',
              [
                _buildListTile(
                  context,
                  Icons.person,
                  'Edit Profile',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  Icons.lock,
                  'Change Password',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  Icons.notifications,
                  'Notifications',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // App Settings
            _buildSection(
              context,
              'App Settings',
              [
                _buildListTile(
                  context,
                  Icons.language,
                  'Language',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LanguageScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  Icons.dark_mode,
                  'Theme',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ThemeScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  Icons.help,
                  'Help & Support',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  Icons.info,
                  'About',
                  () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context, authProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App Version
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Color _getThemeColor(String role) {
    switch (role) {
      case 'driver':
        return Colors.green;
      case 'customer':
        return Colors.purple;
      case 'admin':
      default:
        return Colors.blue;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'driver':
        return Icons.local_shipping;
      case 'customer':
        return Icons.person;
      case 'admin':
      default:
        return Icons.admin_panel_settings;
    }
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Management System',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'A comprehensive delivery management solution for customers, drivers, and administrators.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}