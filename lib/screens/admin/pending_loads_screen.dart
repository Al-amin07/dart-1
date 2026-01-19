import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/load_provider.dart';
import '../../widgets/load_card.dart';
import 'assign_load_screen.dart';

class PendingLoadsScreen extends StatefulWidget {
  const PendingLoadsScreen({super.key});

  @override
  State<PendingLoadsScreen> createState() => _PendingLoadsScreenState();
}

class _PendingLoadsScreenState extends State<PendingLoadsScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    loadProvider.fetchAllLoads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Loads'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LoadProvider>(
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

          final pendingLoads = loadProvider.loads
              .where((load) => load.status == 'pending')
              .toList();

          if (pendingLoads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: Colors.green[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No pending loads to assign',
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
              itemCount: pendingLoads.length,
              itemBuilder: (context, index) {
                final load = pendingLoads[index];
                return LoadCard(
                  load: load,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssignLoadScreen(load: load),
                      ),
                    ).then((_) => _loadData());
                  },
                  trailing: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AssignLoadScreen(load: load),
                        ),
                      ).then((_) => _loadData());
                    },
                    icon: const Icon(Icons.assignment, size: 18),
                    label: const Text('Assign'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}