import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';
import 'package:login_with_cubit/app/shared/user_not_found_exception.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {}
class MockResponse extends Mock implements Response {}
class MockDioError extends Mock implements DioError {}

void main() {
  Dio dio;
  Response response;
  DioError dioError;

  setUp(() {
    print('setUp');
    dio = MockDio();
    response = MockResponse();
    dioError = MockDioError();
  });

  test('Should do login with success', () async {
    final tokenResponse = 'TOKEN_CONEXAO';
    //Conditionals
    when(response.data).thenReturn(<String, dynamic>{'token': tokenResponse});
    when(dio.post(any, data: anyNamed('data'))).thenAnswer((_) async => response);
    final loginRepository = LoginRepository(dio);

    final loginResult = await loginRepository.checkLogin('login', 'password');

    verify(dio.post(any, data: anyNamed('data'))).called(1);

    expect(loginResult, equals(tokenResponse));
  });

  test('should do login with error UserNotFoundException', () {
    when(response.statusCode).thenReturn(403);
    when(dioError.response).thenReturn(response);
    when(dio.post(any, data: anyNamed('data'))).thenThrow(dioError);

    final loginRepository = LoginRepository(dio);
    final call = loginRepository.checkLogin;

    expect(() => call('login', 'password'), throwsA(isA<UserNotFoundException>()));

  });


  test('should do login with error Generic', () {
    when(dio.post(any, data: anyNamed('data'))).thenThrow(Exception());

    final loginRepository = LoginRepository(dio);
    final call = loginRepository.checkLogin;

    expect(() => call('login', 'password'), throwsA(isNot(isA<UserNotFoundException>())));
    expect(() => call('login', 'password'), throwsA(isA<Exception>()));

  });
}
