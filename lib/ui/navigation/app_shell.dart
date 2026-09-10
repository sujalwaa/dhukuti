import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../screens/add_transaction/add_tab.dart';
import '../screens/overview/overview_tab.dart';
import '../screens/analytics/analytics_tab.dart';
import '../screens/savings/savings_tab.dart';
import '../screens/settings/settings_page.dart';


class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;
  bool _showAdd = false;

  void _onTabTapped(int index) {
    if (index == 3) {
      setState(() => _showAdd = true);
    } else {
      setState(() {
        _currentIndex = index;
        _showAdd = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showAdd) {
      return AddTab(onClose: () => setState(() => _showAdd = false));
    }

    return Scaffold(
      body: Center(child: Text('Tab $_currentIndex')),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.94),
          border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.05))),
        ),
        padding: const EdgeInsets.only(top: 6, left: 16, right: 16, bottom: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, PhosphorIconsRegular.house, 'Overview'),
            _buildNavItem(1, PhosphorIconsRegular.chartBar, 'Analytics'),
            _buildAddButton(),
            _buildNavItem(2, PhosphorIconsRegular.piggyBank, 'Savings'),
            _buildNavItem(4, PhosphorIconsRegular.gear, 'Settings'), // Added settings for completion
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF111111) : const Color(0xFFBBBBBB),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? const Color(0xFF111111) : const Color(0xFFBBBBBB),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(3),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIconsRegular.plus, color: Colors.white, size: 24),
            Text('Add', style: TextStyle(color: Colors.white, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
