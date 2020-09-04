import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';
import 'package:login_with_cubit/app/shared/user_not_found_exception.dart';
import 'package:mockito/mockito.dart';

import '../mock/dio_mocks.dart';

void main() {
  Dio _dio;
  Response _response;
  DioError _dioError;
  LoginRepository _loginRepository;

  setUp(() {
    _dio = MockDio();
    _response = MockResponse();
    _loginRepository = LoginRepository(_dio);
    _dioError = MockDioError();
  });

  group('Test CheckLogin', () {
    test('fazer teste com sucesso', () async {
      // Prepare
      final tokenResponse = 'TOKEN_LOGIN';
      when(_response.data).thenReturn(<String, dynamic>{'token': tokenResponse});
      when(_dio.post(any, data: anyNamed('data'))).thenAnswer((_) async => _response);

      // Execute
      final loginResult = await _loginRepository.checkLogin('login', 'password');

      // Verify
      verify(_dio.post(any, data: anyNamed('data'))).called(1);
      expect(loginResult, equals(tokenResponse));
    });

    test('Deve retornar um UserNotFoundException', () {
      when(_response.statusCode).thenReturn(403);
      when(_dioError.response).thenReturn(_response);
      when(_dio.post(any, data: anyNamed('data'))).thenThrow(_dioError);

      final call = _loginRepository.checkLogin;

      expect(() => call('', ''), throwsA(isA<UserNotFoundException>()));
    });

    test('Deve retornar um Exception', () {
      when(_response.statusCode).thenReturn(500);
      when(_dioError.response).thenReturn(_response);
      when(_dio.post(any, data: anyNamed('data'))).thenThrow(_dioError);

      final call = _loginRepository.checkLogin;

      expect(() => call('', ''), throwsA(isA<Exception>()));
    });
  });
}
