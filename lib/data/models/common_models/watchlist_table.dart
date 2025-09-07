import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/entities/tv_entities/tv.dart';
import '../../../domain/entities/tv_entities/tv_detail.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? overview;
  final String? posterPath;
  final String type; 

  const WatchlistTable({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.type,
  });

  /// Dari MovieDetail
  factory WatchlistTable.fromMovieEntity(MovieDetail movie) => WatchlistTable(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        type: "movie",
      );

  /// Dari TvDetail
  factory WatchlistTable.fromTvEntity(TvDetail tv) => WatchlistTable(
        id: tv.id,
        title: tv.name,
        overview: tv.overview,
        posterPath: tv.posterPath,
        type: "tv",
      );

  /// Dari database
  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
        id: map['id'],
        title: map['title'],
        overview: map['overview'],
        posterPath: map['posterPath'],
        type: map['type'],
      );

  /// Ke database
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'posterPath': posterPath,
        'type': type,
      };

  /// Convert ke entity
  Movie toMovieEntity() => Movie.watchlist(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        
      );


  Tv toTvEntity() => Tv.watchlist(
        id: id,
        name: title,
        overview: overview,
        posterPath: posterPath,
      );

  @override
  List<Object?> get props => [id, title, overview, posterPath, type];
}
