import 'package:local/config/router/router_model.dart';
import 'package:local/presentation/screens.dart';
import 'package:flutter/material.dart';

final routerPublic = <RouterModel>[
  RouterModel(
    name: LoginScreen.name,
    screen: (context, state) => const LoginScreen(),
    title: 'Inicio de sesion',
    patch: '/',
    icon: Icons.home,
    description: 'Welcome to app',
  ),
  RouterModel(
    name: RegisterScreen.name,
    screen: (context, state) => const RegisterScreen(),
    title: 'Inicio de sesion',
    patch: '/register',
    icon: Icons.home,
    description: 'Welcome to register',
  ),
];

final routerAdmin = <RouterModel>[
  RouterModel(
    name: GastoScreen.name,
    screen: (context, state) => const GastoScreen(),
    title: 'Gastos. e Ingresos',
    patch: '/gyi',
    icon: Icons.price_change,
    description: 'Gastos',
  ),
];
