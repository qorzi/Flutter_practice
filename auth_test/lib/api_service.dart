import 'package:dio/dio.dart';
import 'package:auth_test/dio_service.dart';

class ApiService {
  final Dio _dio = DioServices().to(); // 기존의 Dio 객체 생성
  
  // GET
  Future<Response?> getUser() async {
    try {
      return await _dio.get('/account/tmp');
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }
  
  // POST
  Future<Response?> loginUser(Map<String, dynamic> userData) async {
    try {
      return await _dio.post('/account/check', data: userData);
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }

  Future<Response?> signupUser(Map<String, dynamic> userData) async {
    try {
      return await _dio.post('/account/signup', data: userData);
    } on DioError catch (e) {
      // DioError 처리
      return e.response; // DioError가 발생한 경우에도 무조건 리턴
    }
  }
  
  // PUT
  // Future<Response> putUser(int userId, Map<String, dynamic> userData) async {
  //   return await _dio.put('/api/users/$userId', data: userData);
  // }

  // DELETE
  // Future<Response> deleteUser(int userId) async {
  //   return await _dio.delete('/api/users/$userId');
  // }


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

// // DELETE
// Response getUserResponse = await _apiService.deleteUser(2);