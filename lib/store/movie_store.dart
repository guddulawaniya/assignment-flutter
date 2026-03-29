import 'package:flutter/material.dart';
import '../shared/models.dart';
import '../api/movie_service.dart';
import '../services/storage_service.dart';
import '../services/logger.dart';
import '../shared/constants.dart';

/// MovieStore — equivalent to React Native useMovieStore.ts
/// Manages trending, search, detail, favorites, genres state
class MovieStore extends ChangeNotifier {
  // ── Trending ──────────────────────────────────────────────────────────────
  List<Movie> _trendingMovies = [];
  int _trendingPage = 1;
  int _trendingTotalPages = 1;
  bool _isTrendingLoading = false;
  bool _isTrendingRefreshing = false;
  bool _isTrendingLoadingMore = false;

  List<Movie> get trendingMovies => _trendingMovies;
  int get trendingPage => _trendingPage;
  int get trendingTotalPages => _trendingTotalPages;
  bool get isTrendingLoading => _isTrendingLoading;
  bool get isTrendingRefreshing => _isTrendingRefreshing;
  bool get isTrendingLoadingMore => _isTrendingLoadingMore;

  // ── Search ────────────────────────────────────────────────────────────────
  List<Movie> _searchResults = [];
  String _searchQuery = '';
  int _searchPage = 1;
  int _searchTotalPages = 1;
  bool _isSearching = false;
  bool _isSearchLoadingMore = false;

  List<Movie> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  int get searchPage => _searchPage;
  int get searchTotalPages => _searchTotalPages;
  bool get isSearching => _isSearching;
  bool get isSearchLoadingMore => _isSearchLoadingMore;

  // ── Detail ────────────────────────────────────────────────────────────────
  MovieDetail? _movieDetail;
  Credits? _movieCredits;
  List<Movie> _similarMovies = [];
  bool _isDetailLoading = false;

  MovieDetail? get movieDetail => _movieDetail;
  Credits? get movieCredits => _movieCredits;
  List<Movie> get similarMovies => _similarMovies;
  bool get isDetailLoading => _isDetailLoading;

  // ── Favorites ─────────────────────────────────────────────────────────────
  List<Movie> _favorites = [];
  List<Movie> get favorites => _favorites;

  // ── Genres ────────────────────────────────────────────────────────────────
  List<Genre> _genres = [];
  List<Genre> get genres => _genres;

  // ── Errors ────────────────────────────────────────────────────────────────
  String? _error;
  bool _isMoreError = false;

  String? get error => _error;
  bool get isMoreError => _isMoreError;

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> fetchTrending({bool refresh = false}) async {
    if (_isTrendingLoading || _isTrendingRefreshing) {
      return;
    }

    _isTrendingLoading = !refresh;
    _isTrendingRefreshing = refresh;
    _error = null;
    notifyListeners();

    try {
      final response = await MovieService.getTrending(page: 1);
      _trendingMovies = response.results;
      _trendingPage = 1;
      _trendingTotalPages = response.totalPages;
      _isTrendingLoading = false;
      _isTrendingRefreshing = false;
      notifyListeners();

      // Cache for offline
      StorageService.setObjectList<Movie>(
        StorageKeys.cachedTrending,
        response.results,
        (m) => m.toJson(),
      );
    } catch (e) {
      Logger.error('fetchTrending failed', e);
      // Try to load from cache
      final cached = StorageService.getObjectList<Movie>(
        StorageKeys.cachedTrending,
        (json) => Movie.fromJson(json),
      );
      if (cached != null && cached.isNotEmpty) {
        _trendingMovies = cached;
        _trendingPage = 1;
        _trendingTotalPages = 500;
        _isTrendingLoading = false;
        _isTrendingRefreshing = false;
        _error = null;
      } else {
        _isTrendingLoading = false;
        _isTrendingRefreshing = false;
        _error = 'Failed to load trending movies. Please check your connection.';
      }
      notifyListeners();
    }
  }

