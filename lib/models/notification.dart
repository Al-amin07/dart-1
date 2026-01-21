class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final String? relatedLoadId;
  final String? relatedLoadNumber;
  final String? relatedDriverId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedLoadId,
    this.relatedLoadNumber,
    this.relatedDriverId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    // Handle user field which can be either string or object
    String userIdValue;
    if (json['user'] is String) {
      userIdValue = json['user'];
    } else if (json['user'] is Map) {
      userIdValue = json['user']['_id'] ?? '';
    } else {
      userIdValue = '';
    }

    // Handle relatedLoad field
    String? loadId;
    String? loadNumber;
    if (json['relatedLoad'] != null) {
      if (json['relatedLoad'] is String) {
        loadId = json['relatedLoad'];
      } else if (json['relatedLoad'] is Map) {
        loadId = json['relatedLoad']['_id'];
        loadNumber = json['relatedLoad']['loadNumber'];
      }
    }

    // Handle relatedDriver field
    String? driverId;
    if (json['relatedDriver'] != null) {
      if (json['relatedDriver'] is String) {
        driverId = json['relatedDriver'];
      } else if (json['relatedDriver'] is Map) {
        driverId = json['relatedDriver']['_id'];
      }
    }

    return AppNotification(
      id: json['_id'] ?? '',
      userId: userIdValue,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      relatedLoadId: loadId,
      relatedLoadNumber: loadNumber,
      relatedDriverId: driverId,
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}