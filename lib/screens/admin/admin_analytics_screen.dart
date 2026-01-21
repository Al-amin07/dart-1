import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/load_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  String _selectedPeriod = 'month';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    
    loadProvider.fetchAllLoads();
    loadProvider.fetchLoadStats();
    driverProvider.fetchAllDrivers();
    vehicleProvider.fetchAllVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Period Selector
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _buildPeriodChip('Week', 'week'),
                    const SizedBox(width: 8),
                    _buildPeriodChip('Month', 'month'),
                    const SizedBox(width: 8),
                    _buildPeriodChip('Year', 'year'),
                  ],
                ),
              ),

              // Key Metrics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Metrics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<LoadProvider>(
                      builder: (context, loadProvider, _) {
                        final stats = loadProvider.stats;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricCard(
                                    'Total Revenue',
                                    '\$12,450',
                                    Icons.attach_money,
                                    Colors.green,
                                    '+12.5%',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildMetricCard(
                                    'Total Orders',
                                    '${stats?['total'] ?? 0}',
                                    Icons.shopping_bag,
                                    Colors.blue,
                                    '+8.2%',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricCard(
                                    'Active Drivers',
                                    '${stats?['activeDrivers'] ?? 0}',
                                    Icons.person,
                                    Colors.purple,
                                    '+3.1%',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildMetricCard(
                                    'Avg Delivery Time',
                                    '45 min',
                                    Icons.timer,
                                    Colors.orange,
                                    '-5.3%',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Performance Chart Placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(
                              'Chart View',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Performance charts coming soon',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Top Performers
              Consumer2<DriverProvider, LoadProvider>(
                builder: (context, driverProvider, loadProvider, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top Performers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPerformerCard(
                          'John Doe',
                          'Best Driver',
                          '150 deliveries',
                          Icons.stars,
                          Colors.amber,
                        ),
                        _buildPerformerCard(
                          'Customer ABC',
                          'Most Orders',
                          '45 orders',
                          Icons.shopping_bag,
                          Colors.blue,
                        ),
                        _buildPerformerCard(
                          'Mercedes Sprinter',
                          'Most Used Vehicle',
                          '120 trips',
                          Icons.local_shipping,
                          Colors.green,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    
    return Expanded(
      child: FilterChip(
        label: Center(child: Text(label)),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedPeriod = value;
          });
        },
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    final isPositive = change.startsWith('+');
    
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                size: 14,
                color: isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformerCard(
    String name,
    String title,
    String stat,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            stat,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}