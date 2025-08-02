import 'package:flutter/material.dart';
import 'package:strukit/core/widgets/custom_bottom_navbar_widget.dart';
import 'package:strukit/pages/camera_page.dart';
import 'package:strukit/pages/home_page.dart';
import 'package:strukit/pages/profile/profile_page.dart';
import 'package:strukit/pages/report/report_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentIndex = 0;

  var pages = <Widget>[];

  @override
  void initState() {
    super.initState();
    pages = [HomePage(), ReportPage(), Container(), ProfilePage()];
  }

  void _navigateToScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: currentIndex,
        onScanTap: () {
          _navigateToScanner();
        },
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
