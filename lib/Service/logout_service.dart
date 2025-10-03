import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class LogoutService {
  final box = GetStorage();
  final Dio dio = Dio();
  final String baseUrl = 'http://192.168.1.102:8000/api'; 
  Future<bool> logout() async {
    final token = box.read('access_token');
    if (token == null) return false;

    try {
      final response = await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        box.remove('access_token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
