import 'package:dio/dio.dart';
import 'package:login_with_cubit/app/shared/user_not_found_exception.dart';

class LoginRepository implements ILoginRepository {

  Future<String> checkLogin(String login, String password) async {
    try {
      final dio = Dio();
      final response = await dio.post('http://localhost:8888/auth/login',
        data: {'login': login, 'password': password}
      );

      return response?.data['token'];
      
    } on DioError catch (e) {
      
      if(e.response.statusCode == 403) {
        throw UserNotFoundException();
      }

      throw Exception();
    }
  }

}

abstract class ILoginRepository {
}
