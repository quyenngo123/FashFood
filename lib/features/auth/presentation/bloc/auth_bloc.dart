import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc chịu trách nhiệm quản lý logic xác thực của ứng dụng.
/// Nó nhận vào các AuthEvent và phát ra các AuthState tương ứng.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    // Đăng ký các Event Handler
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<FacebookLoginRequested>(_onFacebookLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Xử lý sự kiện Đăng nhập
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading()); // Bắt đầu hiện loading

    try {
      // Giả lập thời gian phản hồi từ server (API/Firebase)
      await Future.delayed(const Duration(milliseconds: 1500));

      // 1. Kiểm tra tính hợp lệ của dữ liệu (Validation)
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthFailure(message: 'Vui lòng nhập đầy đủ thông tin'));
        return;
      }
      if (!event.email.contains('@')) {
        emit(const AuthFailure(message: 'Email không hợp lệ'));
        return;
      }
      if (event.password.length < 6) {
        emit(const AuthFailure(message: 'Mật khẩu phải có ít nhất 6 ký tự'));
        return;
      }

      // 2. Trả về thành công (Sẽ thay bằng gọi Firebase Auth thật ở các bước sau)
      emit(AuthSuccess(userId: 'user_123', email: event.email));
    } catch (e) {
      emit(AuthFailure(message: 'Lỗi hệ thống: ${e.toString()}'));
    }
  }

  /// Xử lý sự kiện Đăng ký
  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      if (event.fullName.isEmpty || event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthFailure(message: 'Vui lòng nhập đầy đủ thông tin'));
        return;
      }

      emit(AuthSuccess(userId: 'user_456', email: event.email));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// Xử lý Đăng nhập Google
  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(const AuthSuccess(userId: 'google_user', email: 'user@gmail.com'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// Xử lý Đăng nhập Facebook
  Future<void> _onFacebookLoginRequested(
    FacebookLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(const AuthSuccess(userId: 'fb_user', email: 'user@facebook.com'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// Xử lý Đăng xuất
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const AuthLoggedOut());
  }
}
