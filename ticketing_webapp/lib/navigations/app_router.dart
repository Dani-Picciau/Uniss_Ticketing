import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticketing_webapp/features/bloc/auth_cubit.dart';
import 'package:ticketing_webapp/features/bloc/auth_state.dart';
import 'package:ticketing_webapp/ui/scenes/administrator_user/assigned_administrator_screen.dart';
import 'package:ticketing_webapp/ui/scenes/login/login_screen.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/requesting_professor_screen.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/rup_user_screen.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/rup-dashboard',
        builder: (context, state) {
          return AdminManagerScreen(loginResponse: authCubit.state.user!);
        },
      ),
      GoRoute(
        path: '/professor-dashboard',
        builder: (context, state) {
          return RequestingProfessorScreen();
        },
      ),
      GoRoute(
        path: '/administrator-dashboard',
        builder: (context, state) {
          return AssignedAdministratorScreen();
        },
      ),
    ],

    initialLocation:
        '/login', // Quando l'app parte questa è la prima schermata che viene visualizzata, tramite la stringa '/login' si trova la rotta per il reindirizzamento.
    refreshListenable: GoRouterRefreshStream(
      authCubit
          .stream, // Permette l'ascolto costante del cubit cosi che se l'utente effettua il logut viene richiamato il redirect
    ),

    // Viene eseguito prima di aprire qualsiasi pagina
    redirect: (BuildContext context, GoRouterState state) {
      final authState =
          authCubit.state; // Viene letto lo stato attuale dell'utente
      final isGoingToLogin =
          state.uri.toString() == '/login'; // True se ci troviamo sul login

      // Utente non autenticato che non è già nella pagina di login
      if (authState.status != AuthStatus.authenticated && !isGoingToLogin) {
        return '/login';
        // Quei classici casi dove si prova a cambiare l'url a mano nella barra di ricerca
      }

      // Utente autenticato viene reindirizzato alla dashboard corrispondente
      if (authState.status == AuthStatus.authenticated && isGoingToLogin) {
        final roles =
            authState.user?.roles ?? []; // Recupero i ruoli dal LoginResponse

        // Smistamento basato sui tuoi ruoli, serve un if-else in cascata perché con lo switch non posso usare roles.contains per vedere se un utente ha più ruoli
        if (roles.contains('RUP')) {
          return '/rup-dashboard';
        } else if (roles.contains('DIRETTORE')) {
          return '/login'; // Ancora da definire
        } else if (roles.contains('DOCENTE_RICHIEDENTE')) {
          return '/professor-dashboard';
        } else if (roles.contains('AMMINISTRATORE_ASSEGNATO')) {
          return '/administrator-dashboard';
        } else {
          return '/login'; // Fallback di default
        }
      }
      // Nessun reindirizzamento necessario, lascia passare l'utente
      return null;
    },
  );
}

// Utility necessaria per far "ascoltare" i Cubit a GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
