import 'package:casino_test/src/data/models/character.dart';
import 'package:equatable/equatable.dart';

abstract class MainPageState extends Equatable {}

class InitialMainPageState extends MainPageState {
  @override
  List<Object> get props => [];
}

class LoadingMainPageState extends MainPageState {
  @override
  List<Object> get props => [];
}

class CharactersLoadError extends MainPageState {
  @override
  List<Object> get props => [];
}

class CharactersLoadedMainPageState extends MainPageState {
  final List<Character> characters;
  final int currentPage;
  final bool fetchMore;
  final bool isLoadingMore;

  CharactersLoadedMainPageState(
    this.characters, {
    this.currentPage = 1,
    this.fetchMore = true,
    this.isLoadingMore = false,
  });

  CharactersLoadedMainPageState copyWith({
    List<Character>? characters,
    int? currentPage,
    bool? fetchMore,
    bool? isLoadingMore,
  }) {
    return CharactersLoadedMainPageState(
      characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      fetchMore: fetchMore ?? this.fetchMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [characters, currentPage, fetchMore, isLoadingMore];
}