  Future<void> loadMoreTrending() async {
    if (_isTrendingLoadingMore || _trendingPage >= _trendingTotalPages) {
      return;
    }

    _isTrendingLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _trendingPage + 1;
      final response = await MovieService.getTrending(page: nextPage);
      _trendingMovies = [..._trendingMovies, ...response.results];
      _trendingPage = nextPage;
      _trendingTotalPages = response.totalPages;
      _isTrendingLoadingMore = false;
      _isMoreError = false;
      notifyListeners();
    } catch (e) {
      Logger.error('loadMoreTrending failed', e);
      _isTrendingLoadingMore = false;
      _isMoreError = true;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchQuery = query;
    _error = null;
    notifyListeners();

    try {
      final response = await MovieService.searchMovies(query, page: 1);
      _searchResults = response.results;
      _searchPage = 1;
      _searchTotalPages = response.totalPages;
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      Logger.error('searchMovies failed', e);
      _isSearching = false;
      _error = 'Search failed. Please try again.';
      notifyListeners();
    }
  }

  Future<void> loadMoreSearch() async {
    if (_isSearchLoadingMore ||
        _searchPage >= _searchTotalPages ||
        _searchQuery.isEmpty) {
      return;
    }

    _isSearchLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _searchPage + 1;
      final response =
          await MovieService.searchMovies(_searchQuery, page: nextPage);
      _searchResults = [..._searchResults, ...response.results];
      _searchPage = nextPage;
      _isSearchLoadingMore = false;
      _isMoreError = false;
      notifyListeners();
    } catch (e) {
      Logger.error('loadMoreSearch failed', e);
      _isSearchLoadingMore = false;
      _isMoreError = true;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    _searchPage = 1;
    _isSearching = false;
    notifyListeners();
  }

  Future<void> fetchMovieDetail(int id) async {
    _isDetailLoading = true;
    _movieDetail = null;
    _movieCredits = null;
    _similarMovies = [];
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        MovieService.getMovieDetail(id),
        MovieService.getMovieCredits(id),
        MovieService.getSimilarMovies(id),
      ]);

      _movieDetail = results[0] as MovieDetail;
      _movieCredits = results[1] as Credits;
      _similarMovies = (results[2] as PaginatedResponse<Movie>).results;
      _isDetailLoading = false;
      notifyListeners();
    } catch (e) {
      Logger.error('fetchMovieDetail failed', e);
      _isDetailLoading = false;
      _error = 'Failed to load movie details.';
      notifyListeners();
    }
  }

  void toggleFavorite(Movie movie) {
    final exists = _favorites.any((f) => f.id == movie.id);
    if (exists) {
      _favorites = _favorites.where((f) => f.id != movie.id).toList();
    } else {
      _favorites = [movie, ..._favorites];
    }
    notifyListeners();
    StorageService.setObjectList<Movie>(
      StorageKeys.favorites,
      _favorites,
      (m) => m.toJson(),
    );
  }

  bool isFavorite(int id) {
    return _favorites.any((f) => f.id == id);
  }

  void loadFavorites() {
    final cached = StorageService.getObjectList<Movie>(
      StorageKeys.favorites,
      (json) => Movie.fromJson(json),
    );
    if (cached != null) {
      _favorites = cached;
      notifyListeners();
    }
  }

  Future<void> fetchGenres() async {
    try {
      final genresList = await MovieService.getGenres();
      _genres = genresList;
      notifyListeners();
      // Cache genres
      StorageService.setObjectList<Genre>(
        StorageKeys.cachedGenres,
        genresList,
        (g) => g.toJson(),
      );
    } catch (e) {
      Logger.error('fetchGenres failed', e);
      final cached = StorageService.getObjectList<Genre>(
        StorageKeys.cachedGenres,
        (json) => Genre.fromJson(json),
      );
      if (cached != null) {
        _genres = cached;
        notifyListeners();
      }
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
