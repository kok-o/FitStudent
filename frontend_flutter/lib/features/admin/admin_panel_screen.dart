import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';
import 'admin_users_tab.dart';
import 'admin_statistics_tab.dart';
import 'admin_notifications_tab.dart';
import 'admin_support_tab.dart';
import 'package:go_router/go_router.dart';
=======
import 'admin_users_tab.dart';
import 'admin_statistics_tab.dart';
import 'admin_notifications_tab.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const AdminStatisticsTab(),
    const AdminUsersTab(),
    const AdminNotificationsTab(),
<<<<<<< HEAD
    const AdminSupportTab(),
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
  ];

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final l10n = AppLocalizations.of(context)!;

=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
<<<<<<< HEAD
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Exit Admin Panel',
          onPressed: () => context.go('/profile'),
        ),
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      ),
      body: _tabs[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
<<<<<<< HEAD
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: l10n.statistics_label,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.users_label,
          ),
          NavigationDestination(
            icon: const Icon(Icons.notifications_outlined),
            selectedIcon: const Icon(Icons.notifications),
            label: l10n.notifications_label,
          ),
          NavigationDestination(
            icon: const Icon(Icons.support_agent_outlined),
            selectedIcon: const Icon(Icons.support_agent),
            label: l10n.support_label,
=======
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          ),
        ],
      ),
    );
  }
}
