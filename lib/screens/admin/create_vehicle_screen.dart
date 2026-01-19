import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/vehicle_provider.dart';

class CreateVehicleScreen extends StatefulWidget {
  const CreateVehicleScreen({super.key});

  @override
  State<CreateVehicleScreen> createState() => _CreateVehicleScreenState();
}

class _CreateVehicleScreenState extends State<CreateVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _capacityController = TextEditingController();
  final _mileageController = TextEditingController();

  String _selectedVehicleType = 'truck';
  String _selectedFuelType = 'diesel';
  DateTime _registrationExpiry = DateTime.now().add(const Duration(days: 365));
  DateTime _insuranceExpiry = DateTime.now().add(const Duration(days: 365));

  final List<String> _vehicleTypes = ['truck', 'van', 'car', 'bike'];
  final List<String> _fuelTypes = ['petrol', 'diesel', 'electric', 'hybrid'];

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _capacityController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isRegistration) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isRegistration ? _registrationExpiry : _insuranceExpiry,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        if (isRegistration) {
          _registrationExpiry = picked;
        } else {
          _insuranceExpiry = picked;
        }
      });
    }
  }

  Future<void> _createVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);

    final vehicleData = {
      'vehicleNumber': _vehicleNumberController.text.trim(),
      'vehicleType': _selectedVehicleType,
      'model': _modelController.text.trim(),
      'year': int.parse(_yearController.text),
      'capacity': double.parse(_capacityController.text),
      'registrationExpiry': _registrationExpiry.toIso8601String(),
      'insuranceExpiry': _insuranceExpiry.toIso8601String(),
      'fuelType': _selectedFuelType,
      'mileage': _mileageController.text.isNotEmpty 
          ? double.parse(_mileageController.text) 
          : null,
      'status': 'available',
    };

    final success = await vehicleProvider.createVehicle(vehicleData);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted && vehicleProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vehicleProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vehicle'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, vehicleProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vehicle Number
                  TextFormField(
                    controller: _vehicleNumberController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Number',
                      prefixIcon: const Icon(Icons.confirmation_number),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'e.g., ABC-1234',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter vehicle number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Vehicle Type and Fuel Type Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedVehicleType,
                          decoration: InputDecoration(
                            labelText: 'Vehicle Type',
                            prefixIcon: const Icon(Icons.local_shipping),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _vehicleTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type[0].toUpperCase() + type.substring(1)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedVehicleType = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedFuelType,
                          decoration: InputDecoration(
                            labelText: 'Fuel Type',
                            prefixIcon: const Icon(Icons.local_gas_station),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: _fuelTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type[0].toUpperCase() + type.substring(1)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFuelType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Model
                  TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: 'Model',
                      prefixIcon: const Icon(Icons.directions_car),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'e.g., Ford F-150',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Year and Capacity Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _yearController,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final year = int.tryParse(value);
                            if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                              return 'Invalid year';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _capacityController,
                          decoration: InputDecoration(
                            labelText: 'Capacity (kg)',
                            prefixIcon: const Icon(Icons.scale),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mileage (Optional)
                  TextFormField(
                    controller: _mileageController,
                    decoration: InputDecoration(
                      labelText: 'Mileage (Optional)',
                      prefixIcon: const Icon(Icons.speed),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Current mileage in km',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Registration Expiry
                  const Text(
                    'Registration Expiry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(_registrationExpiry),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Insurance Expiry
                  const Text(
                    'Insurance Expiry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(_insuranceExpiry),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  ElevatedButton(
                    onPressed: vehicleProvider.isLoading ? null : _createVehicle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: vehicleProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Register Vehicle',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
}