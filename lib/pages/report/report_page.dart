// screens/report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:strukit/core/themes/app_theme.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ScrollController _scrollController = ScrollController();
  String selectedPeriod = 'Bulan Ini';

  // Sample data - replace with real data from your backend
  final double totalBudget = 5000000; // 5 juta
  final double totalSpent = 3250000; // 3.25 juta
  final int totalReceipts = 47;
  final int totalItems = 156;

  @override
  Widget build(BuildContext context) {
    final remainingBudget = totalBudget - totalSpent;
    final spentPercentage = (totalSpent / totalBudget * 100).round();

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar Header
          SliverToBoxAdapter(child: _buildHeader(context)),

          // Budget Overview Card
          SliverToBoxAdapter(
            child: _buildBudgetOverview(
              context,
              spentPercentage,
              remainingBudget,
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(child: _buildQuickStats(context)),

          // Period Filter
          SliverToBoxAdapter(child: _buildPeriodFilter(context)),

          // Charts Section
          SliverToBoxAdapter(child: _buildChartsSection(context)),

          // Recent Transactions
          SliverToBoxAdapter(child: _buildRecentTransactions(context)),

          // Export Section
          SliverToBoxAdapter(child: _buildExportSection(context)),

          // Bottom Spacing
          SliverToBoxAdapter(child: const SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.getGradients(context),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            'Laporan Keuangan',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 600.ms)
                          .slideX(
                            begin: -0.3,
                            end: 0,
                            delay: 100.ms,
                            duration: 500.ms,
                          ),

                      const SizedBox(height: 4),

                      Text(
                            'Acara Kantor - Konsumsi Tim',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white.toOpacity(0.9)),
                          )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 600.ms)
                          .slideX(
                            begin: -0.2,
                            end: 0,
                            delay: 200.ms,
                            duration: 500.ms,
                          ),
                    ],
                  ),

                  Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.toOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          FontAwesomeIcons.chartLine,
                          color: Colors.white,
                          size: 24,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .scaleXY(
                        begin: 0.8,
                        end: 1,
                        delay: 300.ms,
                        duration: 500.ms,
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetOverview(
    BuildContext context,
    int spentPercentage,
    double remainingBudget,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child:
          Card(
                elevation: 4,
                shadowColor: Colors.black.toOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Budget Overview',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: spentPercentage > 80
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$spentPercentage% Terpakai',
                              style: TextStyle(
                                color: spentPercentage > 80
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Budget Progress Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Budget',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.lightTextSecondary,
                                    ),
                              ),
                              Text(
                                'Rp ${_formatCurrency(totalBudget)}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: spentPercentage / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: spentPercentage > 80
                                        ? [
                                            Colors.red.shade400,
                                            Colors.red.shade600,
                                          ]
                                        : AppTheme.getGradients(context),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildBudgetItem(
                                  context,
                                  'Terpakai',
                                  totalSpent,
                                  AppColors.primary,
                                  FontAwesomeIcons.arrowTrendUp,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildBudgetItem(
                                  context,
                                  'Tersisa',
                                  remainingBudget,
                                  Colors.green.shade600,
                                  FontAwesomeIcons.piggyBank,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 500.ms),
    );
  }

  Widget _buildBudgetItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.toOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.toOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Rp ${_formatCurrency(amount)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Total Struk',
              totalReceipts.toString(),
              FontAwesomeIcons.receipt,
              Colors.blue.shade600,
              0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Total Item',
              totalItems.toString(),
              FontAwesomeIcons.listCheck,
              Colors.green.shade600,
              100,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Rata-rata',
              'Rp ${_formatCurrency(totalSpent / totalReceipts)}',
              FontAwesomeIcons.chartBar,
              Colors.orange.shade600,
              200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    int delay,
  ) {
    return Card(
          elevation: 2,
          shadowColor: Colors.black.toOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.toOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 600 + delay),
          duration: 600.ms,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          delay: Duration(milliseconds: 600 + delay),
          duration: 500.ms,
        );
  }

  Widget _buildPeriodFilter(BuildContext context) {
    final periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Custom'];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = selectedPeriod == period;

          return Container(
                margin: EdgeInsets.only(
                  right: index == periods.length - 1 ? 0 : 12,
                ),
                child: FilterChip(
                  label: Text(period),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedPeriod = period;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary.toOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightTextSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 800 + index * 100),
                duration: 600.ms,
              )
              .slideX(
                begin: 0.2,
                end: 0,
                delay: Duration(milliseconds: 800 + index * 100),
                duration: 500.ms,
              );
        },
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child:
          Card(
                elevation: 4,
                shadowColor: Colors.black.toOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kategori Pengeluaran',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(FontAwesomeIcons.expand, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.toOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Category items
                      _buildCategoryItem(
                        'Makanan & Minuman',
                        1450000,
                        Colors.orange.shade600,
                        0.45,
                      ),
                      _buildCategoryItem(
                        'Peralatan',
                        980000,
                        Colors.blue.shade600,
                        0.30,
                      ),
                      _buildCategoryItem(
                        'Dekorasi',
                        520000,
                        Colors.green.shade600,
                        0.16,
                      ),
                      _buildCategoryItem(
                        'Transportasi',
                        300000,
                        Colors.purple.shade600,
                        0.09,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0, delay: 1000.ms, duration: 500.ms),
    );
  }

  Widget _buildCategoryItem(
    String category,
    double amount,
    Color color,
    double percentage,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                'Rp ${_formatCurrency(amount)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final transactions = [
      TransactionData(
        'Catering Nusantara',
        850000,
        'Makanan',
        DateTime.now().subtract(Duration(hours: 2)),
      ),
      TransactionData(
        'Toko Berkah',
        125000,
        'Peralatan',
        DateTime.now().subtract(Duration(hours: 5)),
      ),
      TransactionData(
        'Supermarket ABC',
        340000,
        'Minuman',
        DateTime.now().subtract(Duration(days: 1)),
      ),
      TransactionData(
        'Dekorasi Prima',
        520000,
        'Dekorasi',
        DateTime.now().subtract(Duration(days: 1)),
      ),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child:
          Card(
                elevation: 4,
                shadowColor: Colors.black.toOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi Terbaru',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Lihat Semua'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      ...transactions.asMap().entries.map((entry) {
                        int index = entry.key;
                        TransactionData transaction = entry.value;

                        return _buildTransactionItem(
                          context,
                          transaction,
                          index * 100,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0, delay: 1200.ms, duration: 500.ms),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    TransactionData transaction,
    int delay,
  ) {
    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.toOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  FontAwesomeIcons.receipt,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.merchant,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightTextSecondary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: AppColors.lightTextSecondary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(transaction.date),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                'Rp ${_formatCurrency(transaction.amount)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 1400 + delay),
          duration: 600.ms,
        )
        .slideX(
          begin: 0.2,
          end: 0,
          delay: Duration(milliseconds: 1400 + delay),
          duration: 500.ms,
        );
  }

  Widget _buildExportSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child:
          Card(
                elevation: 4,
                shadowColor: Colors.black.toOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green.shade50, Colors.green.shade100],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              FontAwesomeIcons.fileExport,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Export Laporan',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Download laporan lengkap untuk diserahkan ke kantor',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.green.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(FontAwesomeIcons.filePdf, size: 16),
                              label: Text('PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(FontAwesomeIcons.fileExcel, size: 16),
                              label: Text('Excel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 1600.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0, delay: 1600.ms, duration: 500.ms),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m lalu';
      }
      return '${difference.inHours}j lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }
}

class TransactionData {
  final String merchant;
  final double amount;
  final String category;
  final DateTime date;

  TransactionData(this.merchant, this.amount, this.category, this.date);
}
