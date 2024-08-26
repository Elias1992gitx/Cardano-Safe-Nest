part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => prefs)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => UserSession(prefs))
    ..registerLazySingleton(
      () =>
          CustomHttpClient(sl.get<SharedPreferences>(), sl.get<UserSession>()),
    );
  await _onBoardingInit();
  await _authInit();
}

Future<void> _onBoardingInit() async {
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(sl()),
    );
}

Future<void> _authInit() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        updateUser: sl(),
        forgotPassword: sl(),
        logout: sl(),
        verifyEmail: sl(),
        signInWithGoogle: sl(),
        signInWithFacebook: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => VerifyEmail(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => SignInWithGoogle(sl()))
    ..registerLazySingleton(() => SignInWithFacebook(sl()))
    ..registerLazySingleton<AuthenticationRepository>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        googleSignIn: sl(),
        facebookAuthClient: sl(),
        httpClient: sl(),
        userSession: sl(),
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton<GoogleSignIn>(GoogleSignIn.new)
    ..registerLazySingleton(() => FacebookAuth.instance);
}
