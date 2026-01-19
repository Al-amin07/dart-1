import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Assumes you have your Driver and EmergencyContact models imported

class DriverProfilePage extends StatelessWidget {
  final Driver driver;

  const DriverProfilePage({Key? key, required this.driver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatusCard(),
            _buildPersonalInfo(),
            _buildLicenseInfo(),
            _buildEmergencyContact(),
            _buildStatsCard(),
            if (driver.currentVehicleNumber != null) _buildVehicleInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              driver.userName.isNotEmpty ? driver.userName[0].toUpperCase() : 'D',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            driver.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            driver.userEmail,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                driver.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getStatusColor(driver.status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Status: ${_getStatusDisplayName(driver.status)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Show status change dialog
              },
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _buildSection(
      'Personal Information',
      [
        _buildInfoRow(Icons.phone, 'Phone', driver.phone),
        _buildInfoRow(Icons.location_on, 'Address', driver.address),
        _buildInfoRow(Icons.badge, 'Driver ID', driver.id),
      ],
    );
  }

  Widget _buildLicenseInfo() {
    final isExpired = driver.licenseExpiry.isBefore(DateTime.now());
    final daysUntilExpiry = driver.licenseExpiry.difference(DateTime.now()).inDays;
    
    return _buildSection(
      'License Information',
      [
        _buildInfoRow(Icons.badge, 'License Number', driver.licenseNumber),
        _buildInfoRow(
          Icons.event,
          'Expiry Date',
          _formatDate(driver.licenseExpiry),
          trailing: isExpired
              ? const Chip(
                  label: Text('Expired', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                )
              : daysUntilExpiry < 30
                  ? Chip(
                      label: Text('${daysUntilExpiry}d left', style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                    )
                  : null,
        ),
      ],
    );
  }

  Widget _buildEmergencyContact() {
    return _buildSection(
      'Emergency Contact',
      [
        _buildInfoRow(Icons.person, 'Name', driver.emergencyContact.name),
        _buildInfoRow(Icons.phone, 'Phone', driver.emergencyContact.phone),
        _buildInfoRow(Icons.family_restroom, 'Relation', driver.emergencyContact.relation),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.local_shipping,
                  'Deliveries',
                  driver.totalDeliveries.toString(),
                  Colors.blue,
                ),
                _buildStatItem(
                  Icons.star,
                  'Rating',
                  driver.rating.toStringAsFixed(1),
                  Colors.amber,
                ),
                _buildStatItem(
                  Icons.check_circle,
                  'Status',
                  _getStatusDisplayName(driver.status),
                  _getStatusColor(driver.status),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return _buildSection(
      'Current Vehicle',
      [
        _buildInfoRow(
          Icons.directions_car,
          'Vehicle Number',
          driver.currentVehicleNumber ?? 'Not assigned',
        ),
        if (driver.currentVehicleId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to vehicle details
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('View Vehicle Details'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'on-duty':
        return Colors.blue;
      case 'off-duty':
        return Colors.grey;
      case 'on-leave':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'available':
        return 'Available';
      case 'on-duty':
        return 'On Duty';
      case 'off-duty':
        return 'Off Duty';
      case 'on-leave':
        return 'On Leave';
      default:
        return status;
    }
  }
}