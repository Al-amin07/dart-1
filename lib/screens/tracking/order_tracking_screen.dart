import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/load.dart';
import '../../providers/load_provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Load load;

  const OrderTrackingScreen({super.key, required this.load});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track ${widget.load.loadNumber}'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Placeholder
            Container(
              height: 300,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'Map View',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Real-time tracking coming soon',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  // Current Location Pin
                  Positioned(
                    top: 120,
                    left: MediaQuery.of(context).size.width / 2 - 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Status Timeline
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTimeline(),
                ],
              ),
            ),

            // Load Details
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
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
                  const Text(
                    'Load Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Load Number', widget.load.loadNumber),
                  _buildDetailRow('Description', widget.load.description),
                  _buildDetailRow('Weight', '${widget.load.weight} kg'),
                  _buildDetailRow('Expected Delivery', widget.load.formattedDeliveryDate),
                ],
              ),
            ),

            // Driver Info (if assigned)
            if (widget.load.driverName != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.green[500]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30, color: Colors.green[700]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Driver',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.load.driverName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.load.vehicleNumber != null)
                            Text(
                              'Vehicle: ${widget.load.vehicleNumber}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Call driver
                          },
                          icon: const Icon(Icons.phone, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed: () {
                            // Message driver
                          },
                          icon: const Icon(Icons.message, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final statuses = [
      {'status': 'pending', 'label': 'Order Placed', 'icon': Icons.shopping_bag},
      {'status': 'assigned', 'label': 'Driver Assigned', 'icon': Icons.person},
      {'status': 'in-transit', 'label': 'In Transit', 'icon': Icons.local_shipping},
      {'status': 'delivered', 'label': 'Delivered', 'icon': Icons.check_circle},
    ];

    int currentIndex = statuses.indexWhere((s) => s['status'] == widget.load.status);
    if (currentIndex == -1) currentIndex = 0;

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    status['icon'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    color: index < currentIndex ? Colors.green : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['label'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? Colors.black : Colors.grey,
                    ),
                  ),
                  if (isCurrent)
                    Text(
                      'Current Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}