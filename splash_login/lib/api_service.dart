import 'package:dio/dio.dart';
import 'package:splash_login/dio_service.dart';

class ApiService {
  final Dio _dio = DioServices().to(); // 기존의 Dio 객체 생성

  // get
  Future<Response> getUser(int userId) async {
    return await _dio.get('/api/users/$userId');
  }

  // 다른 API 호출 함수들 추가 가능
  
  // post
  Future<Response> postUser(Map<String, dynamic> userData) async {
    return await _dio.post('/api/users', data: userData);
  }
  
  // put
  Future<Response> putUser(int userId, Map<String, dynamic> userData) async {
    return await _dio.put('/api/users/$userId', data: userData);
  }


}


// ----------------------------------------------------
// 위젯에서 사용하는 방법
// import 'package:splash_login/api_service.dart';

// ApiService _apiService = ApiService();

// // GET 메서드 호출
// Response getUserResponse = await _apiService.getUser(2);

// // POST 메서드 호출
// Map<String, dynamic> userData = {'name': 'John Doe', 'email': 'johndoe@example.com'};
// Response postUserResponse = await _apiService.postUser(userData);

// // PUT 메서드 호출
// Map<String, dynamic> updatedUserData = {'name': 'John Doe Jr.'};
// Response putUserResponse = await _apiService.putUser(2, updatedUserData);