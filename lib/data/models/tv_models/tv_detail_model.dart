import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_entities/tv_detail.dart';
import '../genre_model.dart';

class TvDetailModel extends Equatable {
  const TvDetailModel({
    required this.adult,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.status,
    required this.tagline,
    required this.type,
  });

  final bool? adult;
  final String? backdropPath;
  final String? firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String? name;
  final List<String>? originCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final String? status;
  final String? tagline;
  final String? type;

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        firstAirDate: json["first_air_date"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        originCountry: (json["origin_country"] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList(),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: (json["popularity"]?.toDouble()) ?? 0.0,
        posterPath: json["poster_path"],
        voteAverage: (json["vote_average"]?.toDouble()) ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        status: json["status"],
        tagline: json["tagline"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "first_air_date": firstAirDate,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "id": id,
        "name": name,
        "origin_country": originCountry,
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "status": status,
        "tagline": tagline,
        "type": type,
      };

  TvDetail toEntity() {
    return TvDetail(
      adult: adult,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      genres: genres.map((genre) => genre.toEntity()).toList(),
      id: id,
      name: name,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      status: status,
      tagline: tagline,
      type: type,
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        genres,
        id,
        name,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
        numberOfEpisodes,
        numberOfSeasons,
        status,
        tagline,
        type,
      ];
}
