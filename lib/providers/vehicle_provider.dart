import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class VehicleProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Vehicle> get availableVehicles =>
      _vehicles.where((v) => v.status == 'available').toList();

  Future<void> fetchAllVehicles({Map<String, String>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAllVehicles(queryParams: filters);
      if (response['success']) {
        _vehicles = (response['data'] as List)
            .map((json) => Vehicle.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAvailableVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAvailableVehicles();
      if (response['success']) {
        _vehicles = (response['data'] as List)
            .map((json) => Vehicle.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getVehicleById(id);
      if (response['success']) {
        _selectedVehicle = Vehicle.fromJson(response['data']);
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createVehicle(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createVehicle(data);
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

  Future<bool> updateVehicle(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.updateVehicle(id, data);
      if (response['success']) {
        _selectedVehicle = Vehicle.fromJson(response['data']);
        final index = _vehicles.indexWhere((vehicle) => vehicle.id == id);
        if (index != -1) {
          _vehicles[index] = _selectedVehicle!;
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

  Future<bool> deleteVehicle(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.deleteVehicle(id);
      if (response['success']) {
        _vehicles.removeWhere((vehicle) => vehicle.id == id);
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

  Future<bool> assignDriverToVehicle(String vehicleId, String driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.assignDriverToVehicle(vehicleId, driverId);
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}