part of 'route.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        final prefs = sl<SharedPreferences>();
        if (prefs.getBool(kFirstTimerKey) ?? true) {
          return _pageBuilder(
            BlocProvider(
              create: (_) => sl<OnBoardingCubit>(),
              child: const OnBoardingScreen(),
            ),
            state,
          );
        } else if (sl<FirebaseAuth>().currentUser != null) {
          final user = sl<FirebaseAuth>().currentUser!;
          final localUser = LocalUserModel(
            uid: user.uid,
            phoneNumber: user.phoneNumber ?? '',
            email: user.email ?? '',
            username: '',
          );
          return _pageBuilder(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<UserSession>(
                  create: (_) => UserSession(sl<SharedPreferences>()),
                ),
                ChangeNotifierProvider<UserProvider>(
                  create: (context) => UserProvider(sl<AuthenticationRepository>(), context.read<UserSession>()),
                ),
                BlocProvider<AuthBloc>(
                  create: (_) => sl<AuthBloc>(),
                ),
              ],
              child: const Dashboard(),
            ),
            state,
          );
        }
        return _pageBuilder(
          BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          ),
          state,
        );
      },
      routes: [
        GoRoute(
          path: 'forgot-password',
          pageBuilder: (context, state) {
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const ForgotPasswordScreen(),
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: 'profile-screen',
          pageBuilder: (context, state) {
            return _pageBuilder(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider<UserSession>(
                    create: (_) => UserSession(sl<SharedPreferences>()),
                  ),
                  ChangeNotifierProvider<UserProvider>(
                    create: (context) => UserProvider(sl<AuthenticationRepository>(), context.read<UserSession>()),
                  ),
                  BlocProvider<AuthBloc>(
                    create: (_) => sl<AuthBloc>(),
                  ),
                ],
                child: const UserProfileScreen(),
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: 'account-setting',
          pageBuilder: (context, state) {
            return _pageBuilder(
              const AccountSettingScreen(),
              state,
            );
          },
        ),
        GoRoute(
          path: 'notification-setting',
          pageBuilder: (context, state) {
            return _pageBuilder(
              const NotificationSettingScreen(),
              state,
            );
          },
        ),
        GoRoute(
          path: 'appearance-setting',
          pageBuilder: (context, state) {
            return _pageBuilder(
              const AppearanceSetting(),
              state,
            );
          },
        ),
        GoRoute(
          path: 'verify-email/:email',
          pageBuilder: (context, state) {
            final email = state.pathParameters['email'];
            final extra = state.extra as Map<String, dynamic>?;
            final prefs = sl<SharedPreferences>();
            final userSession = Get.put(UserSession(prefs));

            return _pageBuilder(
              MultiProvider(
                providers: [
                  Provider<UserSession>.value(value: userSession),
                  ChangeNotifierProvider<UserProvider>(
                    create: (_) => UserProvider(sl<AuthenticationRepository>(), context.read<UserSession>()),
                  ),
                  BlocProvider<AuthBloc>(
                    create: (_) => sl<AuthBloc>(),
                  ),
                ],
                child: VerifyEmailScreen(
                  email: email,
                  name: extra!['name'] as String,
                  password: extra['password'] as String,
                ),
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: 'signup-with-email',
          pageBuilder: (context, state) {
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignupWithEmailScreen(),
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: 'no-connection',
          pageBuilder: (context, state) {
            return _pageBuilder(const NoConnectionScreen(), state);
          },
        ),
        GoRoute(
          path: SignInScreen.routeName,
          pageBuilder: (context, state) {
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignInScreen(),
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: SignupScreen.routeName,
          pageBuilder: (context, state) {
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const SignupScreen(),
              ),
              state,
            );
          },
        ),
      ],
    ),
  ],
  redirect: (_, state) {
    // Add your redirect logic here if needed
  },
);

CustomTransitionPage<dynamic> _pageBuilder(Widget page, GoRouterState state) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      child: child,
    ),
  );
}