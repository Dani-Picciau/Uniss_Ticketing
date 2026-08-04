import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/features/bloc/auth_cubit.dart';
import 'package:ticketing_webapp/features/repositories/auth_api.dart';
import 'package:ticketing_webapp/features/repositories/procedure_detail_api.dart';
import 'package:ticketing_webapp/features/repositories/procedure_list_api.dart';
import 'package:ticketing_webapp/navigations/app_router.dart';
import 'package:ticketing_webapp/ui/themes/app_theme.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/bloc/theme_cubit.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/bloc/theme_state.dart';

void main() {
  final sessionManager = SessionManager();
  final apiClient = ApiClient(sessionManager: sessionManager);
  final authApi = AuthApi(apiClient: apiClient, sessionManager: sessionManager);
  final procedureListApi = ProcedureListApi(
    apiClient: apiClient,
    sessionManager: sessionManager,
  );
  final procedureDetailApi = ProcedureDetailApi(
    apiClient: apiClient,
    sessionManager: sessionManager,
  );

  runApp(
    MyApp(
      authApi: authApi,
      sessionManager: sessionManager,
      procedureListApi: procedureListApi,
      procedureDetailApi: procedureDetailApi,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthApi authApi;
  final SessionManager sessionManager;
  final ProcedureListApi procedureListApi;
  final ProcedureDetailApi procedureDetailApi;

  const MyApp({
    super.key,
    required this.authApi,
    required this.sessionManager,
    required this.procedureListApi,
    required this.procedureDetailApi,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authApi),
        RepositoryProvider.value(value: procedureListApi),
        RepositoryProvider.value(value: procedureDetailApi),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(
            create: (context) =>
                AuthCubit(authApi: authApi, sessionManager: sessionManager),
          ),
        ],
        child: Builder(
          builder: (context) {
            final appRouter = AppRouter(context.read<AuthCubit>());

            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: state.themeMode,
                  routerConfig: appRouter.router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
