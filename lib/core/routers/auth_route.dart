import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/authentication_bloc.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../depedency_injection/injection.dart';
import '../extensions/go_router_state_extension.dart';
import 'routergo.dart';

final authRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.rootNavigatorKey,
    path: LoginPage.path,
    pageBuilder: (context, state) {
      return state.fadeTransition(
        child: BlocProvider(
          create: (context) => getIt<AuthenticationBloc>(),
          child: const LoginPage(),
        ),
      );
    },
    routes: [],
  ),
];
