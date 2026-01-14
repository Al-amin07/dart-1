class Load {
  final String id;
  final String title;
  final String description;
  final String pickupLocation;
  final String deliveryLocation;
  final double weight;
  final String status;
  final DateTime pickupDate;
  final DateTime? deliveryDate;
  final double price;
  final String driverName;
  final String driverPhone;
  final String vehicleType;

  Load({
    required this.id,
    required this.title,
    required this.description,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.weight,
    required this.status,
    required this.pickupDate,
    this.deliveryDate,
    required this.price,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleType,
  });
}

class Driver {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehicleNumber;
  final double rating;
  final int totalDeliveries;
  final bool isAvailable;
  final String? currentLocation;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.rating,
    required this.totalDeliveries,
    required this.isAvailable,
    this.currentLocation,
  });
}

class Vehicle {
  final String id;
  final String type;
  final String name;
  final double maxWeight;
  final double pricePerKm;

  Vehicle({
    required this.id,
    required this.type,
    required this.name,
    required this.maxWeight,
    required this.pricePerKm,
  });
}