import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models.dart';
import '../utils.dart';
import 'rating_badge.dart';
import '../../store/movie_store.dart';
import '../../features/movie_detail/movie_detail_screen.dart';

/// MovieCard — equivalent to React Native MovieCard.tsx
class MovieCard extends StatefulWidget {
  final Movie movie;
  final int index;
  final String heroContext;

  const MovieCard({
    super.key,
    required this.movie,
    this.index = 0,
    this.heroContext = 'poster',
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Staggered entrance delay
    final delay = (widget.index.clamp(0, 12)) * 55;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - Spacing.lg * 3) / 2;
    final cardHeight = cardWidth * 1.5;

    final posterUrl = ImageUtils.getPosterUrl(widget.movie.posterPath);
    final year = FormatUtils.formatYear(widget.movie.releaseDate);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(
                  movieId: widget.movie.id,
                  movie: widget.movie,
                  heroPrefix: widget.heroContext,
                ),
              ),
            );
          },
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              boxShadow: [
                BoxShadow(
                  color: colors.cardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image container
                Stack(
                  children: [
                    // Poster
                    if (posterUrl != null)
                      Hero(
                        tag: '${widget.heroContext}-${widget.movie.id}',
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                          child: CachedNetworkImage(
                            imageUrl: posterUrl,
                            width: cardWidth,
                            height: cardHeight,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: cardWidth,
                              height: cardHeight,
                              color: colors.surfaceVariant,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: cardWidth,
                              height: cardHeight,
                              color: colors.surfaceVariant,
                              child: const Center(
                                child: Text('🎬', style: TextStyle(fontSize: 40)),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: cardWidth,
                        height: cardHeight,
                        color: colors.surfaceVariant,
                        child: const Center(
                          child: Text('🎬', style: TextStyle(fontSize: 40)),
                        ),
                      ),

                    // Rating badge
                    Positioned(
                      top: Spacing.sm,
                      left: Spacing.sm,
                      child: RatingBadge(
                        rating: widget.movie.voteAverage,
                        size: 'small',
                      ),
                    ),

                    // Favorite button
                    Positioned(
                      top: Spacing.sm,
                      right: Spacing.sm,
                      child: Consumer<MovieStore>(
                        builder: (context, store, _) {
                          final isFav = store.isFavorite(widget.movie.id);
                          return GestureDetector(
                            onTap: () => store.toggleFavorite(widget.movie),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius:
                                    BorderRadius.circular(AppBorderRadius.full),
                              ),
                              child: Center(
                                child: Text(
                                  isFav ? '❤️' : '🤍',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Info
                Padding(
                  padding: const EdgeInsets.all(Spacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (year.isNotEmpty) ...[
                        const SizedBox(height: Spacing.xxs),
                        Text(
                          year,
                          style: AppTypography.caption
                              .copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
