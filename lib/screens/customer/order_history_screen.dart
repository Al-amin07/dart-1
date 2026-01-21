import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/load_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/load_card.dart';
import 'load_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      loadProvider.fetchLoadsByCustomer(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Delivered', 'delivered'),
                  const SizedBox(width: 8),
                  _buildFilterChip('In Transit', 'in-transit'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelled', 'cancelled'),
                ],
              ),
            ),
          ),

          // Order List
          Expanded(
            child: Consumer<LoadProvider>(
              builder: (context, loadProvider, _) {
                if (loadProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (loadProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          loadProvider.error!,
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

                var loads = loadProvider.loads;
                
                // Filter loads
                if (_selectedFilter != 'all') {
                  loads = loads.where((load) => load.status == _selectedFilter).toList();
                }

                if (loads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == 'all' 
                              ? 'No orders yet' 
                              : 'No ${_selectedFilter} orders',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: loads.length,
                    itemBuilder: (context, index) {
                      return LoadCard(
                        load: loads[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoadDetailScreen(load: loads[index]),
                            ),
                          );
                        },
                      );
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Colors.purple,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}