import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Contact Us'),
          _buildContactTile(
            'Email Support',
            'support@deliveryapp.com',
            Icons.email,
            Colors.blue,
            () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'support@deliveryapp.com',
                query: 'subject=Support Request',
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
            },
          ),
          _buildContactTile(
            'Phone Support',
            '+1 (800) 123-4567',
            Icons.phone,
            Colors.green,
            () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: '+18001234567');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              }
            },
          ),
          _buildContactTile(
            'Live Chat',
            'Chat with our support team',
            Icons.chat,
            Colors.orange,
            () {
              // Open live chat
            },
          ),
          const Divider(height: 32),
          _buildSectionHeader('FAQs'),
          _buildFAQTile(
            'How do I track my order?',
            'Go to the Track Order section in the app to see real-time updates on your delivery.',
          ),
          _buildFAQTile(
            'How do I cancel an order?',
            'You can cancel pending orders from the order details page before a driver is assigned.',
          ),
          _buildFAQTile(
            'What payment methods are accepted?',
            'We accept credit cards, debit cards, and digital wallets.',
          ),
          _buildFAQTile(
            'How do I become a driver?',
            'Contact our admin team to register as a driver with your license and vehicle details.',
          ),
          const Divider(height: 32),
          _buildSectionHeader('Resources'),
          _buildResourceTile(
            'Terms of Service',
            Icons.description,
            () {},
          ),
          _buildResourceTile(
            'Privacy Policy',
            Icons.privacy_tip,
            () {},
          ),
          _buildResourceTile(
            'Community Guidelines',
            Icons.people,
            () {},
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

  Widget _buildContactTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return ExpansionTile(
      leading: const Icon(Icons.help_outline, color: Colors.purple),
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}