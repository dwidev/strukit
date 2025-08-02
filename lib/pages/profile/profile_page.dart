// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:strukit/core/themes/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showFloatingHeader) {
      setState(() {
        _showFloatingHeader = true;
      });
    } else if (_scrollController.offset <= 100 && _showFloatingHeader) {
      setState(() {
        _showFloatingHeader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Main Header - akan hilang saat scroll
              SliverToBoxAdapter(child: _buildMainHeader(context)),

              // Second Header - Profile Info
              SliverToBoxAdapter(child: _buildProfileHeader(context)),

              // Menu Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: _buildMenuOptions(context),
                ),
              ),
            ],
          ),

          // Floating Header - muncul saat scroll
          if (_showFloatingHeader)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildFloatingHeader(context),
            ),
        ],
      ),
    );
  }

  Widget _buildMainHeader(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                    'Profile',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 600.ms)
                  .slideX(begin: -0.3, end: 0, delay: 100.ms, duration: 500.ms),

              const SizedBox(height: 2),

              Text(
                    'Kelola akun dan pengaturan',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideX(begin: -0.2, end: 0, delay: 200.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.lightSurfaceVariant,
                  backgroundImage: const AssetImage('assets/images/avatar.png'),
                  child: Icon(Icons.person, size: 32),
                )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .scaleXY(begin: 0.8, end: 1, delay: 300.ms, duration: 500.ms),

            const SizedBox(width: 16),

            // User Info
            Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Fahmi dwi syahputra',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Premium badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppTheme.getGradients(context),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'PRO',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'fahmidwi45@email.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideX(begin: 0.3, end: 0, delay: 400.ms, duration: 500.ms),

            // Settings shortcut
            IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.gear,
                    color: AppColors.lightTextSecondary,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.toOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms)
                .scaleXY(begin: 0.8, end: 1, delay: 500.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    return Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  // Small Avatar
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.lightSurfaceVariant,
                    backgroundImage: const AssetImage(
                      'assets/images/avatar.png',
                    ),
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Compact Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sarah Wijaya',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppTheme.getGradients(context),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'PRO',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'sarah.wijaya@email.com',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),

                  // Settings icon
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.gear,
                      color: AppColors.lightTextSecondary,
                      size: 18,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.toOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildMenuOptions(BuildContext context) {
    final menuItems = [
      MenuItemData(
        icon: FontAwesomeIcons.crown,
        title: 'Upgrade Premium',
        subtitle: 'Akses fitur unlimited dan cloud sync',
        color: Colors.amber.shade600,
        onTap: () {},
        showBadge: true,
      ),
      MenuItemData(
        icon: FontAwesomeIcons.qrcode,
        title: 'Riwayat Scan',
        subtitle: 'Lihat semua hasil scan struk',
        color: AppColors.primary,
        onTap: () {},
      ),
      MenuItemData(
        icon: FontAwesomeIcons.download,
        title: 'Export Data',
        subtitle: 'Download data dalam format Excel/PDF',
        color: AppColors.success,
        onTap: () {},
      ),

      // MenuItemData(
      //   icon: FontAwesomeIcons.folderOpen,
      //   title: 'Folder Struk',
      //   subtitle: 'Kelola dan kategorikan struk',
      //   color: AppColors.success,
      //   onTap: () {},
      // ),
      // MenuItemData(
      //   icon: FontAwesomeIcons.camera,
      //   title: 'Kualitas Scan',
      //   subtitle: 'Atur preferensi kamera dan OCR',
      //   color: AppColors.warning,
      //   onTap: () {},
      // ),
      MenuItemData(
        icon: FontAwesomeIcons.bell,
        title: 'Notifikasi',
        subtitle: 'Atur pengingat dan notifikasi',
        color: AppColors.lightTextSecondary,
        onTap: () {},
      ),
      MenuItemData(
        icon: FontAwesomeIcons.gear,
        title: 'Pengaturan',
        subtitle: 'Preferensi aplikasi dan akun',
        color: AppColors.lightTextSecondary,
        onTap: () {},
      ),
      MenuItemData(
        icon: FontAwesomeIcons.circleQuestion,
        title: 'Bantuan',
        subtitle: 'FAQ dan panduan penggunaan',
        color: AppColors.lightTextSecondary,
        onTap: () {},
      ),
      MenuItemData(
        icon: FontAwesomeIcons.rightFromBracket,
        title: 'Keluar',
        subtitle: 'Logout dari aplikasi',
        color: AppColors.error,
        onTap: () {},
        isDestructive: true,
      ),
    ];

    return Column(
      children: menuItems.asMap().entries.map((entry) {
        int index = entry.key;
        MenuItemData item = entry.value;

        return _buildMenuItem(context, item, index * 80);
      }).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItemData item, int delayMs) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child:
          InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: item.color.toOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: item.color, size: 18),
                      ),
                      const SizedBox(width: 16),

                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.title,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: item.isDestructive
                                            ? AppColors.error
                                            : null,
                                      ),
                                ),
                                if (item.showBadge) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: AppTheme.getGradientsOrange(
                                          context,
                                        ).reversed.toList(),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'NEW',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.lightTextSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.grey.toOpacity(0.4),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 600 + delayMs),
                duration: 600.ms,
              )
              .slideX(
                begin: 0.2,
                end: 0,
                delay: Duration(milliseconds: 600 + delayMs),
                duration: 500.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showBadge;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
    this.showBadge = false,
  });
}

// Simple Report Screen untuk MVP
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.toOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Laporan',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBackground,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Analisis pengeluaran dan tren',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.lightTextSecondary,
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppTheme.getGradients(context),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.chartLine,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 600.ms)
                  .slideY(begin: -0.2, end: 0, delay: 100.ms, duration: 500.ms),

              const SizedBox(height: 60),

              // Coming Soon Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppTheme.getGradients(context),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.chartPie,
                            color: Colors.white,
                            size: 48,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 800.ms)
                        .scaleXY(
                          begin: 0.8,
                          end: 1,
                          delay: 300.ms,
                          duration: 600.ms,
                        )
                        .then()
                        .shimmer(duration: 2000.ms),

                    const SizedBox(height: 32),

                    Text(
                          'Fitur Laporan\nSegera Hadir!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBackground,
                                height: 1.3,
                              ),
                        )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          delay: 500.ms,
                          duration: 500.ms,
                        ),

                    const SizedBox(height: 16),

                    Text(
                          'Kami sedang mengembangkan fitur analisis pengeluaran yang akan membantu Anda memahami pola belanja dan mengatur budget dengan lebih baik.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.lightTextSecondary,
                                height: 1.5,
                              ),
                        )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 600.ms)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          delay: 700.ms,
                          duration: 500.ms,
                        ),

                    const SizedBox(height: 40),

                    Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.toOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: AppColors.primary.toOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.bell,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Notify me when ready',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 600.ms)
                        .scaleXY(
                          begin: 0.9,
                          end: 1,
                          delay: 900.ms,
                          duration: 400.ms,
                        ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
