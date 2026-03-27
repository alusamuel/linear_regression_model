import 'package:flutter/material.dart';

import '../config.dart';
import '../models/prediction_request.dart';
import '../services/prediction_service.dart';
import '../widgets/prediction_form_card.dart';
import '../widgets/result_card.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _cgpaController = TextEditingController();
  final _internshipsController = TextEditingController();
  final _placedController = TextEditingController();
  final _predictionService = const PredictionService();

  String _message = 'Prediction results or validation errors will appear here.';
  bool _isError = false;
  bool _isLoading = false;
  double? _predictedSalary;
  double? _submittedCgpa;
  int? _submittedInternships;
  String? _submittedPlaced;
  String _salaryUnit = 'INR LPA';

  @override
  void dispose() {
    _cgpaController.dispose();
    _internshipsController.dispose();
    _placedController.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    FocusScope.of(context).unfocus();

    final cgpaText = _cgpaController.text.trim();
    final internshipsText = _internshipsController.text.trim();
    final placedText = _placedController.text.trim();

    if (cgpaText.isEmpty ||
        internshipsText.isEmpty ||
        placedText.isEmpty) {
      _showMessage(
        'Enter CGPA, internships, and placed status before predicting.',
        isError: true,
      );
      return;
    }

    final cgpa = double.tryParse(cgpaText);
    final internships = int.tryParse(internshipsText);

    if (cgpa == null || cgpa < 0 || cgpa > 10) {
      _showMessage('CGPA must be a number between 0 and 10.', isError: true);
      return;
    }

    if (internships == null || internships < 0 || internships > 10) {
      _showMessage(
        'Internships must be a whole number between 0 and 10.',
        isError: true,
      );
      return;
    }

    final normalizedPlaced = _normalizePlaced(
      placedText,
    );
    if (normalizedPlaced == null) {
      _showMessage(
        'Placed must be either "Yes" or "No".',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
      _predictedSalary = null;
    });

    try {
      final response = await _predictionService.predict(
        PredictionRequest(
          cgpa: cgpa,
          internships: internships,
          placed: normalizedPlaced,
        ),
      );

      _predictedSalary = response.predictedSalary;
      _submittedCgpa = cgpa;
      _submittedInternships = internships;
      _submittedPlaced = normalizedPlaced;
      _salaryUnit = response.salaryUnit;
      _showMessage(
        'Prediction completed successfully based on the submitted student profile.',
      );
    } on PredictionException catch (error) {
      _showMessage(error.message, isError: true);
    } catch (_) {
      _showMessage(
        'Could not reach the API. Check API_BASE_URL and ensure the server is running.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String value, {bool isError = false}) {
    setState(() {
      _message = value;
      _isError = isError;
      if (isError) {
        _predictedSalary = null;
      }
    });
  }

  String? _normalizePlaced(String rawValue) {
    final normalized = rawValue.trim().toLowerCase();
    if (normalized == 'yes' || normalized == 'placed') {
      return 'Yes';
    }
    if (normalized == 'no' || normalized == 'not placed') {
      return 'No';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDDF7F2), Color(0xFFF9FBFA), Color(0xFFF0F9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: PredictionFormCard(
                  cgpaController: _cgpaController,
                  internshipsController: _internshipsController,
                  placedController: _placedController,
                  isLoading: _isLoading,
                  onPredict: _predict,
                  apiEndpoint: '$apiBaseUrl/predict',
                  onPlacedSelected: (value) {
                    _placedController.text = value;
                  },
                  resultCard: ResultCard(
                    message: _message,
                    isError: _isError,
                    predictedSalary: _predictedSalary,
                    salaryUnit: _salaryUnit,
                    cgpa: _submittedCgpa,
                    internships: _submittedInternships,
                    placed: _submittedPlaced,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
