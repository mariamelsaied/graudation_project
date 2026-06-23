import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/models/notification_model.dart';
import 'package:graduation_app/services/secure_storage.dart'; 
// import 'notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final SecureStorage _storage = SecureStorage();
  List<NotificationItem> _currentNotifications = [];
  int _currentUnreadCount = 0;

  // جلب قائمة الإشعارات بالكامل
  Future<void> getNotifications() async {
    emit(NotificationLoading());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(NotificationError("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/notifications/my-notifications',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = NotificationResponse.fromJson(response.data);
        _currentNotifications = data.notifications;
        
        // بعد نجاح جلب الإشعارات، بنجيب الـ unread count كمان تلقائياً
        await getUnreadCount(emitLoading: false);
      } else {
        emit(NotificationError("Failed to load notifications"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(NotificationError(errorMessage));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // جلب عدد الإشعارات غير المقروءة فقط
  Future<void> getUnreadCount({bool emitLoading = true}) async {
    if (emitLoading) emit(NotificationLoading());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(NotificationError("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/notifications/unread-count',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        _currentUnreadCount = response.data['data']['unreadCount'] ?? 0;

        emit(NotificationSuccess(
          notifications: _currentNotifications,
          unreadCount: _currentUnreadCount,
        ));
      } else {
        emit(NotificationError("Failed to load unread count"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(NotificationError(errorMessage));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // تصفير العداد محلياً عند دخول صفحة الإشعارات
  void clearUnreadCount() {
    _currentUnreadCount = 0;
    emit(NotificationSuccess(
      notifications: _currentNotifications,
      unreadCount: _currentUnreadCount,
    ));
  }
}