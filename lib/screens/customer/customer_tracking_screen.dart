import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/load_provider.dart';

class CustomerTrackingScreen extends StatefulWidget {
  const CustomerTrackingScreen({super.key});

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
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
        title: const Text('Track Orders'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LoadProvider>(
        builder: (context, loadProvider, _) {
          if (loadProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeLoads = loadProvider.loads
              .where((load) => ['assigned', 'in-transit'].contains(load.status))
              .toList();

          if (activeLoads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No active deliveries to track',
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
              itemCount: activeLoads.length,
              itemBuilder: (context, index) {
                final load = activeLoads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              load.loadNumber,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: load.status == 'in-transit'
                                    ? Colors.orange[100]
                                    : Colors.blue[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                load.status == 'in-transit'
                                    ? 'In Transit'
                                    : 'Assigned',
                                style: TextStyle(
                                  color: load.status == 'in-transit'
                                      ? Colors.orange[700]
                                      : Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Timeline
                        _buildTimeline(load),
                        const SizedBox(height: 16),
                        // Driver Info
                        if (load.driverName != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green[100],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.green[700],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Driver',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        load.driverName!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  color: Colors.green,
                                  onPressed: () {
                                    // Call driver
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
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

  Widget _buildTimeline(load) {
    return Column(
      children: [
        _buildTimelineItem(
          'Pickup',
          load.pickupAddress,
          true,
          load.status == 'in-transit' || load.status == 'delivered',
        ),
        _buildTimelineConnector(
          load.status == 'in-transit' || load.status == 'delivered',
        ),
        _buildTimelineItem(
          'In Transit',
          'On the way',
          load.status == 'in-transit',
          load.status == 'delivered',
        ),
        _buildTimelineConnector(load.status == 'delivered'),
        _buildTimelineItem(
          'Delivery',
          load.deliveryAddress,
          load.status == 'delivered',
          false,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    bool isActive,
    bool isCompleted,
  ) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : isActive
                        ? Colors.orange
                        : Colors.grey[300],
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCompleted || isActive ? Colors.black : Colors.grey,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector(bool isActive) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 24,
          alignment: Alignment.center,
          child: Container(
            width: 2,
            height: 24,
            color: isActive ? Colors.green : Colors.grey[300],
          ),
        ),
      ],
    );
  }
}