import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/loading_progress_widget.dart';

class BudgetCard extends StatelessWidget {
  final double spent;
  final double maxBudget;

  const BudgetCard({super.key, required this.spent, required this.maxBudget});

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final remaining = maxBudget - spent;
    final progressPercentage = (spent / maxBudget) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.getBackgroundColor(context).toOpacity(0.24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.getBackgroundColor(context).toOpacity(0.7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Budget',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              Text(
                _formatCurrency(maxBudget),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terpakai: ${_formatCurrency(spent)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
              Text(
                'Sisa: ${_formatCurrency(remaining)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomLinearProgressIndicator(
            value: 0.5,
            gradientColors: AppTheme.getGradientsOrange(context),
            height: 8,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gps_fixed, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                '${progressPercentage.toStringAsFixed(1)}% budget terpakai',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
