import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'store/app_store.dart';
import 'store/movie_store.dart';
import 'shared/theme.dart';
import 'features/home/home_screen.dart';
import 'features/favorites/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStore()..loadTheme()),
        ChangeNotifierProvider(create: (_) => MovieStore()),
      ],
      child: const MyApp(),
    ),
  );
}

/// MyApp — equivalent to React Native App.tsx
/// Root widget with ThemeProvider and NavigationContainer
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStore>(
      builder: (context, appStore, _) {
        final isDark = appStore.isDark(context);
        final colors = isDark ? AppColors.dark : AppColors.light;

        // Set status bar style
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ));

        return MaterialApp(
          title: 'Movie Discovery',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: colors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: colors.primary,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
          home: const MainTabs(),
        );
      },
    );
  }
}

/// MainTabs — equivalent to React Native MainTabs (Bottom Tab Navigator)
class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appStore = context.watch<AppStore>();
    final isDark = appStore.isDark(context);
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 3,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  index: 0,
                  label: 'Home',
                  activeIcon: '🎬',
                  inactiveIcon: '🎬',
                  colors: colors,
                ),
                _buildTabItem(
                  index: 1,
                  label: 'Favorites',
                  activeIcon: '❤️',
                  inactiveIcon: '🤍',
                  colors: colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String label,
    required String activeIcon,
    required String inactiveIcon,
    required AppColorScheme colors,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Center(
                child: Text(
                  isSelected ? activeIcon : inactiveIcon,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? colors.primary
                    : colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
