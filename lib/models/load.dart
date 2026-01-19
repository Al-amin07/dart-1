import 'package:intl/intl.dart';

class Load {
  final String id;
  final String loadNumber;
  final String customerId;
  final String? customerName;
  final String? customerEmail;
  final String? driverId;
  final String? driverName;
  final String? vehicleId;
  final String? vehicleNumber;
  final String description;
  final double weight;
  final String category;
  final String pickupAddress;
  final DateTime pickupDate;
  final String? pickupTime;
  final String deliveryAddress;
  final DateTime deliveryDate;
  final String? deliveryTime;
  final String status;
  final double estimatedCost;
  final double? actualCost;
  final String paymentStatus;
  final String? specialInstructions;
  final List<String>? images;
  final DateTime? assignedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime createdAt;

  Load({
    required this.id,
    required this.loadNumber,
    required this.customerId,
    this.customerName,
    this.customerEmail,
    this.driverId,
    this.driverName,
    this.vehicleId,
    this.vehicleNumber,
    required this.description,
    required this.weight,
    required this.category,
    required this.pickupAddress,
    required this.pickupDate,
    this.pickupTime,
    required this.deliveryAddress,
    required this.deliveryDate,
    this.deliveryTime,
    required this.status,
    required this.estimatedCost,
    this.actualCost,
    required this.paymentStatus,
    this.specialInstructions,
    this.images,
    this.assignedAt,
    this.pickedUpAt,
    this.deliveredAt,
    required this.createdAt,
  });

  factory Load.fromJson(Map<String, dynamic> json) {
    // Helper function to safely extract customer ID
    String getCustomerId() {
      final customer = json['customer'];
      if (customer is String) {
        return customer;
      } else if (customer is Map<String, dynamic>) {
        return customer['_id']?.toString() ?? '';
      }
      return '';
    }

    // Helper function to safely extract customer name
    String? getCustomerName() {
      final customer = json['customer'];
      if (customer is Map<String, dynamic>) {
        return customer['name'];
      }
      return null;
    }

    // Helper function to safely extract customer email
    String? getCustomerEmail() {
      final customer = json['customer'];
      if (customer is Map<String, dynamic>) {
        return customer['email'];
      }
      return null;
    }

    // Helper function to safely extract driver ID
    String? getDriverId() {
      final driver = json['driver'];
      if (driver == null) return null;
      if (driver is String) {
        return driver;
      } else if (driver is Map<String, dynamic>) {
        return driver['_id']?.toString();
      }
      return null;
    }

    // Helper function to safely extract driver name
    String? getDriverName() {
      final driver = json['driver'];
      if (driver is Map<String, dynamic>) {
        return driver['name'];
      }
      return null;
    }

    // Helper function to safely extract vehicle ID
    String? getVehicleId() {
      final vehicle = json['vehicle'];
      if (vehicle == null) return null;
      if (vehicle is String) {
        return vehicle;
      } else if (vehicle is Map<String, dynamic>) {
        return vehicle['_id']?.toString();
      }
      return null;
    }

    // Helper function to safely extract vehicle number
    String? getVehicleNumber() {
      final vehicle = json['vehicle'];
      if (vehicle is Map<String, dynamic>) {
        return vehicle['vehicleNumber'];
      }
      return null;
    }

    return Load(
      id: json['_id']?.toString() ?? '',
      loadNumber: json['loadNumber'] ?? '',
      customerId: getCustomerId(),
      customerName: getCustomerName(),
      customerEmail: getCustomerEmail(),
      driverId: getDriverId(),
      driverName: getDriverName(),
      vehicleId: getVehicleId(),
      vehicleNumber: getVehicleNumber(),
      description: json['description'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      pickupAddress: json['pickupAddress'] ?? '',
      pickupDate: DateTime.parse(json['pickupDate']),
      pickupTime: json['pickupTime'],
      deliveryAddress: json['deliveryAddress'] ?? '',
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryTime: json['deliveryTime'],
      status: json['status'] ?? 'pending',
      estimatedCost: (json['estimatedCost'] ?? 0).toDouble(),
      actualCost: json['actualCost']?.toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      specialInstructions: json['specialInstructions'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      assignedAt: json['assignedAt'] != null ? DateTime.parse(json['assignedAt']) : null,
      pickedUpAt: json['pickedUpAt'] != null ? DateTime.parse(json['pickedUpAt']) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'description': description,
      'weight': weight,
      'category': category,
      'pickupAddress': pickupAddress,
      'pickupDate': pickupDate.toIso8601String(),
      'pickupTime': pickupTime,
      'deliveryAddress': deliveryAddress,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryTime': deliveryTime,
      'estimatedCost': estimatedCost,
      'specialInstructions': specialInstructions,
      'images': images,
    };
  }

  String get formattedPickupDate => DateFormat('MMM dd, yyyy').format(pickupDate);
  String get formattedDeliveryDate => DateFormat('MMM dd, yyyy').format(deliveryDate);
  String get formattedCreatedAt => DateFormat('MMM dd, yyyy').format(createdAt);
}