/// Movie model - equivalent to TypeScript Movie interface
class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final double popularity;
  final String originalLanguage;
  final bool adult;
  final bool video;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.popularity,
    required this.originalLanguage,
    required this.adult,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      originalLanguage: json['original_language'] ?? '',
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'popularity': popularity,
      'original_language': originalLanguage,
      'adult': adult,
      'video': video,
    };
  }
}

/// MovieDetail model
class MovieDetail extends Movie {
  final List<Genre> genres;
  final int runtime;
  final String status;
  final String tagline;
  final int budget;
  final int revenue;
  final List<ProductionCompany> productionCompanies;
  final List<SpokenLanguage> spokenLanguages;
  final String homepage;

  const MovieDetail({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.genreIds,
    required super.popularity,
    required super.originalLanguage,
    required super.adult,
    required super.video,
    required this.genres,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.budget,
    required this.revenue,
    required this.productionCompanies,
    required this.spokenLanguages,
    required this.homepage,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      originalLanguage: json['original_language'] ?? '',
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((g) => Genre.fromJson(g))
              .toList() ??
          [],
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((c) => ProductionCompany.fromJson(c))
              .toList() ??
          [],
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((l) => SpokenLanguage.fromJson(l))
              .toList() ??
          [],
      homepage: json['homepage'] ?? '',
    );
  }
}

/// Genre model
class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

/// CastMember model
class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
      order: json['order'] ?? 0,
    );
  }
}

/// CrewMember model
class CrewMember {
  final int id;
  final String name;
  final String job;
  final String department;
  final String? profilePath;

  const CrewMember({
    required this.id,
    required this.name,
    required this.job,
    required this.department,
    this.profilePath,
  });

  factory CrewMember.fromJson(Map<String, dynamic> json) {
    return CrewMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      job: json['job'] ?? '',
      department: json['department'] ?? '',
      profilePath: json['profile_path'],
    );
  }
}

/// Credits model
class Credits {
  final List<CastMember> cast;
  final List<CrewMember> crew;

  const Credits({required this.cast, required this.crew});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((c) => CastMember.fromJson(c))
              .toList() ??
          [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((c) => CrewMember.fromJson(c))
              .toList() ??
          [],
    );
  }
}

/// ProductionCompany model
class ProductionCompany {
  final int id;
  final String name;
  final String? logoPath;
  final String originCountry;

  const ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoPath: json['logo_path'],
      originCountry: json['origin_country'] ?? '',
    );
  }
}

/// SpokenLanguage model
class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  const SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

/// PaginatedResponse model
class PaginatedResponse<T> {
  final int page;
  final List<T> results;
  final int totalPages;
  final int totalResults;

  const PaginatedResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
}

/// AccountList model
class AccountList {
  final String description;
  final int favoriteCount;
  final int id;
  final int itemCount;
  final String iso6391;
  final String listType;
  final String name;
  final String? posterPath;

  const AccountList({
    required this.description,
    required this.favoriteCount,
    required this.id,
    required this.itemCount,
    required this.iso6391,
    required this.listType,
    required this.name,
    this.posterPath,
  });

  factory AccountList.fromJson(Map<String, dynamic> json) {
    return AccountList(
      description: json['description'] ?? '',
      favoriteCount: json['favorite_count'] ?? 0,
      id: json['id'] ?? 0,
      itemCount: json['item_count'] ?? 0,
      iso6391: json['iso_639_1'] ?? '',
      listType: json['list_type'] ?? '',
      name: json['name'] ?? '',
      posterPath: json['poster_path'],
    );
  }
}
