import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/prediction_request.dart';
import '../models/prediction_response.dart';

class PredictionService {
  const PredictionService();

  Future<PredictionResponse> predict(PredictionRequest request) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/predict'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final responseBody = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return PredictionResponse.fromJson(responseBody);
    }

    final detail = responseBody['detail'];
    if (detail is String && detail.isNotEmpty) {
      throw PredictionException(detail);
    }

    throw const PredictionException(
      'Prediction failed. Check the input values and API status.',
    );
  }
}

class PredictionException implements Exception {
  const PredictionException(this.message);

  final String message;

  @override
  String toString() => message;
}
