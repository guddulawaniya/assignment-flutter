import 'api_client.dart';
import '../shared/constants.dart';
import '../shared/models.dart';
import '../services/logger.dart';

/// AccountService — handles TMDB account-scoped endpoints.
/// Equivalent to React Native AccountService.ts
class AccountService {
  static Future<PaginatedResponse<AccountList>> getAccountLists({
    int page = 1,
  }) async {
    final data = await ApiClient.getWithBearer(
      Endpoints.accountListsV4,
      params: {'page': page.toString()},
    );

    final response = PaginatedResponse<AccountList>(
      page: data['page'] ?? 1,
      results: (data['results'] as List<dynamic>)
          .map((l) => AccountList.fromJson(l))
          .toList(),
      totalPages: data['total_pages'] ?? 1,
      totalResults: data['total_results'] ?? 0,
    );

    Logger.info(
      '[AccountAPI] Response | page=${response.page} total_pages=${response.totalPages} results_count=${response.results.length}',
    );

    return response;
  }
}
