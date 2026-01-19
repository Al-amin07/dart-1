import 'package:flutter/material.dart';
import '../models/driver.dart';
import '../services/api_service.dart';

class DriverProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Driver> _drivers = [];
  Driver? _selectedDriver;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _stats;

  List<Driver> get drivers => _drivers;
  Driver? get selectedDriver => _selectedDriver;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get stats => _stats;

  List<Driver> get availableDrivers =>
      _drivers.where((d) => d.status == 'available').toList();

  Future<void> fetchAllDrivers({Map<String, String>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAllDrivers(queryParams: filters);
      if (response['success']) {
        _drivers = (response['data'] as List)
            .map((json) => Driver.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAvailableDrivers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAvailableDrivers();
      if (response['success']) {
        _drivers = (response['data'] as List)
            .map((json) => Driver.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDriverById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getDriverById(id);
      if (response['success']) {
        _selectedDriver = Driver.fromJson(response['data']);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDriverByUserId(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getDriverByUserId(userId);
      if (response['success']) {
        _selectedDriver = Driver.fromJson(response['data']);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _selectedDriver = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDriverProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createDriverProfile(data);
      if (response['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updateDriver(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateDriver(id, data);
      if (response['success']) {
        _selectedDriver = Driver.fromJson(response['data']);
        final index = _drivers.indexWhere((driver) => driver.id == id);
        if (index != -1) {
          _drivers[index] = _selectedDriver!;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updateDriverStatus(String id, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateDriverStatus(id, status);
      if (response['success']) {
        final driver = Driver.fromJson(response['data']);
        final index = _drivers.indexWhere((d) => d.id == id);
        if (index != -1) {
          _drivers[index] = driver;
        }
        if (_selectedDriver?.id == id) {
          _selectedDriver = driver;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> fetchDriverStats(String id) async {
    try {
      final response = await _apiService.getDriverStats(id);
      if (response['success']) {
        _stats = response['data'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}