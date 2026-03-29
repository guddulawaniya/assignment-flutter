import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/theme.dart';
import '../../shared/constants.dart';
import '../../shared/models.dart';
import '../../shared/components/movie_card.dart';
import '../../shared/components/skeleton_loader.dart';
import '../../shared/components/error_view.dart';
import '../../shared/components/loading_footer.dart';
import '../../store/movie_store.dart';
import '../../store/app_store.dart';

/// HomeScreen — equivalent to React Native HomeScreen.tsx
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchText = '';
  bool _searchFocused = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<MovieStore>();
      store.fetchTrending();
      store.fetchGenres();
      store.loadFavorites();
    });

    // Scroll listener for pagination
    _scrollController.addListener(_onScroll);

    // Search focus listener
    _searchFocusNode.addListener(() {
      setState(() => _searchFocused = _searchFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final store = context.read<MovieStore>();
      if (_isSearchMode) {
        store.loadMoreSearch();
      } else {
        store.loadMoreTrending();
      }
    }
  }

  bool get _isSearchMode => _searchText.trim().isNotEmpty;

  void _onSearchChanged(String value) {
    setState(() => _searchText = value);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: AppConstants.debounceDelay),
      () {
        final store = context.read<MovieStore>();
        if (value.trim().isNotEmpty) {
          store.searchMovies(value);
        } else {
          store.clearSearch();
        }
      },
    );
  }

  void _handleClearSearch() {
    _searchController.clear();
    setState(() => _searchText = '');
    context.read<MovieStore>().clearSearch();
    FocusScope.of(context).unfocus();
  }

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
              // ── Header Row ─────────────────────────────────────────────
              _buildHeader(colors, isDark, appStore),

              // ── Search Bar ─────────────────────────────────────────────
              _buildSearchBar(colors),

              // ── Content ────────────────────────────────────────────────
              Expanded(child: _buildContent(colors)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorScheme colors, bool isDark, AppStore appStore) {
    return Consumer<MovieStore>(
      builder: (context, store, _) {
        return Padding(
          padding: const EdgeInsets.only(
            left: Spacing.lg,
            right: Spacing.lg,
            top: Spacing.huge,
            bottom: Spacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: AppTypography.h1.copyWith(color: colors.text),
                    ),
                    Text(
                      _isSearchMode
                          ? '${store.searchResults.length} results for "$_searchText"'
                          : 'Trending movies this week',
                      style: AppTypography.body
                          .copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => appStore.toggleTheme(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppBorderRadius.full),
                  ),
                  child: Center(
                    child: Text(
                      isDark ? '☀️' : '🌙',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(AppColorScheme colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: Spacing.lg)
          .copyWith(bottom: Spacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: _searchFocused ? colors.primary : colors.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Text('🔍', style: TextStyle(fontSize: 15)),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              style: TextStyle(fontSize: 14, color: colors.text),
              decoration: InputDecoration(
                hintText: 'Search movies…',
                hintStyle: TextStyle(color: colors.textTertiary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.search,
              autocorrect: false,
            ),
          ),
          if (_searchText.isNotEmpty)
            GestureDetector(
              onTap: _handleClearSearch,
              child: Padding(
                padding: const EdgeInsets.only(left: Spacing.xs),
                child: Text(
                  '✕',
                  style: TextStyle(
                    fontSize: 15,
                    color: colors.textTertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(AppColorScheme colors) {
    return Consumer<MovieStore>(
      builder: (context, store, _) {
        // Error state
        if (store.error != null && store.trendingMovies.isEmpty) {
          return ErrorView(
            message: store.error!,
            onRetry: () => store.fetchTrending(),
          );
        }

        // Loading state
        final isLoading =
            (store.isTrendingLoading && !_isSearchMode) ||
            (store.isSearching && _displayData(store).isEmpty);

        if (isLoading) {
          if (_isSearchMode) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colors.primary),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Searching movies...',
                    style: AppTypography.body
                        .copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            );
          }
          return _buildSkeleton(colors);
        }

        final data = _displayData(store);

        if (data.isEmpty && _isSearchMode && !store.isSearching) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎬', style: TextStyle(fontSize: 44)),
                const SizedBox(height: Spacing.md),
                Text(
                  'No results found',
                  style: AppTypography.subtitle.copyWith(color: colors.text),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  'Try a different title or keyword',
                  style: AppTypography.body
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => store.fetchTrending(refresh: true),
          color: colors.primary,
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg)
                .copyWith(bottom: Spacing.xxl),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Spacing.lg,
              mainAxisSpacing: Spacing.lg,
              childAspectRatio: _cardAspectRatio(context),
            ),
            itemCount: data.length + 1, // +1 for footer
            itemBuilder: (context, index) {
              if (index == data.length) {
                return _buildFooter(store, colors);
              }
              return MovieCard(
                movie: data[index],
                index: index,
                heroContext: _isSearchMode ? 'search' : 'trending',
              );
            },
          ),
        );
      },
    );
  }

  List<Movie> _displayData(MovieStore store) {
    return _isSearchMode ? store.searchResults : store.trendingMovies;
  }

  double _cardAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - Spacing.lg * 3) / 2;
    final cardHeight = cardWidth * 1.5 + 80; // poster + info section
    return cardWidth / cardHeight;
  }

  Widget _buildFooter(MovieStore store, AppColorScheme colors) {
    final loading =
        _isSearchMode ? store.isSearchLoadingMore : store.isTrendingLoadingMore;

    if (loading) return const LoadingFooter();

    if (store.isMoreError) {
      return GestureDetector(
        onTap: () {
          if (_isSearchMode) {
            store.loadMoreSearch();
          } else {
            store.loadMoreTrending();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.xl,
            horizontal: Spacing.lg,
          ),
          child: Column(
            children: [
              Text(
                'Internet not available',
                style: AppTypography.bodySmall.copyWith(color: colors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'TAP TO RETRY ↻',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSkeleton(AppColorScheme colors) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - Spacing.lg * 3) / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Wrap(
        spacing: Spacing.lg,
        runSpacing: Spacing.lg,
        children: List.generate(AppConstants.skeletonCount, (i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(
                width: cardWidth,
                height: cardWidth * 1.5,
                borderRadius: AppBorderRadius.md,
              ),
              const SizedBox(height: Spacing.sm),
              SkeletonLoader(
                width: cardWidth - Spacing.lg,
                height: 14,
                borderRadius: AppBorderRadius.xs,
              ),
              const SizedBox(height: Spacing.xs),
              SkeletonLoader(
                width: cardWidth * 0.5,
                height: 10,
                borderRadius: AppBorderRadius.xs,
              ),
            ],
          );
        }),
      ),
    );
  }
}
