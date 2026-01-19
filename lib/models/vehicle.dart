class Vehicle {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final String model;
  final int year;
  final double capacity;
  final String? driverId;
  final String? driverName;
  final String status;
  final DateTime registrationExpiry;
  final DateTime insuranceExpiry;
  final String fuelType;
  final double? mileage;

  Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.model,
    required this.year,
    required this.capacity,
    this.driverId,
    this.driverName,
    required this.status,
    required this.registrationExpiry,
    required this.insuranceExpiry,
    required this.fuelType,
    this.mileage,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      capacity: (json['capacity'] ?? 0).toDouble(),
      driverId: json['driver']?['_id'],
      driverName: json['driver']?['name'],
      status: json['status'] ?? 'available',
      registrationExpiry: DateTime.parse(json['registrationExpiry']),
      insuranceExpiry: DateTime.parse(json['insuranceExpiry']),
      fuelType: json['fuelType'] ?? '',
      mileage: json['mileage']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'model': model,
      'year': year,
      'capacity': capacity,
      'driver': driverId,
      'status': status,
      'registrationExpiry': registrationExpiry.toIso8601String(),
      'insuranceExpiry': insuranceExpiry.toIso8601String(),
      'fuelType': fuelType,
      'mileage': mileage,
    };
  }
}