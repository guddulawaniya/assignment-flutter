import 'api_client.dart';
import '../shared/constants.dart';
import '../shared/models.dart';

/// MovieService — data layer for TMDB API.
/// Equivalent to React Native MovieService.ts
class MovieService {
  static Future<PaginatedResponse<Movie>> getTrending({int page = 1}) async {
    final data = await ApiClient.get(
      Endpoints.trending,
      params: {'page': page.toString()},
    );
    return PaginatedResponse<Movie>(
      page: data['page'] ?? 1,
      results: (data['results'] as List<dynamic>)
          .map((m) => Movie.fromJson(m))
          .toList(),
      totalPages: data['total_pages'] ?? 1,
      totalResults: data['total_results'] ?? 0,
    );
  }

  static Future<PaginatedResponse<Movie>> getPopular({int page = 1}) async {
    final data = await ApiClient.get(
      Endpoints.popular,
      params: {'page': page.toString()},
    );
    return PaginatedResponse<Movie>(
      page: data['page'] ?? 1,
      results: (data['results'] as List<dynamic>)
          .map((m) => Movie.fromJson(m))
          .toList(),
      totalPages: data['total_pages'] ?? 1,
      totalResults: data['total_results'] ?? 0,
    );
  }

  static Future<PaginatedResponse<Movie>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    final data = await ApiClient.get(
      Endpoints.search,
      params: {'query': query, 'page': page.toString()},
    );
    return PaginatedResponse<Movie>(
      page: data['page'] ?? 1,
      results: (data['results'] as List<dynamic>)
          .map((m) => Movie.fromJson(m))
          .toList(),
      totalPages: data['total_pages'] ?? 1,
      totalResults: data['total_results'] ?? 0,
    );
  }

  static Future<MovieDetail> getMovieDetail(int id) async {
    final data = await ApiClient.get(Endpoints.movieDetail(id));
    return MovieDetail.fromJson(data);
  }

  static Future<Credits> getMovieCredits(int id) async {
    final data = await ApiClient.get(Endpoints.movieCredits(id));
    return Credits.fromJson(data);
  }

  static Future<PaginatedResponse<Movie>> getSimilarMovies(
    int id, {
    int page = 1,
  }) async {
    final data = await ApiClient.get(
      Endpoints.movieSimilar(id),
      params: {'page': page.toString()},
    );
    return PaginatedResponse<Movie>(
      page: data['page'] ?? 1,
      results: (data['results'] as List<dynamic>)
          .map((m) => Movie.fromJson(m))
          .toList(),
      totalPages: data['total_pages'] ?? 1,
      totalResults: data['total_results'] ?? 0,
    );
  }

  static Future<List<Genre>> getGenres() async {
    final data = await ApiClient.get(Endpoints.genres);
    return (data['genres'] as List<dynamic>)
        .map((g) => Genre.fromJson(g))
        .toList();
  }
}
