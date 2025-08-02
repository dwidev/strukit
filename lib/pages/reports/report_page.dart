// ignore_for_file: public_member_api_docs, sort_constructors_first
// widgets/expense_chart.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:strukit/core/themes/app_theme.dart';

class ExpenseChart extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final List<ExpenseItem> expenses;

  const ExpenseChart({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final weeklyData = _getWeeklyData();
    final maxAmount = weeklyData.values.isNotEmpty
        ? weeklyData.values.reduce((a, b) => a > b ? a : b)
        : 100000;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grafik Pengeluaran Mingguan',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '7 Hari Terakhir',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeklyData.entries.map((entry) {
                  final day = entry.key;
                  final amount = entry.value;
                  final height = (amount / maxAmount) * 150;
                  final isToday = _isToday(day);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Amount label
                          if (amount > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                NumberFormat.compact(
                                  locale: 'id_ID',
                                ).format(amount),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),

                          // Bar
                          Container(
                            width: double.infinity,
                            height: height > 0 ? height.clamp(8.0, 150.0) : 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isToday
                                    ? [
                                        AppColors.primaryVariant,
                                        AppColors.primary,
                                      ]
                                    : amount > 0
                                    ? [
                                        AppColors.primary.withOpacity(0.3),
                                        AppColors.primary.withOpacity(0.6),
                                      ]
                                    : [
                                        Colors.grey.withOpacity(0.2),
                                        Colors.grey.withOpacity(0.3),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Day label
                          Text(
                            DateFormat('E').format(day),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isToday
                                      ? AppColors.primary
                                      : AppColors.secondary,
                                  fontWeight: isToday
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, double> _getWeeklyData() {
    final now = DateTime.now();
    final weeklyData = <DateTime, double>{};

    // Initialize with 7 days
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      weeklyData[day] = 0.0;
    }

    // Sum expenses by day
    for (final expense in expenses) {
      final expenseDay = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      if (weeklyData.containsKey(expenseDay)) {
        weeklyData[expenseDay] = weeklyData[expenseDay]! + expense.amount;
      }
    }

    return weeklyData;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

// widgets/category_breakdown.dart

class CategoryBreakdown extends StatelessWidget {
  final List<ExpenseItem> expenses;

  const CategoryBreakdown({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData();
    final totalAmount = categoryData.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Breakdown per Kategori',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),

        // Pie Chart Representation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Total center display
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primaryVariant.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        NumberFormat.compact(
                          locale: 'id_ID',
                        ).format(totalAmount),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category List
                ...categoryData.entries.map((entry) {
                  final category = entry.key;
                  final amount = entry.value;
                  final percentage = (amount / totalAmount) * 100;
                  final color = _getCategoryColor(category);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: percentage / 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(amount),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Category Details
        ...categoryData.entries.map((entry) {
          final category = entry.key;
          final categoryExpenses = expenses
              .where((e) => e.category == category)
              .toList();

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  size: 20,
                ),
              ),
              title: Text(
                category,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${categoryExpenses.length} transaksi • ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(entry.value)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              children: categoryExpenses.map((expense) {
                return ListTile(
                  dense: true,
                  title: Text(expense.store),
                  subtitle: Text(
                    DateFormat('dd MMM yyyy', 'id_ID').format(expense.date),
                  ),
                  trailing: Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(expense.amount),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ],
    );
  }

  Map<String, double> _getCategoryData() {
    final categoryData = <String, double>{};

    for (final expense in expenses) {
      categoryData[expense.category] =
          (categoryData[expense.category] ?? 0) + expense.amount;
    }

    // Sort by amount descending
    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  Color _getCategoryColor(String category) {
    final colors = [
      AppColors.primary,
      AppColors.primaryVariant,
      AppColors.success,
      AppColors.warning,
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF84CC16), // Lime
    ];

    return colors[category.hashCode % colors.length];
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'snack & minuman':
        return Icons.local_drink;
      case 'sayuran & buah':
        return Icons.local_florist;
      case 'groceries':
        return Icons.shopping_cart;
      case 'makanan siap saji':
        return Icons.restaurant;
      case 'bumbu & rempah':
        return Icons.grass;
      case 'protein & lauk':
        return Icons.set_meal;
      default:
        return Icons.receipt_long;
    }
  }
}

// widgets/expense_timeline.dart
class ExpenseTimeline extends StatefulWidget {
  final List<ExpenseItem> expenses;

  const ExpenseTimeline({super.key, required this.expenses});

  @override
  State<ExpenseTimeline> createState() => _ExpenseTimelineState();
}

class _ExpenseTimelineState extends State<ExpenseTimeline> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = [
    'Semua',
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();
    final groupedExpenses = _groupExpensesByDate(filteredExpenses);

    return Column(
      children: [
        // Filter Chips
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Filter: ',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        selectedColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.lightTextSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Timeline
        Expanded(
          child: filteredExpenses.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedExpenses.length,
                  itemBuilder: (context, index) {
                    final entry = groupedExpenses.entries.elementAt(index);
                    final date = entry.key;
                    final dayExpenses = entry.value;
                    final totalDayAmount = dayExpenses.fold(
                      0.0,
                      (sum, expense) => sum + expense.amount,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Header
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _formatDateHeader(date),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${dayExpenses.length} transaksi',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Spacer(),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(totalDayAmount),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        // Expenses for this date
                        ...dayExpenses.asMap().entries.map((expenseEntry) {
                          final expenseIndex = expenseEntry.key;
                          final expense = expenseEntry.value;
                          final isLast = expenseIndex == dayExpenses.length - 1;

                          return _buildTimelineItem(expense, isLast);
                        }).toList(),

                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(ExpenseItem expense, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Expense Card
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense.store,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                expense.category,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(expense.amount),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('HH:mm', 'id_ID').format(expense.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (expense.items.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: expense.items.take(3).map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 10),
                            ),
                          );
                        }).toList(),
                      ),
                      if (expense.items.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${expense.items.length - 3} item lainnya',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(fontSize: 10),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada transaksi',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada pengeluaran untuk filter ini',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<ExpenseItem> _getFilteredExpenses() {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'Hari Ini':
        return widget.expenses.where((expense) {
          return expense.date.year == now.year &&
              expense.date.month == now.month &&
              expense.date.day == now.day;
        }).toList();

      case 'Minggu Ini':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return widget.expenses.where((expense) {
          return expense.date.isAfter(
            startOfWeek.subtract(const Duration(days: 1)),
          );
        }).toList();

      case 'Bulan Ini':
        return widget.expenses.where((expense) {
          return expense.date.year == now.year &&
              expense.date.month == now.month;
        }).toList();

      default:
        return widget.expenses;
    }
  }

  Map<DateTime, List<ExpenseItem>> _groupExpensesByDate(
    List<ExpenseItem> expenses,
  ) {
    final grouped = <DateTime, List<ExpenseItem>>{};

    for (final expense in expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      grouped.putIfAbsent(date, () => []).add(expense);
    }

    // Sort by date descending
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    // Sort expenses within each day by time descending
    for (final entry in sortedEntries) {
      entry.value.sort((a, b) => b.date.compareTo(a.date));
    }

    return Map.fromEntries(sortedEntries);
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Hari Ini';
    } else if (date == yesterday) {
      return 'Kemarin';
    } else {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    }
  }
}

class ExpenseItem {
  final DateTime date;
  final double amount;
  final String category;
  final String store;
  final List<String> items;

  ExpenseItem({
    required this.date,
    required this.amount,
    required this.category,
    required this.store,
    required this.items,
  });
}
