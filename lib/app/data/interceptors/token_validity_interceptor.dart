// import 'package:dio/dio.dart';
// import 'package:faithconnect/app/core/utils/snackbar.dart';
// import 'package:get/get.dart' as getx;


// class TokenValidityInterceptor extends Interceptor {
//   final TokenStorage _tokenStorage = TokenStorage();

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if (response.data is Map && response.data['status'] == 400 && response.data['message'] == "Invalid access token!") {
//       CustomSnackbar.error("Session expired. Please log in again.");
//       _tokenStorage.clearAll();
//       getx.Get.offAllNamed(Routes.LOGIN);
//       handler.reject(DioException(requestOptions: response.requestOptions, message: "Invalid access token!"));
//     } else {
//       handler.next(response);
//     }
//   }
// }