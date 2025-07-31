import 'package:dev_utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/gradient_button_widget.dart';
import 'package:strukit/pages/edit_receipt__page.dart';

class ScannedReceiptPage extends StatefulWidget {
  const ScannedReceiptPage({super.key});

  @override
  State<ScannedReceiptPage> createState() => _ScannedReceiptPageState();
}

class _ScannedReceiptPageState extends State<ScannedReceiptPage> {
  String selectedCategory = 'Makanan & Minuman';
  bool isEditing = false;

  final List<String> categories = [
    'Makanan & Minuman',
    'Belanja Harian',
    'Transportasi',
    'Kesehatan',
    'Hiburan',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF424242)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.3, 1.3),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.3, 1.3),
                  end: const Offset(1.0, 1.0),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(width: 8),
            const Text(
              'Hasil Scan Struk',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: AppColors.secondary,
            ),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child:
            Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        _buildHeader(),

                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 24),

                        // Store Details
                        _buildStoreDetails(),

                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 24),

                        // Items List
                        _buildItemsList(),

                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 24),

                        // Category Selection
                        _buildCategorySelection(),

                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 24),

                        // Summary
                        _buildSummary(),

                        const SizedBox(height: 32),

                        // Action Buttons
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.toOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            color: AppColors.success,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scan Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Struk berhasil diproses',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.toOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Verified',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Toko',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Nama Toko', 'Indomaret Pajajaran'),
        _buildDetailRow('Alamat', 'Jl. Pajajaran No. 45, Bogor'),
        _buildDetailRow('Tanggal', '30 Juli 2024'),
        _buildDetailRow('Waktu', '14:25 WIB'),
        _buildDetailRow('No. Struk', 'IDM240730142501'),
      ],
    );
  }

  Widget _buildItemsList() {
    final items = [
      {'name': 'Indomie Goreng', 'qty': '2', 'price': 'Rp 6.000'},
      {'name': 'Teh Botol Sosro', 'qty': '1', 'price': 'Rp 4.500'},
      {'name': 'Roti Tawar Sari Roti', 'qty': '1', 'price': 'Rp 8.500'},
      {'name': 'Susu Ultra 250ml', 'qty': '2', 'price': 'Rp 12.000'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar item',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => _buildItemRow(item['name']!, item['qty']!, item['price']!),
        ),
      ],
    );
  }

  Widget _buildItemRow(String name, String qty, String price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Qty: $qty',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Pengeluaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = category == selectedCategory;
            return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: AppTheme.getGradients(context),
                            )
                          : null,
                      color: !isSelected ? const Color(0xFFF8F9FA) : null,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: AppColors.secondary)
                          : null,
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF424242),
                      ),
                    ),
                  ),
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: 200.ms,
                  curve: Curves.easeOut,
                );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _buildSummaryRow('Subtotal', 'Rp 31.000'),
        _buildSummaryRow('PPN (11%)', 'Rp 3.410'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.secondary.toOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total ',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp 34.410',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
          children: [
            // Save to Budget Button
            GradientButtonWidget(
              onPressed: () {},
              options: GradientButtonWidgetOptions(
                title: "Simpan",
                icon: FontAwesomeIcons.cloud,
              ),
            ),

            const SizedBox(height: 12),

            // Edit Button
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary, width: 2),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Edit receipt logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReceiptPage(),
                      ),
                    );
                  },
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF2196F3),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Edit Detail',
                          style: TextStyle(
                            color: Color(0xFF2196F3),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 400.ms)
        .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey.toOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('Berhasil!'),
          ],
        ),
        content: const Text('Pengeluaran berhasil ditambahkan ke budget Anda.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
