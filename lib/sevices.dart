import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as gx;
import 'package:happy_chat/controllers/login_controller.dart';
import 'models/contact_model.dart';
import 'models/login_model.dart';
import 'models/token_model.dart';

class Api {
  static const _url = "http://185.204.197.138/api/v1/";
  static final Dio _dio = Dio(BaseOptions(
      baseUrl: _url,
      connectTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status! < 600;
      }));

  static Future<LoginModel> login(String phoneNumber) async {
    try {
      Map<String, dynamic> data = {
        "phone": phoneNumber,
      };
      Response response = await _dio.post("${_url}send-otp", data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data); // چاپ داده دریافتی
        var _signUpResponse = LoginModel.fromJson(response.data as Map<String, dynamic>);
        print("درخواست با موفقیت انجام شد: ${response.data}");
        return _signUpResponse;
      } else if (response.statusCode == 400) {
        //return success;
        var _status = LoginModel.fromJson(response.data as Map<String, dynamic>);
        return _status;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.unknown || e.type == DioExceptionType.connectionError) {
        throw Exception("اتصال به اینترنت برقرار نیست. لطفاً اتصال خود را بررسی کنید.");
      } else {
        throw Exception("خطای شبکه: ${e.response?.statusCode ?? e.message}");
      }
    } catch (e) {
      throw Exception("خطای ناشناخته در login");
    }
    throw Exception("خطای ناشناخته در login");
  }

  static Future<TokenModel> otp(String phoneNumber, int otp) async {
    final log = gx.Get.find<LoginController>();
    try {
      Map<String, dynamic> data = {"phone": phoneNumber, "otp": otp};
      Response response = await _dio.post("${_url}verify-otp", data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        var token = TokenModel.fromJson(response.data as Map<String, dynamic>);
        print("درخواست با موفقیت انجام شد: ${response.data}");
        return token;
      } else if (response.statusCode == 400) {
        log.showValidationErrorOtp.value = true;

        throw Exception(response.data['message'] ?? 'درخواست نامعتبر است.');
      } else {
        throw Exception("خطای پیش‌بینی‌نشده با کد وضعیت: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.unknown || e.type == DioExceptionType.connectionError) {
        throw Exception("اتصال به اینترنت برقرار نیست. لطفاً اتصال خود را بررسی کنید.");
      } else if (e.response?.statusCode == 400) {
        final data = e.response?.data;
        throw Exception(data?['message'] ?? 'درخواست نامعتبر بود.');
      } else {
        throw Exception("خطای شبکه: ${e.response?.statusCode ?? e.message}");
      }
    } catch (e) {
      throw Exception("خطای ناشناخته در login: $e");
    }
  }

  static Future<ContactModel> token(String token) async {
    try {
      Response response = await _dio.get(
        "${_url}contacts",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        var _signUpResponse = ContactModel.fromJson(response.data as Map<String, dynamic>);
        print("درخواست با موفقیت انجام شد: ${response.data}");
        return _signUpResponse;
      } else if (response.statusCode == 400) {
        var _status = ContactModel.fromJson(response.data as Map<String, dynamic>);
        return _status;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.unknown || e.type == DioExceptionType.connectionError) {
        throw Exception("اتصال به اینترنت برقرار نیست. لطفاً اتصال خود را بررسی کنید.");
      } else {
        throw Exception("خطای شبکه: ${e.response?.statusCode ?? e.message}");
      }
    } catch (e) {
      throw Exception("خطای ناشناخته در Contact");
    }
    throw Exception("خطای ناشناخته در Contact");
  }
}
