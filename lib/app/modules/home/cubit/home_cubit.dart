import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login_with_cubit/app/models/git_model.dart';
import 'package:login_with_cubit/app/repositories/gifs_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GifRepository _repository;
  HomeCubit(this._repository) : super(HomeState.initialState());

  Future<void> findRandomGifs() async {
    try {
      emit(HomeState.loading());
      final gifs = await _repository.getRandomGif();
      emit(HomeState.result(gifs));
    } catch (e) {
      print(e);
      emit(HomeState.error('Erro ao Buscar Gifs'));
    }
  }

  Future<void> findGif(String value) async {
    try {
      emit(HomeState.loading());
      final gifs = await _repository.searchGif(value);
      emit(HomeState.result(gifs));
    } catch (e) {
      print(e);
      emit(HomeState.error('Erro ao Buscar Gifs'));
    }
  }

  Future<void> selectGif(GifModel gif)  async {
    print(gif);
    emit(state.copyWith(loading: false, gifSelecionado: gif));
  }
}
