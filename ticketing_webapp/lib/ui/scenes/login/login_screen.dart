import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/data/network/api_client.dart';
import 'package:ticketing_webapp/data/repositories/auth_api.dart';
import 'package:ticketing_webapp/data/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/admin_manager_screen.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import '../../themes/text_themes/uniss_text_theme.dart';
import '../../components/label/uniss_label.dart';
import '../../components/common_input_field/input_field.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/scenes/login/bloc/login_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/login/bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // I controller vengono dichiarati nello State
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    // Inizializzati quando il widget viene creato
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Vengono distrutti per liberare memoria
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // 0. Creiamo il SessionManager
        final sessionManager = SessionManager();

        // 1. Creiamo il client HTTP passandogli il SessionManager
        final apiClient = ApiClient(sessionManager: sessionManager);

        // 2. Creiamo l'API passando sia il client che il SessionManager
        final authApi = AuthApi(
          apiClient: apiClient,
          sessionManager: sessionManager,
        );

        // 3. Creiamo il Cubit passando l'API
        return LoginCubit(authApi: authApi);
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: context.colors.backgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    MediaConstants.dipLogo,
                    width: 130,
                    height: 130,
                  ),
                  UnissLabel(
                    text: 'Welcome to DING-Ticket',
                    textType: UnissTextType.headingLarge,
                  ),
                  SizedBox(height: 16),
                  UnissLabel(
                    text: 'Accedi al tuo account',
                    textType: UnissTextType.bodyLarge,
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 275,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: context.colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: context
                              .colors
                              .blackAlpha015, // colore + opacità dell'ombra
                          blurRadius: 20, // quanto è sfumata (come blur in CSS)
                          spreadRadius:
                              0, // quanto si espande oltre il bordo del container
                          offset: Offset(
                            0,
                            4,
                          ), // spostamento X, Y (come box-shadow in CSS)
                        ),
                      ],
                    ),
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state.status == LoginStatus.success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminManagerScreen(
                                loginResponse: state.loginResponse!,
                              ),
                            ),
                          );
                        }
                        if (state.status == LoginStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildMessangerSnackBar(
                              context,
                              text: 'Email o password non valide',
                              iconPath: MediaConstants.error,
                              textColor: context.colors.white,
                              backgroundColor: context.colors.errorMessage,
                            ),
                          );
                        }
                        if (state.status == LoginStatus.warning) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildMessangerSnackBar(
                              context,
                              text: 'Per favore, compila tutti i campi',
                              iconPath: MediaConstants.warning,
                              textColor: context.colors.white,
                              backgroundColor: context.colors.warningMessage,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            CommonInputField(
                              controller: emailController,
                              label: 'Email',
                              labelColor: context.colors.gray,
                              labelStyle: unissTextTheme.labelMedium,
                              inputStyle: unissTextTheme.bodySmall,
                            ),
                            SizedBox(height: 16),
                            CommonInputField(
                              controller: passwordController,
                              label: 'Password',
                              labelColor: context.colors.gray,
                              labelStyle: unissTextTheme.labelMedium,
                              inputStyle: unissTextTheme.bodySmall,
                              isPassword: true,
                            ),
                            SizedBox(height: 36),
                            state.status == LoginStatus.loading
                                ? const CircularProgressIndicator()
                                : UnissFilledButton(
                                    text: 'Accedi',
                                    onPressed: () {
                                      // Chiamata al metodo del cubit con i dati dei controller
                                      context.read<LoginCubit>().login(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                    },
                                  ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
