import 'package:dio/dio.dart';
import 'package:splash_login/dio_service.dart';

class ApiService {
  final Dio _dio = DioServices().to(); // 기존의 Dio 객체 생성

  // get
  Future<Response> getUser() async {
    return await _dio.get('/account/tmp');
  }

  // 다른 API 호출 함수들 추가 가능
  
  // post
  Future<Response> loginUser(Map<String, dynamic> userData) async {
    return await _dio.post('/account/check', data: userData);
  }

  Future<Response> signupUser(Map<String, dynamic> userData) async {
    return await _dio.post('/account/signup', data: userData);
  }
  
  // // put
  // Future<Response> putUser(int userId, Map<String, dynamic> userData) async {
  //   return await _dio.put('/api/users/$userId', data: userData);
  // }

  // // delete
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