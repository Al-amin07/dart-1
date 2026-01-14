import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../models/models.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  IconData _getVehicleIcon(String type) {
    switch (type) {
      case 'Van':
        return Icons.airport_shuttle;
      case 'Medium Truck':
        return Icons.local_shipping;
      case 'Heavy Truck':
        return Icons.fire_truck;
      case 'Refrigerated Truck':
        return Icons.ac_unit;
      default:
        return Icons.directions_car;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = StaticData.getVehicles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getVehicleIcon(vehicle.type),
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vehicle.type,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecCard(
                        Icons.scale,
                        'Max Weight',
                        '${vehicle.maxWeight} kg',
                      ),
                      _buildSpecCard(
                        Icons.attach_money,
                        'Price/km',
                        '৳${vehicle.pricePerKm}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showBookingDialog(context, vehicle);
                      },
                      icon: const Icon(Icons.bookmark),
                      label: const Text('Book Vehicle'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book ${vehicle.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vehicle Type: ${vehicle.type}'),
              const SizedBox(height: 8),
              Text('Max Weight: ${vehicle.maxWeight} kg'),
              const SizedBox(height: 8),
              Text('Price: ৳${vehicle.pricePerKm} per km'),
              const SizedBox(height: 16),
              const Text(
                'Booking feature coming soon!',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking feature coming soon')),
                );
              },
              child: const Text('Book Now'),
            ),
          ],
        );
      },
    );
  }
}