import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/theme.dart';
import '../../shared/components/movie_card.dart';
import '../../shared/components/empty_state.dart';
import '../../store/movie_store.dart';
import '../../store/app_store.dart';

/// FavoritesScreen — equivalent to React Native FavoritesScreen.tsx
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appStore = context.watch<AppStore>();
    final isDark = appStore.isDark(context);
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(
                  left: Spacing.lg,
                  right: Spacing.lg,
                  top: Spacing.huge,
                  bottom: Spacing.lg,
                ),
                child: Consumer<MovieStore>(
                  builder: (context, store, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorites',
                          style: AppTypography.h1.copyWith(color: colors.text),
                        ),
                        Text(
                          store.favorites.isNotEmpty
                              ? '${store.favorites.length} movie${store.favorites.length > 1 ? 's' : ''} saved'
                              : 'Your saved movies',
                          style: AppTypography.body
                              .copyWith(color: colors.textSecondary),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Content
              Expanded(
                child: Consumer<MovieStore>(
                  builder: (context, store, _) {
                    if (store.favorites.isEmpty) {
                      return const EmptyState(
                        icon: '💜',
                        title: 'No Favorites Yet',
                        message:
                            'Start adding movies to your favorites by tapping the heart icon on any movie card.',
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.lg)
                          .copyWith(bottom: Spacing.xxl),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Spacing.lg,
                        mainAxisSpacing: Spacing.lg,
                        childAspectRatio: _cardAspectRatio(context),
                      ),
                      itemCount: store.favorites.length,
                      itemBuilder: (context, index) {
                        return MovieCard(
                          movie: store.favorites[index],
                          index: index,
                          heroContext: 'fav',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _cardAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - Spacing.lg * 3) / 2;
    final cardHeight = cardWidth * 1.5 + 80;
    return cardWidth / cardHeight;
  }
}
