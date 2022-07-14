import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:casino_test/src/data/models/character.dart';
import 'package:casino_test/src/data/repository/characters_repository.dart';
import 'package:casino_test/src/presentation/bloc/main_event.dart';
import 'package:casino_test/src/presentation/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

//Optimization: we can make is to debounce the Events in order to prevent spamming the API unnecessarily. 
//We can do this by using the transform property
const throttleDuration = Duration(milliseconds: 300);
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  final CharactersRepository _charactersRepository;

  MainPageBloc(
    MainPageState initialState,
    this._charactersRepository,
  ) : super(initialState) {
    on<FetchMainPageEvent>(
      (event, emitter) => _fetchMore(event, emitter),
      //optimization to debounce fetch requests
      transformer: throttleDroppable(throttleDuration),
    );
  }

  @override
  void onEvent(v) {
    super.onEvent(v);
    print("[MainPageEvent] -- ${v.toString()}");
  }

  @override
  void onChange(change) {
    super.onChange(change);
    print(change);
    print("[MainPageEvent Change] -- ${change.toString()}");
  }

  Future<void> _fetchMore(
    FetchMainPageEvent event,
    Emitter<MainPageState> emit,
  ) async {
    if (!_hasReachedMax(state)) {
      try {
        if (state is InitialMainPageState) {
          emit(LoadingMainPageState());

          List<Character>? characters =
              await _charactersRepository.getCharacters(1);
          emit(CharactersLoadedMainPageState(characters!,
              currentPage: 1, fetchMore: true));
        }

        if (state is CharactersLoadedMainPageState) {
          CharactersLoadedMainPageState loaded =
              (state as CharactersLoadedMainPageState);

          emit(loaded.copyWith(isLoadingMore: true));

          int newPage = loaded.currentPage + 1;

          List<Character>? characters =
              await _charactersRepository.getCharacters(newPage);

          if (characters!.length == 0) {
            emit(loaded.copyWith(fetchMore: false, isLoadingMore: false));
          } else {
            emit(CharactersLoadedMainPageState(loaded.characters + characters,
                currentPage: newPage, fetchMore: true, isLoadingMore: false));
          }
        }
      } catch (_) {
        emit(CharactersLoadError());
      }
    }
  }


  //when the characters API returns no more results
  bool _hasReachedMax(MainPageState state) =>
      state is CharactersLoadedMainPageState && !state.fetchMore;
}
