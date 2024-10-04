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
          return _pageBuilder(
            MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (_) => sl<AuthBloc>(),
                ),
                BlocProvider<DigitalWellbeingBloc>(
                  create: (_) => sl<DigitalWellbeingBloc>(),
                ),
                BlocProvider<ParentalInfoBloc>(
                  create: (_) => sl<ParentalInfoBloc>(),
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
              MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>(
                    create: (_) => sl<AuthBloc>(),
                  ),
                  BlocProvider<ParentalInfoBloc>(
                    create: (_) => sl<ParentalInfoBloc>(),
                  ),
                ],
                child: const UserProfileScreen(),
              ),
              state,
            );
          },
          routes: [
            GoRoute(
              path: 'edit-parental-info',
              pageBuilder: (context, state) => _pageBuilder(
                BlocProvider(
                  create: (_) => sl<ParentalInfoBloc>(),
                  child: EditParentalInfoPage(
                    initialParentalInfo: state.extra as ParentalInfo,
                  ),
                ),
                state,
              ),
            ),
            GoRoute(
              path: 'parental-mode',
              pageBuilder: (context, state) => _pageBuilder(
                BlocProvider(
                  create: (_) => sl<ParentalInfoBloc>(),
                  child: const ManageParentalScreen(),
                ),
                state,
              ),
              routes: [
                GoRoute(
                  path: 'add-child',
                  builder: (context, state) {
                    final onChildAdded = state.extra as Function(Child);
                    return BlocProvider(
                      create: (_) => sl<ParentalInfoBloc>(),
                      child: AddChildForm(onChildAdded: onChildAdded),
                    );
                  },
                ),
                GoRoute(
                  path: 'create-profile',
                  pageBuilder: (context, state) => _pageBuilder(
                    BlocProvider(
                      create: (_) => sl<ParentalInfoBloc>(),
                      child: const CreateProfileFormBody(),
                    ),
                    state,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'language-selection',
          pageBuilder: (context, state) {
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<LanguageBloc>(),
                child: const LanguageSelectionPage(),
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: 'account-setting',
          pageBuilder: (context, state) {
            return _pageBuilder(
              BlocProvider(
                create: (_) => sl<AuthBloc>(),
                child: const AccountSettingScreen(),
              ),
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

            return _pageBuilder(
              MultiProvider(
                providers: [
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
          path: 'terms-of-service',
          pageBuilder: (context, state) {
            return _pageBuilder(
              const TermsOfServiceScreen(),
              state,
            );
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
  redirect: (_, state) {},
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
