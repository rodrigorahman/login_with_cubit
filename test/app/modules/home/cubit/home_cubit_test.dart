import 'package:flutter_test/flutter_test.dart';
import 'package:login_with_cubit/app/models/git_model.dart';
import 'package:login_with_cubit/app/modules/home/cubit/home_cubit.dart';
import 'package:login_with_cubit/app/repositories/gifs_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGifRepository extends Mock implements GifRepository {}

void main() {
  GifRepository repository;

  setUp(() {
    repository = MockGifRepository();
  });

  blocTest<HomeCubit, HomeState>(
    'should emit gifs to page',
    build: () {
      when(repository.getRandomGif()).thenAnswer((_) async => <GifModel>[]);
      return HomeCubit(repository);
    },
    act: (cubit) => cubit.findRandomGifs(),
    expect: [
      HomeState.loading(),
      HomeState.result([]),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'should emit error to page',
    build: () {
      when(repository.getRandomGif()).thenThrow(Exception());
      return HomeCubit(repository);
    },
    act: (cubit) => cubit.findRandomGifs(),
    expect: [
      HomeState.loading(),
      HomeState.error('Erro ao Buscar Gifs'),
    ],
  );
}
