import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fash_food/features/auth/domain/usecases/login_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/register_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fash_food/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_event.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(const AuthInitial()) {
    
    on<CheckAuthRequested>(_onCheckAuthRequested);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<FacebookLoginRequested>(_onFacebookLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthRequested(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(email: event.email, password: event.password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(message: _mapFailureToMessage(e)));
    }
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _registerUseCase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(message: _mapFailureToMessage(e)));
    }
  }

  String _mapFailureToMessage(Object e) {
    String msg = e.toString().replaceAll('Exception: ', '');
    if (msg.contains(']')) {
      msg = msg.split(']').last.trim();
    }
    return msg;
  }

  Future<void> _onGoogleLoginRequested(GoogleLoginRequested event, Emitter<AuthState> emit) async {
    // Implement Google Login logic here
  }

  Future<void> _onFacebookLoginRequested(FacebookLoginRequested event, Emitter<AuthState> emit) async {
    // Implement Facebook Login logic here
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _logoutUseCase();
      emit(const AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
