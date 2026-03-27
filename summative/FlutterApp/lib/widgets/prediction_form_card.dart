import 'package:flutter/material.dart';

class PredictionFormCard extends StatelessWidget {
  const PredictionFormCard({
    super.key,
    required this.cgpaController,
    required this.internshipsController,
    required this.placedController,
    required this.isLoading,
    required this.onPredict,
    required this.apiEndpoint,
    required this.resultCard,
    required this.onPlacedSelected,
  });

  final TextEditingController cgpaController;
  final TextEditingController internshipsController;
  final TextEditingController placedController;
  final bool isLoading;
  final VoidCallback onPredict;
  final String apiEndpoint;
  final Widget resultCard;
  final ValueChanged<String> onPlacedSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Student Salary Predictor',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF12312C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the real model inputs from your dataset to estimate Salary (INR LPA) from the API.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF50645E),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF155E75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model Inputs',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'CGPA, Internships, and Placed are used for prediction. Use Yes or No for Placed. Student ID exists in the dataset but is not required for this form.',
                    style: TextStyle(
                      color: Color(0xFFE7FFFB),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: cgpaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'CGPA',
                hintText: '0.0 to 10.0',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: internshipsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Internships',
                hintText: '0 to 10',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: placedController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Placed',
                hintText: 'Yes or No',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ActionChip(
                  label: const Text('Yes'),
                  avatar: const Icon(Icons.check_circle_outline, size: 18),
                  onPressed: () => onPlacedSelected('Yes'),
                ),
                ActionChip(
                  label: const Text('No'),
                  avatar: const Icon(Icons.highlight_off, size: 18),
                  onPressed: () => onPlacedSelected('No'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: isLoading ? null : onPredict,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Predict',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            resultCard,
            const SizedBox(height: 18),
            Text(
              'API endpoint: $apiEndpoint',
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6A7E79),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
