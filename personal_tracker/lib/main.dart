import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_tracker/core/constants/theme.dart';
import 'package:personal_tracker/domain/entities/currency_model.dart';
import 'package:personal_tracker/domain/entities/expenses_data_model.dart';
import 'package:personal_tracker/domain/entities/theme_model.dart';
import 'package:personal_tracker/provider/theme_provider.dart';
import 'package:personal_tracker/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpensesDataModelAdapter());
  Hive.registerAdapter(expensesAdapter());
  Hive.registerAdapter(CurrencyModelAdapter());
  Hive.registerAdapter(ThemeModelAdapter());
  await Hive.openBox<ExpensesDataModel>('expenses');
  await Hive.openBox<String>('currencyBox');
  await Hive.openBox<bool>('themeMode');

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final isDarkMode = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? darkAppTheme : lightAppTheme,
    );
  }
}
