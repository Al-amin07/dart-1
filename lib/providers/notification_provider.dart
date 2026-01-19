import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';

class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNotifications(String userId, {bool? isRead}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getUserNotifications(userId, isRead: isRead);
      if (response['success']) {
        _notifications = (response['data'] as List)
            .map((json) => AppNotification.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnreadCount(String userId) async {
    try {
      final response = await _apiService.getUnreadCount(userId);
      if (response['success']) {
        _unreadCount = response['data']['unreadCount'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail for unread count
    }
  }

  Future<bool> markAsRead(String notificationId, String userId) async {
    try {
      final response = await _apiService.markNotificationAsRead(notificationId, userId);
      if (response['success']) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = AppNotification.fromJson(response['data']);
          _unreadCount = (_unreadCount - 1).clamp(0, 999);
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    return false;
  }

  Future<bool> markAllAsRead(String userId) async {
    try {
      final response = await _apiService.markAllNotificationsAsRead(userId);
      if (response['success']) {
        for (var i = 0; i < _notifications.length; i++) {
          _notifications[i] = AppNotification(
            id: _notifications[i].id,
            userId: _notifications[i].userId,
            title: _notifications[i].title,
            message: _notifications[i].message,
            type: _notifications[i].type,
            relatedLoadId: _notifications[i].relatedLoadId,
            relatedLoadNumber: _notifications[i].relatedLoadNumber,
            relatedDriverId: _notifications[i].relatedDriverId,
            isRead: true,
            createdAt: _notifications[i].createdAt,
          );
        }
        _unreadCount = 0;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    return false;
  }

  Future<bool> deleteNotification(String notificationId, String userId) async {
    try {
      final response = await _apiService.deleteNotification(notificationId, userId);
      if (response['success']) {
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
    return false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}