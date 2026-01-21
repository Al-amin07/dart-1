import 'package:intl/intl.dart';

class Driver {
  final String id;
  final String userId;
  final String userName;
  final String licenseNumber;
  final DateTime licenseExpiry;
  final String contactNumber;
  final String address;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactRelation;
  final String status;
  final double rating;
  final int totalDeliveries;
  final DateTime createdAt;

  Driver({
    required this.id,
    required this.userId,
    required this.userName,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.contactNumber,
    required this.address,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactRelation,
    required this.status,
    required this.rating,
    required this.totalDeliveries,
    required this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    // Handle user field which can be either string or object
    String userIdValue;
    String userNameValue = 'Unknown';
    
    if (json['user'] is String) {
      userIdValue = json['user'];
    } else if (json['user'] is Map) {
      userIdValue = json['user']['_id'] ?? '';
      userNameValue = json['user']['name'] ?? 'Unknown';
    } else {
      userIdValue = '';
    }

    return Driver(
      id: json['_id'] ?? '',
      userId: userIdValue,
      userName: userNameValue,
      licenseNumber: json['licenseNumber'] ?? '',
      licenseExpiry: DateTime.parse(json['licenseExpiry'] ?? DateTime.now().toIso8601String()),
      contactNumber: json['contactNumber'] ?? '',
      address: json['address'] ?? '',
      emergencyContactName: json['emergencyContact']?['name'] ?? '',
      emergencyContactPhone: json['emergencyContact']?['phone'] ?? '',
      emergencyContactRelation: json['emergencyContact']?['relation'] ?? '',
      status: json['status'] ?? 'available',
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalDeliveries: json['totalDeliveries'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'licenseNumber': licenseNumber,
      'licenseExpiry': licenseExpiry.toIso8601String(),
      'contactNumber': contactNumber,
      'address': address,
      'emergencyContact': {
        'name': emergencyContactName,
        'phone': emergencyContactPhone,
        'relation': emergencyContactRelation,
      },
      'status': status,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedLicenseExpiry {
    return DateFormat('MMM dd, yyyy').format(licenseExpiry);
  }

  String get formattedCreatedAt {
    return DateFormat('MMM dd, yyyy').format(createdAt);
  }

  bool get isLicenseExpiring {
    final daysUntilExpiry = licenseExpiry.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
  }

  bool get isLicenseExpired {
    return licenseExpiry.isBefore(DateTime.now());
  }
}