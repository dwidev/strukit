import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/pages/camera_page.dart';
import 'package:strukit/pages/scanner_page.dart';

void showScannerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => const ScannerBottomSheet(),
    ),
  );
}

class ScannerBottomSheet extends StatelessWidget {
  const ScannerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getBackgroundColor(context),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: AppTheme.getGradients(context),
        // ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Pilih Project',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppTheme.getTextPrimaryColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppTheme.getTextPrimaryColor(context),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Create New Project Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.getGradients(context),
                ),
                boxShadow: [],
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle create new project
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Create New Project',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Project List Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Projects',
                style: TextStyle(
                  color: AppTheme.getTextPrimaryColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Project List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProjectItem(
                  context,
                  'Strukit Budget App',
                  'Rp 5.000.000',
                  '25% terpakai',
                  Icons.account_balance_wallet,
                ),
                _buildProjectItem(
                  context,
                  'E-commerce Mobile',
                  'Rp 3.200.000',
                  '60% terpakai',
                  Icons.shopping_cart,
                ),
                _buildProjectItem(
                  context,
                  'Restaurant POS',
                  'Rp 1.800.000',
                  '40% terpakai',
                  Icons.restaurant,
                ),
                _buildProjectItem(
                  context,
                  'Inventory System',
                  'Rp 2.500.000',
                  '15% terpakai',
                  Icons.inventory,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProjectItem(
    BuildContext context,
    String projectName,
    String budget,
    String usage,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.secondary.toOpacity(0.1),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.getGradients(context)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          title: Text(
            projectName,
            style: TextStyle(
              color: AppTheme.getTextPrimaryColor(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Budget: $budget', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 2),
              Text(usage, style: TextStyle(fontSize: 12)),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.pop(context, projectName);
            // Handle project selection
          },
        ),
      ),
    );
  }
}
