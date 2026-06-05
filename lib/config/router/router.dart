import 'package:go_router/go_router.dart';
import 'package:local/config/router/router_group.dart';
import 'package:local/presentation/public/login/login_screen.dart';

final appRoute = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    if (state.matchedLocation.startsWith('/admin')) {
      return "/home";
    }
    // Here you can add authentication logic
    return null;
  },
  routes: [
    ...routerPublic.map(
      (e) => GoRoute(path: e.patch, name: e.name, builder: e.screen),
    ),
    ...routerAdmin.map(
      (e) => GoRoute(path: e.patch, name: e.name, builder: e.screen),
    ),
  ],
  errorBuilder: (context, state) => const LoginScreen(),
);
