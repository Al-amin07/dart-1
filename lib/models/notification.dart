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
    return AppNotification(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? json['user'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      relatedLoadId: json['relatedLoad']?['_id'],
      relatedLoadNumber: json['relatedLoad']?['loadNumber'],
      relatedDriverId: json['relatedDriver']?['_id'],
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