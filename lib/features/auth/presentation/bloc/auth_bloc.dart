import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safenest/core/enum/user/update_user.dart';
import 'package:safenest/features/auth/domain/entities/user.dart';
import 'package:safenest/features/auth/domain/usecase/forgot_password.dart';
import 'package:safenest/features/auth/domain/usecase/logout.dart';
import 'package:safenest/features/auth/domain/usecase/sign_in.dart';
import 'package:safenest/features/auth/domain/usecase/sign_in_with_facebook.dart';
import 'package:safenest/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:safenest/features/auth/domain/usecase/sign_up.dart';
import 'package:safenest/features/auth/domain/usecase/update_user.dart';
import 'package:safenest/features/auth/domain/usecase/verify_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required UpdateUser updateUser,
    required ForgotPassword forgotPassword,
    required LogoutUseCase logout,
    required VerifyEmail verifyEmail,
    required SignInWithGoogle signInWithGoogle,
    required SignInWithFacebook signInWithFacebook,
  })  : _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        _forgotPassword = forgotPassword,
        _logout = logout,
        _verifyEmail = verifyEmail,
        _signInWithFacebook = signInWithFacebook,
        _signInWithGoogle = signInWithGoogle,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });

    on<SignInEvent>((event, emit) async => await _signInHandler(event, emit));
    on<SignUpEvent>((event, emit) async => await _signUpHandler(event, emit));
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<LogoutEvent>(_logoutHandler);
    on<VerifyEmailEvent>(_verifyEmailHandler);
    on<GoogleSignInEvent>(_signInWithGoogleHandler);
    on<FacebookSignInEvent>(_signInWithFacebookHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final UpdateUser _updateUser;
  final ForgotPassword _forgotPassword;
  final LogoutUseCase _logout;
  final VerifyEmail _verifyEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithFacebook _signInWithFacebook;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );

    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (user) async => emit(SignedInState(user)),
    );
  }

  Future<void> _signInWithGoogleHandler(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(SocialSignedInState(user)),
    );
  }

  Future<void> _signInWithFacebookHandler(
    FacebookSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signInWithFacebook();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(SocialSignedInState(user)),
    );
  }

  Future<void> _signUpHandler(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final signUpResult = await _signUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    await signUpResult.fold(
      (failure) async => emit(AuthError(failure.message)),
      (_) async {
        final signInResult = await _signIn(
          SignInParams(email: event.email, password: event.password),
        );
        await signInResult.fold(
          (failure) async => emit(AuthError(failure.message)),
          (user) async => emit(SignedInState(user)),
        );
      },
    );
  }

  Future<void> _verifyEmailHandler(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _verifyEmail();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) async {
        final signInResult = await _signIn(
          SignInParams(email: event.email, password: event.password),
        );
        signInResult.fold(
          (signInFailure) => emit(AuthError(signInFailure.message)),
          (user) => emit(SignedInState(user)),
        );
      },
    );
  }

  Future<void> _forgotPasswordHandler(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    final result = await _forgotPassword(
      event.email,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const ForgotPasswordSentState()),
    );
  }

  Future<void> _updateUserHandler(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const UserUpdated()),
    );
  }

  Future<void> _logoutHandler(
      LogoutEvent event, Emitter<AuthState> emit) async {
    final result = await _logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const LogoutState()),
    );
  }
}
