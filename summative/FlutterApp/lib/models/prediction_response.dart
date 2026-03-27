class PredictionResponse {
  const PredictionResponse({
    required this.predictedSalary,
    required this.salaryUnit,
    required this.modelPath,
  });

  final double predictedSalary;
  final String salaryUnit;
  final String modelPath;

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      predictedSalary: (json['predicted_salary'] as num).toDouble(),
      salaryUnit: json['salary_unit'] as String? ?? 'INR LPA',
      modelPath: json['model_path'] as String? ?? '',
    );
  }
}
