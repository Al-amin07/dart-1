class Driver {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String licenseNumber;
  final DateTime licenseExpiry;
  final String phone;
  final String address;
  final EmergencyContact emergencyContact;
  final String status;
  final double rating;
  final int totalDeliveries;
  final String? currentVehicleId;
  final String? currentVehicleNumber;

  Driver({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.licenseNumber,
    required this.licenseExpiry,
    required this.phone,
    required this.address,
    required this.emergencyContact,
    required this.status,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.currentVehicleId,
    this.currentVehicleNumber,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? json['user'] ?? '',
      userName: json['user']?['name'] ?? '',
      userEmail: json['user']?['email'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      licenseExpiry: DateTime.parse(json['licenseExpiry']),
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      emergencyContact: EmergencyContact.fromJson(json['emergencyContact'] ?? {}),
      status: json['status'] ?? 'available',
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalDeliveries: json['totalDeliveries'] ?? 0,
      currentVehicleId: json['currentVehicle']?['_id'],
      currentVehicleNumber: json['currentVehicle']?['vehicleNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'licenseNumber': licenseNumber,
      'licenseExpiry': licenseExpiry.toIso8601String(),
      'phone': phone,
      'address': address,
      'emergencyContact': emergencyContact.toJson(),
      'status': status,
    };
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relation;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      relation: json['relation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'relation': relation,
    };
  }
}