import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://akram-sir-backend.vercel.app/api'; // Android emulator
  // Use 'http://localhost:5000/api/v1' for iOS simulator
  // Use your actual IP for physical devices: 'http://192.168.x.x:5000/api/v1'

  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============ USER/AUTH ENDPOINTS ============
  
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // ============ LOAD ENDPOINTS ============
  
  Future<Map<String, dynamic>> createLoad(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loads'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAllLoads({Map<String, String>? queryParams}) async {
    var uri = Uri.parse('$baseUrl/loads');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(uri, headers: await _getHeaders());
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getLoadsByCustomer(String customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/loads/customer/$customerId'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getLoadsByDriver(String driverId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/loads/driver/$driverId'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getActiveLoadForDriver(String driverId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/loads/driver/$driverId/active'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getLoadById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/loads/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateLoadStatus(String id, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/loads/$id/status'),
      headers: await _getHeaders(),
      body: jsonEncode({'status': status}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> assignLoad(
    String loadId,
    String driverId,
    String vehicleId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loads/assign'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'loadId': loadId,
        'driverId': driverId,
        'vehicleId': vehicleId,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteLoad(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/loads/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getLoadStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/loads/stats'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getCustomerStats(String customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/loads/customer/$customerId/stats'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // ============ DRIVER ENDPOINTS ============
  
  Future<Map<String, dynamic>> createDriverProfile(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/drivers'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAllDrivers({Map<String, String>? queryParams}) async {
    var uri = Uri.parse('$baseUrl/drivers');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(uri, headers: await _getHeaders());
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAvailableDrivers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/available'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDriverById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDriverByUserId(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/user/$userId'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateDriver(String id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/drivers/$id'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateDriverStatus(String id, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/drivers/$id/status'),
      headers: await _getHeaders(),
      body: jsonEncode({'status': status}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDriverStats(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drivers/$id/stats'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // ============ VEHICLE ENDPOINTS ============
  
  Future<Map<String, dynamic>> createVehicle(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAllVehicles({Map<String, String>? queryParams}) async {
    var uri = Uri.parse('$baseUrl/vehicles');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(uri, headers: await _getHeaders());
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAvailableVehicles() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/available'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getVehicleById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateVehicle(String id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/vehicles/$id'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteVehicle(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/vehicles/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> assignDriverToVehicle(
    String vehicleId,
    String driverId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles/assign-driver'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'vehicleId': vehicleId,
        'driverId': driverId,
      }),
    );
    return _handleResponse(response);
  }

  // Helper method to handle responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'An error occurred');
      } catch (e) {
        throw Exception('Server error: ${response.statusCode}');
      }
    }
  }
}