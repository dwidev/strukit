import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:strukit/core/routers/auth_route.dart';

abstract class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");
  static final shellProfileKey = GlobalKey<NavigatorState>(debugLabel: "chat");

  static get router => _router;

  static final _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: <RouteBase>[...authRoute],
  );
}
