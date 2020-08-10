part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<GifModel> gifs;
  final bool loading;
  final String errorMessage;
  final GifModel gifSelecionado;

  @override
  bool get stringify => true;

  HomeState({this.gifs, this.loading, this.errorMessage, this.gifSelecionado});

  HomeState.initialState()
      : gifs = [],
        loading = false,
        errorMessage = '',
        gifSelecionado = null;
  HomeState.result(this.gifs)
      : loading = false,
        errorMessage = '',
        gifSelecionado = null;

  HomeState.loading()
      : gifs = [],
        loading = true,
        errorMessage = '',
        gifSelecionado = null;
  
  HomeState.error(this.errorMessage)
      : loading = false,
        gifs = [],
        gifSelecionado = null;

  @override
  List<Object> get props => [gifs, loading, errorMessage, gifSelecionado];

  HomeState copyWith({
    List<GifModel> gifs,
    bool loading,
    String errorMessage,
    GifModel gifSelecionado,
  }) {
    return HomeState(
      gifs: gifs ?? this.gifs,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      gifSelecionado: gifSelecionado ?? this.gifSelecionado,
    );
  }
}
