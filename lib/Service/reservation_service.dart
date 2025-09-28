import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ReservationService {
  static const String baseUrl = "http://192.168.1.105:8000/api";
  final Dio dio = Dio();
  final box = GetStorage();

  String? getToken() => box.read("access_token");

  Future<Response?> fetchReservations(int tableId) async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dio.get(
        "$baseUrl/showtimeReserv/$tableId",
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Response?> reserveTable(int tableId, Map<String, dynamic> data) async {
    final token = getToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await dio.post(
        "$baseUrl/reserve/$tableId",
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );
    } catch (_) {
      return null;
    }
  }
}
