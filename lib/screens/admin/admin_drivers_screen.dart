import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/driver_provider.dart';
import '../../models/driver.dart';
import 'create_driver_profile_screen.dart';

class AdminDriversScreen extends StatefulWidget {
  const AdminDriversScreen({super.key});

  @override
  State<AdminDriversScreen> createState() => _AdminDriversScreenState();
}

class _AdminDriversScreenState extends State<AdminDriversScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    driverProvider.fetchAllDrivers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateDriverProfileScreen(),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search drivers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Status Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('Available', 'available', Colors.green),
                  const SizedBox(width: 8),
                  _buildFilterChip('On Duty', 'on-duty', Colors.blue),
                  const SizedBox(width: 8),
                  _buildFilterChip('Off Duty', 'off-duty', Colors.grey),
                  const SizedBox(width: 8),
                  _buildFilterChip('On Leave', 'on-leave', Colors.orange),
                ],
              ),
            ),
          ),

          // Stats Summary
          Consumer<DriverProvider>(
            builder: (context, driverProvider, _) {
              final allDrivers = driverProvider.drivers;
              final availableCount = allDrivers.where((d) => d.status == 'available').length;
              final onDutyCount = allDrivers.where((d) => d.status == 'on-duty').length;
              final offDutyCount = allDrivers.where((d) => d.status == 'off-duty').length;
              final onLeaveCount = allDrivers.where((d) => d.status == 'on-leave').length;

              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('Available', availableCount, Colors.green),
                    ),
                    Expanded(
                      child: _buildStatItem('On Duty', onDutyCount, Colors.blue),
                    ),
                    Expanded(
                      child: _buildStatItem('Off Duty', offDutyCount, Colors.grey),
                    ),
                    Expanded(
                      child: _buildStatItem('On Leave', onLeaveCount, Colors.orange),
                    ),
                  ],
                ),
              );
            },
          ),

          // Driver List
          Expanded(
            child: Consumer<DriverProvider>(
              builder: (context, driverProvider, _) {
                if (driverProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (driverProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          driverProvider.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                var drivers = driverProvider.drivers;

                // Apply status filter
                if (_selectedFilter != 'all') {
                  drivers = drivers.where((driver) => driver.status == _selectedFilter).toList();
                }

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  drivers = drivers.where((driver) {
                    return driver.userName.toLowerCase().contains(_searchQuery) ||
                        driver.licenseNumber.toLowerCase().contains(_searchQuery);
                  }).toList();
                }

                if (drivers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No drivers found'
                              : _selectedFilter == 'all'
                                  ? 'No drivers available'
                                  : 'No $_selectedFilter drivers',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_selectedFilter == 'all' && _searchQuery.isEmpty) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateDriverProfileScreen(),
                                ),
                              ).then((_) => _loadData());
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Driver'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      return _buildDriverCard(drivers[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, Color? color) {
    final isSelected = _selectedFilter == value;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (color != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showDriverDetails(driver);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: _getStatusColor(driver.status).withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: _getStatusColor(driver.status),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _getStatusColor(driver.status),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Driver Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'License: ${driver.licenseNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber[700]),
                            const SizedBox(width: 4),
                            Text(
                              '${driver.rating}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.local_shipping, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${driver.totalDeliveries} trips',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(driver.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(driver.status).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusLabel(driver.status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(driver.status),
                      ),
                    ),
                  ),
                ],
              ),

              // Additional Details
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.phone,
                        driver.contactNumber,
                        Colors.blue,
                      ),
                    ),
                    Container(width: 1, height: 30, color: Colors.grey[300]),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.calendar_today,
                        'Exp: ${driver.formattedLicenseExpiry}',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
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

  String _getStatusLabel(String status) {
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

  void _showDriverDetails(Driver driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Driver Avatar and Name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: _getStatusColor(driver.status).withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: _getStatusColor(driver.status),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          driver.userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _getStatusColor(driver.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusLabel(driver.status),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(driver.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Performance Stats
                  const Text(
                    'Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          Icons.star,
                          '${driver.rating}',
                          'Rating',
                          Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          Icons.local_shipping,
                          '${driver.totalDeliveries}',
                          'Deliveries',
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Contact Information
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.phone, 'Phone', driver.contactNumber),
                  _buildInfoRow(Icons.location_on, 'Address', driver.address),

                  const SizedBox(height: 24),

                  // License Information
                  const Text(
                    'License Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.credit_card, 'License Number', driver.licenseNumber),
                  _buildInfoRow(Icons.calendar_today, 'Expiry Date', driver.formattedLicenseExpiry),

                  const SizedBox(height: 24),

                  // Emergency Contact
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.person, 'Name', driver.emergencyContactName),
                  _buildInfoRow(Icons.phone, 'Phone', driver.emergencyContactPhone),
                  _buildInfoRow(Icons.people, 'Relation', driver.emergencyContactRelation),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Call driver
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // View loads
                          },
                          icon: const Icon(Icons.local_shipping),
                          label: const Text('View Loads'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}