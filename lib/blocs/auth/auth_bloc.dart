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

    // Simulate API call delay for better UX
    await Future.delayed(const Duration(seconds: 1));

    // **LOGIC CHANGE IS HERE**:
    // The hardcoded credential check has been removed.
    // The UI's Form validation already ensures the email and password meet the required format.
    // Therefore, if this event is received, we can proceed directly to the success state
    // to fulfill the requirement of letting any validly formatted credential log in.

    emit(AuthSuccess(email: event.email));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // This part remains unchanged.
    emit(AuthInitial());
  }
}
