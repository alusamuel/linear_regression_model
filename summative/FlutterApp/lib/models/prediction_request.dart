class PredictionRequest {
  const PredictionRequest({
    required this.cgpa,
    required this.internships,
    required this.placed,
  });

  final double cgpa;
  final int internships;
  final String placed;

  Map<String, dynamic> toJson() {
    return {
      'cgpa': cgpa,
      'internships': internships,
      'placed': placed,
    };
  }
}
