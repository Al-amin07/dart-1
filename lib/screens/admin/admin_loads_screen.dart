import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/load_provider.dart';
import '../../models/load.dart';
import '../../widgets/load_card.dart';
import '../customer/load_detail_screen.dart';
import 'assign_load_screen.dart';

class AdminLoadsScreen extends StatefulWidget {
  const AdminLoadsScreen({super.key});

  @override
  State<AdminLoadsScreen> createState() => _AdminLoadsScreenState();
}

class _AdminLoadsScreenState extends State<AdminLoadsScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    loadProvider.fetchAllLoads();
  }

  List<Load> _filterLoads(List<Load> loads) {
    if (_selectedFilter == 'all') return loads;
    return loads.where((load) => load.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Loads'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                  _buildFilterChip('Cancelled', 'cancelled'),
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
                              ? 'No loads available'
                              : 'No ${_selectedFilter} loads',
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
                    itemCount: filteredLoads.length,
                    itemBuilder: (context, index) {
                      final load = filteredLoads[index];
                      return LoadCard(
                        load: load,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoadDetailScreen(load: load),
                            ),
                          );
                        },
                        trailing: load.status == 'pending'
                            ? IconButton(
                                icon: const Icon(Icons.assignment),
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AssignLoadScreen(load: load),
                                    ),
                                  ).then((_) => _loadData());
                                },
                              )
                            : null,
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
        selectedColor: Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}