import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_flutter/generated/app_localizations.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (MediaQuery.of(context).size.width > 1000)
                NavigationRail(
                  destinations: [
                    NavigationRailDestination(icon: const Icon(Icons.dashboard_outlined), label: Text(t.dashboard)),
                    NavigationRailDestination(icon: const Icon(Icons.person_outline), label: Text(t.profileNav)),
                    NavigationRailDestination(icon: const Icon(Icons.restaurant_menu_outlined), label: Text(t.dietNav)),
                    NavigationRailDestination(icon: const Icon(Icons.show_chart_outlined), label: Text(t.progressNav)),
                    NavigationRailDestination(icon: const Icon(Icons.menu_book_outlined), label: Text(t.recipesNav)),
                  ],
                  selectedIndex: _indexFromLocation(GoRouterState.of(context).uri.toString()),
                  onDestinationSelected: (i) => _goByIndex(context, i),
                ),
              Expanded(child: Padding(padding: const EdgeInsets.all(16), child: child)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 1000
          ? NavigationBar(
              selectedIndex: _indexFromLocation(GoRouterState.of(context).uri.toString()),
              onDestinationSelected: (i) => _goByIndex(context, i),
              destinations: [
                NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: t.dashboard),
                NavigationDestination(icon: const Icon(Icons.person_outline), label: t.profileNav),
                NavigationDestination(icon: const Icon(Icons.restaurant_menu_outlined), label: t.dietNav),
                NavigationDestination(icon: const Icon(Icons.show_chart_outlined), label: t.progressNav),
                NavigationDestination(icon: const Icon(Icons.menu_book_outlined), label: t.recipesNav),
              ],
            )
          : null,
    );
  }

  int _indexFromLocation(String path) {
    if (path.startsWith('/profile')) return 1;
    if (path.startsWith('/diet')) return 2;
    if (path.startsWith('/progress')) return 3;
    if (path.startsWith('/recipes')) return 4;
    return 0;
  }

  void _goByIndex(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/profile');
        break;
      case 2:
        context.go('/diet');
        break;
      case 3:
        context.go('/progress');
        break;
      case 4:
        context.go('/recipes');
        break;
    }
  }
}
