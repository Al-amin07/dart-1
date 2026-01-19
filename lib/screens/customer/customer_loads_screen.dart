import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/load_provider.dart';
import '../../models/load.dart';
import '../../widgets/load_card.dart';
import 'create_load_screen.dart';
import 'load_detail_screen.dart';

class CustomerLoadsScreen extends StatefulWidget {
  const CustomerLoadsScreen({super.key});

  @override
  State<CustomerLoadsScreen> createState() => _CustomerLoadsScreenState();
}

class _CustomerLoadsScreenState extends State<CustomerLoadsScreen> {
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

  List<Load> _filterLoads(List<Load> loads) {
    if (_selectedFilter == 'all') return loads;
    return loads.where((load) => load.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateLoadScreen()),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  _buildFilterChip('Pending', 'pending'),
                  _buildFilterChip('Assigned', 'assigned'),
                  _buildFilterChip('In Transit', 'in-transit'),
                  _buildFilterChip('Delivered', 'delivered'),
                ],
              ),
            ),
          ),
          // Loads List
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

                final filteredLoads = _filterLoads(loadProvider.loads);

                if (filteredLoads.isEmpty) {
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
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreateLoadScreen(),
                              ),
                            ).then((_) => _loadData());
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Order'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
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
                    itemCount: filteredLoads.length,
                    itemBuilder: (context, index) {
                      return LoadCard(
                        load: filteredLoads[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoadDetailScreen(
                                load: filteredLoads[index],
                              ),
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
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedColor: Colors.purple,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}