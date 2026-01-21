import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
    {'name': 'Spanish', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'French', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'German', 'code': 'de', 'flag': '🇩🇪'},
    {'name': 'Chinese', 'code': 'zh', 'flag': '🇨🇳'},
    {'name': 'Japanese', 'code': 'ja', 'flag': '🇯🇵'},
    {'name': 'Arabic', 'code': 'ar', 'flag': '🇸🇦'},
    {'name': 'Hindi', 'code': 'hi', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final language = _languages[index];
          final isSelected = _selectedLanguage == language['name'];

          return RadioListTile<String>(
            value: language['name']!,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Language changed to ${language['name']}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            title: Row(
              children: [
                Text(
                  language['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Text(language['name']!),
              ],
            ),
            activeColor: Colors.purple,
            selected: isSelected,
          );
        },
      ),
    );
  }
}