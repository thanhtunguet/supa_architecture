import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supa_architecture/data/secure_authentication_info.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/data/tenant_authentication.dart';
import 'package:supa_architecture/supa_architecture.dart';

class PortalAuthenticationRepository extends ApiClient {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(path: '/rpc/portal/mobile/authentication')
      .toString();

  changeSavedTenant(Tenant tenant) {
    persistentStorageService.tenant = tenant;
  }

  Future<void> createToken(Tenant tenant) async {
    return dio
        .post(
          '/create-token',
          data: tenant.toJSON(),
        )
        .then((response) => response.data);
  }

  Future<AppUser> getProfile() async {
    final url = Uri.parse(baseUrl)
        .replace(
          path: '/rpc/portal/app-user-profile/get',
        )
        .toString();
    return dio.post(url, data: {}).then(
      (response) {
        response.data['id'] = response.data['userId'];
        return response.body<AppUser>();
      },
    );
  }

  Future<List<Tenant>> listTenant() async {
    return dio.post(
      '/list-tenant',
      data: {},
    ).then(
      (response) => response.bodyAsList<Tenant>(),
    );
  }

  Future<int> countTenant() async {
    return dio.post(
      '/count-tenant',
      data: {},
    ).then(
      (response) => (response.data as num).toInt(),
    );
  }

  TenantAuthentication? loadAuthentication() {
    final tenant = persistentStorageService.tenant;
    final appUser = persistentStorageService.appUser;

    if (tenant != null && appUser != null) {
      return TenantAuthentication(tenant, appUser);
    }

    return null;
  }

  /// Password Login
  Future<List<Tenant>> login(
      String username, String password, String captcha) async {
    return dio.post('/login', data: {
      'username': username,
      'password': password,
      'captcha': captcha,
      'osName': kIsWeb
          ? 'WEB'
          : Platform.isAndroid
              ? 'ANDROID'
              : 'IOS',
    }).then((response) => response.bodyAsList<Tenant>());
  }

  /// Apple Login
  Future<List<Tenant>> loginWithApple(String idToken) async {
    return dio.post(
      '/apple-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  Future<List<Tenant>> loginWithBiometric() async {
    final authInfo = await secureStorageService.getSavedAuthenticationInfo();
    await refreshToken(
      refreshToken: authInfo?.refreshToken,
    );
    return listTenant();
  }

  /// Google Login
  Future<List<Tenant>> loginWithGoogle(String idToken) async {
    return dio.post(
      '/google-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  /// Microsoft Login
  Future<List<Tenant>> loginWithMicrosoft(String idToken) async {
    return dio.post(
      '/microsoft-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  Future<bool> logout() async {
    await _removeAuthentication();
    return dio.post(
      '/logout',
      data: {},
    ).then((response) => response.bodyAsBoolean());
  }

  Future<void> refreshToken({
    String? refreshToken,
  }) async {
    final dio = Dio();
    dio.interceptors.add(cookieStorageService.getCookieManager());
    dio.options.baseUrl = persistentStorageService.baseApiUrl;

    final refreshTokenUrl = Uri.parse(persistentStorageService.baseApiUrl)
        .replace(path: '/rpc/portal/authentication/refresh-token')
        .toString();

    return dio
        .post(
          refreshTokenUrl,
          data: {},
          options: Options(
            headers: refreshToken != null
                ? {
                    'cookie': 'RefreshToken=$refreshToken',
                  }
                : null,
          ),
        )
        .then(
          (response) => response.data,
        );
  }

  saveAuthentication(AppUser appUser, Tenant tenant) async {
    persistentStorageService.tenant = tenant;
    persistentStorageService.appUser = appUser;
    final cookies = await cookieStorageService.getAuthenticationCookies();
    final appToken = AppToken.fromCookies(cookies);
    final SecureAuthenticationInfo authInfo = SecureAuthenticationInfo(
      refreshToken: appToken.refreshToken ?? '',
      accessToken: appToken.accessToken ?? '',
      tenantId: tenant.id.value,
    );
    secureStorageService.saveAuthenticationInfo(authInfo);
  }

  Future<void> _removeAuthentication() async {
    await persistentStorageService.logout();
    await cookieStorageService.logout();
  }

  Future<String> forgotPassword(String email, String captcha) async {
    return dio.post('/forgot-password', data: {
      'email': email,
      'captcha': captcha,
    }).then((response) => response.data);
  }

  Future<List<Tenant>> forgotPasswordOtp(
    String content,
    String password,
    String otpCode,
    String catpcha,
  ) async {
    return dio.post('/forgot-with-otp', data: {
      'content': content,
      'password': password,
      'otpCode': otpCode,
      'captcha': catpcha,
    }).then((response) => response.bodyAsList<Tenant>());
  }
}
