import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared/constants.dart';
import '../services/logger.dart';

/// API Client — equivalent to React Native apiClient.ts (Axios)
class ApiClient {
  static final http.Client _client = http.Client();

  /// GET request with API key authentication
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? params,
  }) async {
    final queryParams = {
      'api_key': ApiConfig.apiKey,
      ...?params,
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
        .replace(queryParameters: queryParams);

    Logger.info('[API] GET $endpoint');

    try {
      final response = await _client
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(Duration(milliseconds: ApiConfig.timeout));

      Logger.info('[API] Response ${response.statusCode} $endpoint');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        Logger.error('[API] Error ${response.statusCode}: ${response.body}');
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Request failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      Logger.error('[API] Network error — $e');
      throw ApiException(statusCode: 0, message: 'Network error: $e');
    }
  }

  /// GET request with Bearer token authentication (for account endpoints)
  static Future<Map<String, dynamic>> getWithBearer(
    String endpoint, {
    Map<String, String>? params,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
        .replace(queryParameters: params);

    Logger.info('[AccountAPI] GET $endpoint');

    try {
      final response = await _client.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConfig.bearerToken}',
        'accept': 'application/json',
      }).timeout(Duration(milliseconds: ApiConfig.timeout));

      Logger.info('[AccountAPI] Response ${response.statusCode} $endpoint');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        Logger.error(
            '[AccountAPI] Error ${response.statusCode}: ${response.body}');
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Request failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      Logger.error('[AccountAPI] Network error — $e');
      throw ApiException(statusCode: 0, message: 'Network error: $e');
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
