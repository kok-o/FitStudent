import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
<<<<<<< HEAD
import 'package:frontend_flutter/generated/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';
=======
import 'package:frontend_flutter/l10n/app_localizations.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e

class ModernMainLayout extends StatelessWidget {
  final Widget child;

  const ModernMainLayout({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
<<<<<<< HEAD
    if (location.startsWith('/progress')) return 1;
    if (location.startsWith('/activity')) return 2;
=======
    if (location.startsWith('/recipes')) return 1;
    if (location.startsWith('/progress')) return 2;
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
<<<<<<< HEAD
        context.go('/progress');
        break;
      case 2:
        context.go('/activity');
=======
        context.go('/recipes');
        break;
      case 2:
        context.go('/progress');
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final l10n = AppLocalizations.of(context)!;
=======
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'FitStudent',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getCurrentIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        elevation: 3,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
<<<<<<< HEAD
            label: l10n.home,
=======
            label: AppLocalizations.of(context)!.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_menu_outlined),
            selectedIcon: const Icon(Icons.restaurant_menu),
            label: AppLocalizations.of(context)!.recipes,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart_outlined),
            selectedIcon: const Icon(Icons.show_chart),
<<<<<<< HEAD
            label: l10n.progress_label,
          ),
          NavigationDestination(
            icon: const Icon(Icons.edit_note_outlined),
            selectedIcon: const Icon(Icons.edit_note),
            label: l10n.activity_label,
=======
            label: AppLocalizations.of(context)!.progress,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
<<<<<<< HEAD
            label: l10n.profile_label,
=======
            label: AppLocalizations.of(context)!.profile,
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
          ),
        ],
      ),
    );
  }
}
