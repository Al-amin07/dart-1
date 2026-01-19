import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/load.dart';
import '../../providers/load_provider.dart';

class LoadDetailScreen extends StatelessWidget {
  final Load load;

  const LoadDetailScreen({super.key, required this.load});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.blue;
      case 'assigned':
        return Colors.purple;
      case 'in-transit':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'in-transit':
        return 'In Transit';
      default:
        return status[0].toUpperCase() + status.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(load.loadNumber),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          if (load.status == 'pending')
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(20),
              color: _getStatusColor(load.status).withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(load.status),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(load.status),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusLabel(load.status),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(load.status),
                          ),
                        ),
                        Text(
                          'Created on ${load.formattedCreatedAt}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Load Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Load Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Description', load.description),
                  _buildDetailRow('Weight', '${load.weight} kg'),
                  _buildDetailRow('Category', load.category[0].toUpperCase() + load.category.substring(1)),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Pickup Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Address', load.pickupAddress),
                  _buildDetailRow('Date', load.formattedPickupDate),
                  if (load.pickupTime != null)
                    _buildDetailRow('Time', load.pickupTime!),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Delivery Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Address', load.deliveryAddress),
                  _buildDetailRow('Date', load.formattedDeliveryDate),
                  if (load.deliveryTime != null)
                    _buildDetailRow('Time', load.deliveryTime!),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Cost & Payment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Estimated Cost', '\$${load.estimatedCost.toStringAsFixed(2)}'),
                  if (load.actualCost != null)
                    _buildDetailRow('Actual Cost', '\$${load.actualCost!.toStringAsFixed(2)}'),
                  _buildDetailRow('Payment Status', load.paymentStatus[0].toUpperCase() + load.paymentStatus.substring(1)),
                  
                  if (load.specialInstructions != null && load.specialInstructions!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Special Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(load.specialInstructions!),
                    ),
                  ],
                  
                  if (load.driverName != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Assigned Driver',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.person, color: Colors.green[700]),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  load.driverName!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (load.vehicleNumber != null)
                                  Text(
                                    'Vehicle: ${load.vehicleNumber}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'assigned':
        return Icons.assignment;
      case 'in-transit':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final loadProvider = Provider.of<LoadProvider>(context, listen: false);
              final success = await loadProvider.deleteLoad(load.id);
              
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order cancelled successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (context.mounted && loadProvider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loadProvider.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}