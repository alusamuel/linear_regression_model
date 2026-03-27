import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.message,
    required this.isError,
    this.onClose,
    this.predictedSalary,
    this.salaryUnit,
    this.cgpa,
    this.internships,
    this.placed,
  });

  final String message;
  final bool isError;
  final VoidCallback? onClose;
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        gradient: isError
            ? const LinearGradient(
                colors: [Color(0xFFFFF4F5), Color(0xFFFFECEE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFF7FFFD), Color(0xFFEAF9F4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(24),
        ),
        border: Border.all(
          color: isError
              ? const Color(0xFFF4B7BE)
              : const Color(0xFFB8E0D6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F172A),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 54,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFBFD4CD),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onClose,
              style: FilledButton.styleFrom(
                backgroundColor: isError
                    ? const Color(0xFFB42333)
                    : const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isError ? 'Back To Form' : 'Done',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
