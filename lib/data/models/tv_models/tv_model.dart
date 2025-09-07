import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_entities/tv.dart';

class TvModel extends Equatable {
  const TvModel({
    required this.id,
    required this.originalName,
    required this.name,
    required this.overview,
    required this.popularity,
    this.backdropPath,
    this.posterPath,
    this.firstAirDate,
    required this.genreIds,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.originCountry,
    required this.originalLanguage,
  });

  final int id;
  final String originalName;
  final String name;
  final String overview;
  final double popularity;
  final String? backdropPath;
  final String? posterPath;
  final String? firstAirDate;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final List<String> originCountry;
  final String originalLanguage;

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
    id: json["id"],
    originalName: json["original_name"],
    name: json["name"],
    overview: json["overview"],
    popularity: (json["popularity"]?.toDouble()) ?? 0.0,
    backdropPath: json["backdrop_path"],
    posterPath: json["poster_path"],
    firstAirDate: json["first_air_date"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    voteAverage: (json["vote_average"]?.toDouble()) ?? 0.0,
    voteCount: json["vote_count"] ?? 0,
    adult: json["adult"] ?? false,
    originCountry: List<String>.from(json["origin_country"] ?? []),
    originalLanguage: json["original_language"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "original_name": originalName,
    "name": name,
    "overview": overview,
    "popularity": popularity,
    "backdrop_path": backdropPath,
    "poster_path": posterPath,
    "first_air_date": firstAirDate,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "adult": adult,
    "origin_country": originCountry,
    "original_language": originalLanguage,
  };

  Tv toEntity() {
    return Tv(
      id: id,
      originalName: originalName,
      name: name,
      overview: overview,
      popularity: popularity,
      backdropPath: backdropPath,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      originCountry: originCountry,
      genreIds: genreIds,
      voteAverage: voteAverage,
      voteCount: voteCount,
      adult: adult,
      originalLanguage: originalLanguage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    originalName,
    name,
    overview,
    popularity,
    backdropPath,
    posterPath,
    firstAirDate,
    genreIds,
    voteAverage,
    voteCount,
    adult,
    originCountry,
    originalLanguage,
  ];
}
