part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => prefs)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ;
  await _onBoardingInit();
  await _languageInit();
  await _authInit();
  await _parentalInfoInit();
  await _digitalWellbeingInit();
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

        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton<GoogleSignIn>(GoogleSignIn.new)
    ..registerLazySingleton(() => FacebookAuth.instance);
}


Future<void> _languageInit() async {
  sl
    ..registerFactory(
      () => LanguageBloc(
        setLanguage: sl(),
        getLanguage: sl(),
      ),
    )
    ..registerLazySingleton(() => SetLanguage(sl()))
    ..registerLazySingleton(() => GetLanguage(sl()))
    ..registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl(sl()))
    ..registerLazySingleton<LanguageLocalDataSource>(
      () => LanguageLocalDataSourceImpl(sl()),
    );
}

Future<void> _parentalInfoInit() async {
  sl
    ..registerFactory(
          () => ParentalInfoBloc(
        saveParentalInfo: sl(),
        getParentalInfo: sl(),
        updateParentalInfo: sl(),
        addChild: sl(),
        updateChild: sl(),
        removeChild: sl(),
        setPin: sl(),
      ),
    )
    ..registerLazySingleton(() => SaveParentalInfoUseCase(sl()))
    ..registerLazySingleton(() => GetParentalInfoUseCase(sl()))
    ..registerLazySingleton(() => UpdateParentalInfoUseCase(sl()))
    ..registerLazySingleton(() => AddChildUseCase(sl()))
    ..registerLazySingleton(() => UpdateChildUseCase(sl()))
    ..registerLazySingleton(() => RemoveChildUseCase(sl()))
    ..registerLazySingleton(() => SetPinUseCase(sl()))
    ..registerLazySingleton<ParentalInfoRepository>(() => ParentalInfoRepoImpl(sl()))
    ..registerLazySingleton<ParentalInfoRemoteDataSource>(
          () => ParentalInfoRemoteDataSourceImpl(
        firestore: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _digitalWellbeingInit() async {
  sl
    ..registerFactory(
          () => DigitalWellbeingBloc(
        getDigitalWellbeing: sl(),
        updateDigitalWellbeing: sl(),
        setUsageLimit: sl(),
        removeUsageLimit: sl(),
        getDigitalWellbeingHistory: sl(),
      ),
    )
    ..registerLazySingleton(() => GetDigitalWellbeingUseCase(sl()))
    ..registerLazySingleton(() => UpdateDigitalWellbeingUseCase(sl()))
    ..registerLazySingleton(() => SetUsageLimitUseCase(sl()))
    ..registerLazySingleton(() => RemoveUsageLimitUseCase(sl()))
    ..registerLazySingleton(() => GetDigitalWellbeingHistoryUseCase(sl()))
    ..registerLazySingleton<DigitalWellbeingRepository>(() => DigitalWellbeingRepoImpl(sl()))
    ..registerLazySingleton<DigitalWellbeingRemoteDataSource>(
          () => DigitalWellbeingRemoteDataSourceImpl(
        firestore: sl(),
        auth: sl(),
      ),
    );
}