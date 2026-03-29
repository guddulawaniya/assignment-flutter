import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../shared/theme.dart';
import '../../shared/constants.dart';
import '../../shared/models.dart';
import '../../shared/utils.dart';
import '../../shared/components/rating_badge.dart';
import '../../shared/components/error_view.dart';
import '../../shared/components/skeleton_loader.dart';
import '../../store/movie_store.dart';
import '../../store/app_store.dart';

/// MovieDetailScreen — equivalent to React Native MovieDetailScreen.tsx
class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  final Movie? movie;
  final String heroPrefix;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.movie,
    this.heroPrefix = 'poster',
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieStore>().fetchMovieDetail(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStore = context.watch<AppStore>();
    final isDark = appStore.isDark(context);
    final colors = isDark ? AppColors.dark : AppColors.light;
    final screenWidth = MediaQuery.of(context).size.width;
    final backdropHeight = screenWidth * 0.6;

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: colors.background,
        body: Consumer<MovieStore>(
          builder: (context, store, _) {
            final displayMovie = store.movieDetail ?? widget.movie;
            final isActuallyLoading =
                store.isDetailLoading && widget.movie == null;

            // Loading skeleton
            if (isActuallyLoading) {
              return _buildLoadingSkeleton(
                  colors, screenWidth, backdropHeight);
            }

            // Error state
            if (store.error != null || displayMovie == null) {
              return Stack(
                children: [
                  ErrorView(
                    message: store.error ?? 'Movie not found',
                    onRetry: () =>
                        store.fetchMovieDetail(widget.movieId),
                  ),
                  _buildBackButton(colors),
                ],
              );
            }

            final detail = store.movieDetail;
            final cast = store.movieCredits?.cast
                    .take(AppConstants.maxCastDisplay)
                    .toList() ??
                [];
            final director = store.movieCredits?.crew
                .where((c) => c.job == 'Director')
                .firstOrNull;

            final backdropUrl = ImageUtils.getBackdropUrl(
              displayMovie.backdropPath,
              ImageSizes.backdrop.large,
            );
            final posterUrl = ImageUtils.getPosterUrl(
              displayMovie.posterPath,
              ImageSizes.poster.large,
            );
            final isFavorite = store.isFavorite(widget.movieId);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Backdrop ────────────────────────────────────────────
                  SizedBox(
                    height: backdropHeight + 60,
                    child: Stack(
                      children: [
                        // Backdrop image
                        if (backdropUrl != null)
                          CachedNetworkImage(
                            imageUrl: backdropUrl,
                            width: screenWidth,
                            height: backdropHeight,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: colors.surfaceVariant,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: colors.surfaceVariant,
                            ),
                          )
                        else
                          Container(
                            width: screenWidth,
                            height: backdropHeight,
                            color: colors.surfaceVariant,
                          ),

                        // Backdrop overlay
                        Container(
                          width: screenWidth,
                          height: backdropHeight,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),

                        // Back button
                        _buildBackButton(colors),

                        // Favorite button
                        Positioned(
                          top: Spacing.huge,
                          right: Spacing.lg,
                          child: GestureDetector(
                            onTap: () {
                              store.toggleFavorite(displayMovie);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.full),
                              ),
                              child: Center(
                                child: Text(
                                  isFavorite ? '❤️' : '🤍',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Poster overlay
                        if (posterUrl != null)
                          Positioned(
                            bottom: 0,
                            left: Spacing.lg,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.md),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Hero(
                                tag: '${widget.heroPrefix}-${widget.movieId}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.md),
                                  child: CachedNetworkImage(
                                    imageUrl: posterUrl,
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Info Container ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row (offset to right of poster)
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 120),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayMovie.title,
                                  style: AppTypography.h2
                                      .copyWith(color: colors.text),
                                ),
                                if (detail != null &&
                                    detail.tagline.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: Spacing.xs),
                                    child: Text(
                                      detail.tagline,
                                      style: AppTypography.bodySmall
                                          .copyWith(
                                        color: colors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Meta info
                        Row(
                          children: [
                            RatingBadge(
                              rating: displayMovie.voteAverage,
                              size: 'large',
                            ),
                            const SizedBox(width: Spacing.md),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${FormatUtils.formatYear(displayMovie.releaseDate)}'
                                  '${detail != null && detail.runtime > 0 ? ' · ${FormatUtils.formatRuntime(detail.runtime)}' : ''}',
                                  style: AppTypography.bodySmall.copyWith(
                                      color: colors.textSecondary),
                                ),
                                const SizedBox(height: Spacing.xxs),
                                Text(
                                  '${FormatUtils.formatVoteCount(displayMovie.voteCount)} votes',
                                  style: AppTypography.caption.copyWith(
                                      color: colors.textTertiary),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Genres
                        if (detail != null &&
                            detail.genres.isNotEmpty) ...[
                          const SizedBox(height: Spacing.md),
                          Wrap(
                            spacing: Spacing.sm,
                            runSpacing: Spacing.sm,
                            children: detail.genres.map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primaryLight
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.full),
                                  border: Border.all(
                                      color: colors.primaryLight),
                                ),
                                child: Text(
                                  genre.name,
                                  style: AppTypography.caption
                                      .copyWith(
                                          color: colors.primary),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // Director
                        if (director != null) ...[
                          const SizedBox(height: Spacing.md),
                          Row(
                            children: [
                              Text(
                                'Directed by ',
                                style: AppTypography.bodySmall.copyWith(
                                    color: colors.textSecondary),
                              ),
                              Text(
                                director.name,
                                style: AppTypography.bodySmall.copyWith(
                                  color: colors.text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Overview
                        const SizedBox(height: Spacing.xxl),
                        Text(
                          'Overview',
                          style:
                              AppTypography.h3.copyWith(color: colors.text),
                        ),
                        const SizedBox(height: Spacing.sm),
                        Text(
                          displayMovie.overview.isNotEmpty
                              ? displayMovie.overview
                              : 'No overview available.',
                          style: AppTypography.body.copyWith(
                            color: colors.textSecondary,
                            height: 22 / 14,
                          ),
                        ),

                        // Cast
                        if (cast.isNotEmpty) ...[
                          const SizedBox(height: Spacing.xxl),
                          Text(
                            'Cast',
                            style: AppTypography.h3
                                .copyWith(color: colors.text),
                          ),
                          const SizedBox(height: Spacing.md),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: Spacing.md),
                              itemBuilder: (context, index) {
                                final member = cast[index];
                                final profileUrl =
                                    ImageUtils.getProfileUrl(
                                        member.profilePath);
                                return SizedBox(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      if (profileUrl != null)
                                        ClipOval(
                                          child:
                                              CachedNetworkImage(
                                            imageUrl: profileUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) =>
                                                Container(
                                              width: 60,
                                              height: 60,
                                              color: colors
                                                  .surfaceVariant,
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: colors
                                                .surfaceVariant,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Text('👤',
                                                style: TextStyle(
                                                    fontSize: 24)),
                                          ),
                                        ),
                                      const SizedBox(
                                          height: Spacing.xs),
                                      Text(
                                        member.name,
                                        style: AppTypography.caption
                                            .copyWith(
                                                color: colors.text),
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        member.character,
                                        style: AppTypography.caption
                                            .copyWith(
                                          color:
                                              colors.textTertiary,
                                          fontSize: 10,
                                        ),
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        // Information section
                        const SizedBox(height: Spacing.xxl),
                        Text(
                          'Information',
                          style:
                              AppTypography.h3.copyWith(color: colors.text),
                        ),
                        const SizedBox(height: Spacing.md),
                        Wrap(
                          spacing: Spacing.lg,
                          runSpacing: Spacing.lg,
                          children: [
                            _InfoItem(
                              label: 'Status',
                              value: detail?.status ?? 'N/A',
                              colors: colors,
                            ),
                            _InfoItem(
                              label: 'Budget',
                              value: FormatUtils.formatCurrency(
                                  detail?.budget ?? 0),
                              colors: colors,
                            ),
                            _InfoItem(
                              label: 'Revenue',
                              value: FormatUtils.formatCurrency(
                                  detail?.revenue ?? 0),
                              colors: colors,
                            ),
                            _InfoItem(
                              label: 'Language',
                              value: (displayMovie.originalLanguage
                                      .toUpperCase()),
                              colors: colors,
                            ),
                          ],
                        ),

                        // Similar Movies
                        if (store.similarMovies.isNotEmpty) ...[
                          const SizedBox(height: Spacing.xxl),
                          Text(
                            'Similar Movies',
                            style: AppTypography.h3
                                .copyWith(color: colors.text),
                          ),
                          const SizedBox(height: Spacing.md),
                          SizedBox(
                            height: 190,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: store.similarMovies
                                  .take(10)
                                  .length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: Spacing.md),
                              itemBuilder: (context, index) {
                                final movie =
                                    store.similarMovies[index];
                                final simPosterUrl =
                                    ImageUtils.getPosterUrl(
                                        movie.posterPath);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MovieDetailScreen(
                                          movieId: movie.id,
                                          movie: movie,
                                          heroPrefix: 'sim',
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (simPosterUrl != null)
                                          Hero(
                                            tag: 'sim-${movie.id}',
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppBorderRadius.md),
                                              child: CachedNetworkImage(
                                                imageUrl: simPosterUrl!,
                                                width: 100,
                                                height: 150,
                                                fit: BoxFit.cover,
                                                placeholder: (_, __) =>
                                                    Container(
                                                  width: 100,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        colors.surfaceVariant,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      AppBorderRadius.md,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          Container(
                                            width: 100,
                                            height: 150,
                                            decoration:
                                                BoxDecoration(
                                              color: colors
                                                  .surfaceVariant,
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                AppBorderRadius.md,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(
                                            height: Spacing.xs),
                                        Text(
                                          movie.title,
                                          style: AppTypography
                                              .caption
                                              .copyWith(
                                                  color:
                                                      colors.text),
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        // Bottom spacing
                        const SizedBox(height: Spacing.huge),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton(AppColorScheme colors) {
    return Positioned(
      top: Spacing.huge,
      left: Spacing.lg,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppBorderRadius.full),
          ),
          child: const Center(
            child: Text(
              '←',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(
      AppColorScheme colors, double screenWidth, double backdropHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLoader(
          width: screenWidth,
          height: backdropHeight,
          borderRadius: 0,
        ),
        Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonLoader(width: 200, height: 24),
              const SizedBox(height: Spacing.sm),
              const SkeletonLoader(width: 150, height: 16),
              const SizedBox(height: Spacing.lg),
              SkeletonLoader(
                  width: screenWidth - Spacing.xxl * 2, height: 80),
              const SizedBox(height: Spacing.lg),
              const SkeletonLoader(width: 100, height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme colors;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4 - Spacing.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
