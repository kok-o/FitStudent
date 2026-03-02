import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
<<<<<<< HEAD
import 'package:frontend_flutter/generated/app_localizations.dart';
=======
import 'package:frontend_flutter/l10n/app_localizations.dart';
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
import 'core/locale_provider.dart';
import 'core/auth_state.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthState.init();
  runApp(const ProviderScope(child: SmartDietApp()));
}

class SmartDietApp extends ConsumerWidget {
  const SmartDietApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
<<<<<<< HEAD
      title: 'FitStudent',
=======
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx)?.appTitle ?? 'FitStudent',
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
<<<<<<< HEAD
      routerConfig: ref.watch(routerProvider),
=======
      routerConfig: ref.read(routerProvider),
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
    );
  }
}
