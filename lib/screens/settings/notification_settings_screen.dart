import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _driverUpdates = false;
  bool _systemUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Notification Channels'),
          _buildSwitchTile(
            'Push Notifications',
            'Receive push notifications on your device',
            Icons.notifications_active,
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
          _buildSwitchTile(
            'Email Notifications',
            'Receive notifications via email',
            Icons.email,
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
          ),
          _buildSwitchTile(
            'SMS Notifications',
            'Receive notifications via SMS',
            Icons.sms,
            _smsNotifications,
            (value) => setState(() => _smsNotifications = value),
          ),
          const Divider(height: 32),
          _buildSectionHeader('Notification Types'),
          _buildSwitchTile(
            'Order Updates',
            'Get notified about order status changes',
            Icons.shopping_bag,
            _orderUpdates,
            (value) => setState(() => _orderUpdates = value),
          ),
          _buildSwitchTile(
            'Promotions & Offers',
            'Receive special offers and promotions',
            Icons.local_offer,
            _promotions,
            (value) => setState(() => _promotions = value),
          ),
          _buildSwitchTile(
            'Driver Updates',
            'Get notified about driver assignments',
            Icons.local_shipping,
            _driverUpdates,
            (value) => setState(() => _driverUpdates = value),
          ),
          _buildSwitchTile(
            'System Updates',
            'Important system announcements',
            Icons.info,
            _systemUpdates,
            (value) => setState(() => _systemUpdates = value),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purple,
      ),
    );
  }
}