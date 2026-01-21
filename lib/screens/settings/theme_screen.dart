import 'package:flutter/material.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildThemeTile(
            'Light',
            'Bright and clean interface',
            Icons.light_mode,
            Colors.amber,
          ),
          _buildThemeTile(
            'Dark',
            'Easy on the eyes at night',
            Icons.dark_mode,
            Colors.indigo,
          ),
          _buildThemeTile(
            'System',
            'Match your device settings',
            Icons.settings_system_daydream,
            Colors.purple,
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Theme Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          _buildPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildThemeTile(String theme, String description, IconData icon, Color color) {
    final isSelected = _selectedTheme == theme;

    return RadioListTile<String>(
      value: theme,
      groupValue: _selectedTheme,
      onChanged: (value) {
        setState(() {
          _selectedTheme = value!;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Theme changed to $theme'),
            backgroundColor: Colors.green,
          ),
        );
      },
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(theme),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
      activeColor: Colors.purple,
      selected: isSelected,
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _selectedTheme == 'Dark' ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This is how your app will look',
            style: TextStyle(
              color: _selectedTheme == 'Dark' ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}