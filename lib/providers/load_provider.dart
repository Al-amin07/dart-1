import 'package:flutter/material.dart';
import '../models/load.dart';
import '../services/api_service.dart';

class LoadProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Load> _loads = [];
  Load? _selectedLoad;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _stats;

  List<Load> get loads => _loads;
  Load? get selectedLoad => _selectedLoad;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get stats => _stats;

  Future<void> fetchAllLoads({Map<String, String>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAllLoads(queryParams: filters);
      if (response['success']) {
        _loads = (response['data'] as List)
            .map((json) => Load.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLoadsByCustomer(String customerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getLoadsByCustomer(customerId);
      if (response['success']) {
        _loads = (response['data'] as List)
            .map((json) => Load.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLoadsByDriver(String driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getLoadsByDriver(driverId);
      if (response['success']) {
        _loads = (response['data'] as List)
            .map((json) => Load.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActiveLoadForDriver(String driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getActiveLoadForDriver(driverId);
      if (response['success'] && response['data'] != null) {
        _selectedLoad = Load.fromJson(response['data']);
      } else {
        _selectedLoad = null;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _selectedLoad = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLoadById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getLoadById(id);
      if (response['success']) {
        _selectedLoad = Load.fromJson(response['data']);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLoad(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createLoad(data);
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

  Future<bool> updateLoadStatus(String id, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateLoadStatus(id, status);
      if (response['success']) {
        _selectedLoad = Load.fromJson(response['data']);
        final index = _loads.indexWhere((load) => load.id == id);
        if (index != -1) {
          _loads[index] = _selectedLoad!;
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

  Future<bool> assignLoad(String loadId, String driverId, String vehicleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.assignLoad(loadId, driverId, vehicleId);
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

  Future<bool> deleteLoad(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.deleteLoad(id);
      if (response['success']) {
        _loads.removeWhere((load) => load.id == id);
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

  Future<void> fetchLoadStats() async {
    try {
      final response = await _apiService.getLoadStats();
      if (response['success']) {
        _stats = response['data'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> fetchCustomerStats(String customerId) async {
    try {
      final response = await _apiService.getCustomerStats(customerId);
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

  void setSelectedLoad(Load? load) {
    _selectedLoad = load;
    notifyListeners();
  }
}