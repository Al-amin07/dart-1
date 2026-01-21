import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/auth_provider.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  String _selectedPeriod = 'week';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      driverProvider.fetchDriverByUserId(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<DriverProvider>(
        builder: (context, driverProvider, _) {
          final driver = driverProvider.selectedDriver;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Total Earnings Card
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[500]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Earnings',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\$2,450.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildEarningStat('Deliveries', '${driver?.totalDeliveries ?? 0}'),
                          Container(width: 1, height: 30, color: Colors.white30),
                          _buildEarningStat('Rating', '${driver?.rating ?? 5.0} ⭐'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Period Selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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

                const SizedBox(height: 20),

                // Earnings Breakdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Earnings Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBreakdownCard('Base Fare', '\$1,800.00', Colors.blue),
                      _buildBreakdownCard('Tips', '\$450.00', Colors.amber),
                      _buildBreakdownCard('Bonuses', '\$200.00', Colors.purple),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Recent Transactions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTransactionTile('Delivery #LOAD-1001', '+\$45.00', 'Jan 20, 2026'),
                      _buildTransactionTile('Delivery #LOAD-1002', '+\$38.50', 'Jan 20, 2026'),
                      _buildTransactionTile('Bonus Payment', '+\$50.00', 'Jan 19, 2026'),
                      _buildTransactionTile('Delivery #LOAD-0998', '+\$42.00', 'Jan 19, 2026'),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEarningStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
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
        selectedColor: Colors.green,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(String label, String amount, Color color) {
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.attach_money, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(String title, String amount, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_upward, color: Colors.green[700], size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}