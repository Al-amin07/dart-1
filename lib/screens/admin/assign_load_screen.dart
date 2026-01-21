import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/load.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/load_provider.dart';

class AssignLoadScreen extends StatefulWidget {
  final Load load;

  const AssignLoadScreen({super.key, required this.load});

  @override
  State<AssignLoadScreen> createState() => _AssignLoadScreenState();
}

class _AssignLoadScreenState extends State<AssignLoadScreen> {
  String? _selectedDriverId;
  String? _selectedVehicleId;
  bool _isReassigning = false;

  @override
  void initState() {
    super.initState();
    _isReassigning = widget.load.status == 'assigned';
    // Pre-select current driver and vehicle if reassigning
    if (_isReassigning) {
      _selectedDriverId = widget.load.driverId;
      _selectedVehicleId = widget.load.vehicleId;
    }
    _loadData();
  }

  void _loadData() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);
    
    driverProvider.fetchAvailableDrivers();
    vehicleProvider.fetchAvailableVehicles();
  }

  Future<void> _assignLoad() async {
    if (_selectedDriverId == null || _selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both driver and vehicle'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    
    final success = await loadProvider.assignLoad(
      widget.load.id,
      _selectedDriverId!,
      _selectedVehicleId!,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isReassigning 
              ? 'Load reassigned successfully!' 
              : 'Load assigned successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted && loadProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loadProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isReassigning ? 'Reassign Load' : 'Assign Load'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Load Info
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.load.loadNumber,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isReassigning)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.swap_horiz, 
                                  size: 16, 
                                  color: Colors.orange[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Reassigning',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.load.description} - ${widget.load.weight} kg',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${widget.load.pickupAddress} → ${widget.load.deliveryAddress}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_isReassigning && widget.load.driverName != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Currently Assigned To:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person, size: 16, color: Colors.grey[700]),
                              const SizedBox(width: 4),
                              Text(
                                widget.load.driverName!,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              if (widget.load.vehicleNumber != null) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.directions_car, size: 16, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Text(
                                  widget.load.vehicleNumber!,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Select Driver
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isReassigning ? 'Select New Driver' : 'Select Driver',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<DriverProvider>(
                    builder: (context, driverProvider, _) {
                      if (driverProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Get available drivers
                      var availableDrivers = driverProvider.drivers
                          .where((d) => d.status == 'available')
                          .toList();
                      
                      // If reassigning, also include the currently assigned driver
                      if (_isReassigning && widget.load.driverId != null) {
                        final currentDriver = driverProvider.drivers
                            .where((d) => d.userId == widget.load.driverId)
                            .firstOrNull;
                        if (currentDriver != null && 
                            !availableDrivers.any((d) => d.userId == currentDriver.userId)) {
                          availableDrivers.insert(0, currentDriver);
                        }
                      }

                      if (availableDrivers.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('No available drivers'),
                        );
                      }

                      return Column(
                        children: availableDrivers.map((driver) {
                          final isCurrentDriver = _isReassigning && 
                                                  driver.userId == widget.load.driverId;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: isCurrentDriver ? Colors.blue[50] : null,
                            child: RadioListTile<String>(
                              value: driver.userId,
                              groupValue: _selectedDriverId,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDriverId = value;
                                });
                              },
                              title: Row(
                                children: [
                                  Text(driver.userName),
                                  if (isCurrentDriver) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Current',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                'License: ${driver.licenseNumber} • Rating: ${driver.rating}⭐ • Deliveries: ${driver.totalDeliveries}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              secondary: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Icon(Icons.person, color: Colors.green[700]),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Select Vehicle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isReassigning ? 'Select New Vehicle' : 'Select Vehicle',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<VehicleProvider>(
                    builder: (context, vehicleProvider, _) {
                      if (vehicleProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Filter vehicles by capacity and availability
                      var suitableVehicles = vehicleProvider.vehicles
                          .where((v) => v.capacity >= widget.load.weight && v.status == 'available')
                          .toList();
                      
                      // If reassigning, also include the currently assigned vehicle
                      if (_isReassigning && widget.load.vehicleId != null) {
                        final currentVehicle = vehicleProvider.vehicles
                            .where((v) => v.id == widget.load.vehicleId)
                            .firstOrNull;
                        if (currentVehicle != null && 
                            !suitableVehicles.any((v) => v.id == currentVehicle.id)) {
                          suitableVehicles.insert(0, currentVehicle);
                        }
                      }

                      if (suitableVehicles.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange[700]),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'No vehicles with sufficient capacity available',
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: suitableVehicles.map((vehicle) {
                          final isCurrentVehicle = _isReassigning && 
                                                    vehicle.id == widget.load.vehicleId;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: isCurrentVehicle ? Colors.blue[50] : null,
                            child: RadioListTile<String>(
                              value: vehicle.id,
                              groupValue: _selectedVehicleId,
                              onChanged: (value) {
                                setState(() {
                                  _selectedVehicleId = value;
                                });
                              },
                              title: Row(
                                children: [
                                  Text('${vehicle.vehicleNumber} - ${vehicle.model}'),
                                  if (isCurrentVehicle) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Current',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                'Capacity: ${vehicle.capacity} kg • Type: ${vehicle.vehicleType} • Fuel: ${vehicle.fuelType}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              secondary: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                child: Icon(Icons.directions_car, color: Colors.blue[700]),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Assign Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Consumer<LoadProvider>(
                builder: (context, loadProvider, _) {
                  return ElevatedButton(
                    onPressed: loadProvider.isLoading ? null : _assignLoad,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loadProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _isReassigning ? 'Reassign Load' : 'Assign Load',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}