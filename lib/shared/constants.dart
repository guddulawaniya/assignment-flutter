/// API Configuration Constants
class ApiConfig {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String apiKey = 'd5363682af038ae888e83096da22ac88';
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNTM2MzY4MmFmMDM4YWU4ODhlODMwOTZkYTIyYWM4OCIsIm5iZiI6MTc3NDc5NDExMS41NDEsInN1YiI6IjY5YzkzNTdmNjVlNmMxMDU1ZGU0NDY3NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8xF1RJby7x1HjrQ22kW7EfhFg9owxpwsAYtXbEU3YXI';
  static const String accountId = 'account_id';
  static const int timeout = 8000;
}

class ImageSizes {
  static const poster = _PosterSizes();
  static const backdrop = _BackdropSizes();
  static const profile = _ProfileSizes();
}

class _PosterSizes {
  const _PosterSizes();
  final String small = 'w185';
  final String medium = 'w342';
  final String large = 'w500';
  final String original = 'original';
}

class _BackdropSizes {
  const _BackdropSizes();
  final String small = 'w300';
  final String medium = 'w780';
  final String large = 'w1280';
  final String original = 'original';
}

class _ProfileSizes {
  const _ProfileSizes();
  final String small = 'w45';
  final String medium = 'w185';
  final String large = 'h632';
  final String original = 'original';
}

class Endpoints {
  static const String trending = '/trending/movie/week';
  static const String popular = '/movie/popular';
  static const String search = '/search/movie';
  static String movieDetail(int id) => '/movie/$id';
  static String movieCredits(int id) => '/movie/$id/credits';
  static String movieSimilar(int id) => '/movie/$id/similar';
  static const String genres = '/genre/movie/list';
  static const String accountLists = '/account/account_id/lists';
  static const String accountListsV4 =
      '/account/69c9357f65e6c1055de44676/lists';
}

class StorageKeys {
  static const String favorites = 'favorites_list';
  static const String cachedTrending = 'cached_trending';
  static const String cachedGenres = 'cached_genres';
  static const String themeMode = 'theme_mode';
}

class AppConstants {
  static const int debounceDelay = 300;
  static const int pageSize = 20;
  static const int maxCastDisplay = 10;
  static const int skeletonCount = 6;
  static const int animationDuration = 300;
}
