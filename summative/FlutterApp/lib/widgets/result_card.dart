import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.message,
    required this.isError,
    this.predictedSalary,
    this.salaryUnit,
    this.cgpa,
    this.internships,
    this.placed,
  });

  final String message;
  final bool isError;
  final double? predictedSalary;
  final String? salaryUnit;
  final double? cgpa;
  final int? internships;
  final String? placed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPrediction = !isError && predictedSalary != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isError
            ? const Color(0xFFFFF1F2)
            : const Color(0xFFEEF8F5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isError
              ? const Color(0xFFF4B7BE)
              : const Color(0xFFB8E0D6),
        ),
        boxShadow: hasPrediction
            ? const [
                BoxShadow(
                  color: Color(0x140F766E),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isError
                      ? const Color(0xFFFFDCE1)
                      : const Color(0xFFDDF7F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError ? Icons.error_outline : Icons.auto_graph,
                  color: isError
                      ? const Color(0xFFB42333)
                      : const Color(0xFF0F766E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isError ? 'Prediction Error' : 'Prediction Result',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF12312C),
                  ),
                ),
              ),
            ],
          ),
          if (hasPrediction) ...[
            const SizedBox(height: 18),
            Text(
              'Estimated Salary',
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFF2B6A5D),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${predictedSalary!.toStringAsFixed(2)} ${salaryUnit ?? 'INR LPA'}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF164E43),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (cgpa != null) _InfoChip(label: 'CGPA', value: cgpa!.toStringAsFixed(2)),
                if (internships != null) _InfoChip(label: 'Internships', value: internships.toString()),
                if (placed != null) _InfoChip(label: 'Placed', value: placed!),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isError
                  ? const Color(0xFF8C2332)
                  : const Color(0xFF164E43),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF355D54),
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFF1B3D36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
