import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/load.dart';
import '../../providers/load_provider.dart';
import '../../providers/auth_provider.dart';
import '../admin/assign_load_screen.dart';

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
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(load.loadNumber),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          if (load.status == 'pending' && authProvider.role == 'customer')
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

            // Admin Actions (Assign/Reassign Driver)
            if (isAdmin && (load.status == 'pending' || load.status == 'assigned'))
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          load.status == 'pending' 
                              ? Icons.assignment 
                              : Icons.swap_horiz,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            load.status == 'pending'
                                ? 'This load needs to be assigned'
                                : 'You can reassign this load',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AssignLoadScreen(load: load),
                          ),
                        ).then((_) {
                          // Refresh the load data when returning
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[700],
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            load.status == 'pending' 
                                ? Icons.person_add 
                                : Icons.swap_horiz,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            load.status == 'pending'
                                ? 'Assign Driver & Vehicle'
                                : 'Reassign Driver & Vehicle',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Assigned Driver',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isAdmin && load.status == 'assigned')
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AssignLoadScreen(load: load),
                                ),
                              ).then((_) {
                                Navigator.pop(context);
                              });
                            },
                            icon: const Icon(Icons.swap_horiz, size: 18),
                            label: const Text('Change'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                      ],
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
                            radius: 30,
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.person, size: 32, color: Colors.green[700]),
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
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (load.vehicleNumber != null)
                                  Row(
                                    children: [
                                      Icon(Icons.directions_car, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Vehicle: ${load.vehicleNumber}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          if (!isAdmin)
                            IconButton(
                              icon: const Icon(Icons.phone, color: Colors.green),
                              onPressed: () {
                                // Call driver functionality
                              },
                            ),
                        ],
                      ),
                    ),
                  ],

                  // Customer Info (for admin view)
                  if (isAdmin) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple[100],
                            child: Icon(Icons.person, size: 32, color: Colors.purple[700]),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  load.customerName ?? 'Customer',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Customer ID: ${load.customerId}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
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