import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded credentials for demonstration
    const String validEmail = "test@example.com";
    const String validPassword = "Test@123";

    if (event.email == validEmail && event.password == validPassword) {
      emit(AuthSuccess(email: event.email));
    } else {
      emit(const AuthFailure(error: "Invalid email or password"));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInitial());
  }
}
