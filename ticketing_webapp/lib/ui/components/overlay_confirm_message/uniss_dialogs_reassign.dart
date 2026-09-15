import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/autocomplete_field.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/overlay_confirm_message/bloc/reassign_cubit.dart';
import 'package:ticketing_webapp/ui/components/overlay_confirm_message/bloc/reassign_state.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissDialogsReassign {
  static void showReassignDialog(
    BuildContext context, {
    required String targetId,
    required VoidCallback onSuccess,
    bool isProcedure = false,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chiudi',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return BlocProvider(
          create: (context) {
            return ReassignCubit(
              procedureApi: context.read<ProcedureApi>(),
              professorRequestApi: context.read<ProfessorRequestApi>(),
            )..fetchAdministrators();
          },

          child: Builder(
            builder: (innerContext) {
              return Center(
                child: Material(
                  color: innerContext.colors.transparent,
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: innerContext.colors.warmPaper,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: BlocConsumer<ReassignCubit, ReassignState>(
                      listener: (context, state) {
                        if (state.status == ReassignStatus.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildMessangerSnackBar(
                              context,
                              text: 'Riassegnazione avvenuta con successo!',
                              iconPath: MediaConstants.success,
                              textColor: context.colors.white,
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                          onSuccess();
                        }
                        if (state.status == ReassignStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildMessangerSnackBar(
                              context,
                              text: state.errorMessage ?? 'Errore sconosciuto',
                              iconPath: MediaConstants.error,
                              textColor: context.colors.white,
                              backgroundColor: context.colors.errorMessage,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status == ReassignStatus.loadingInitial) {
                          return const Center(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UnissLabel(
                              text: isProcedure
                                  ? 'Riassegna procedura'
                                  : 'Riassegna richiesta',
                              textType: UnissTextType.headingMedium,
                            ),

                            const SizedBox(height: 16),

                            CommonAutocompleteField(
                              label: 'Amministratore assegnato',
                              labelStyle: unissTextTheme.bodySmall,
                              inputStyle: unissTextTheme.bodySmall,
                              border: const OutlineInputBorder(),
                              options: state.assignedAdministrator
                                  .map((p) => p.displayName)
                                  .toList(),
                              onChanged: (value) => innerContext
                                  .read<ReassignCubit>()
                                  .administratorChanged(value),
                              onSelected: (value) => innerContext
                                  .read<ReassignCubit>()
                                  .administratorChanged(value),
                              errorText:
                                  state
                                          .selectedAdministratorName
                                          .displayError !=
                                      null
                                  ? 'Selezione obbligatoria'
                                  : null,
                            ),

                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                state.status == ReassignStatus.submitting
                                    ? const CircularProgressIndicator()
                                    : UnissFilledButton(
                                        text: 'Riassegna',
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          255,
                                          214,
                                          149,
                                        ),
                                        textColor: state.isValid
                                            ? const Color(0xFFD35400)
                                            : null,
                                        onPressed: state.isValid
                                            ? () {
                                                context
                                                    .read<ReassignCubit>()
                                                    .submitReassignment(
                                                      targetId,
                                                      isProcedure,
                                                    );
                                              }
                                            : null,
                                      ),
                                UnissFilledButton(
                                  text: 'Annulla',
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    40,
                                    40,
                                    40,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          // Animazione in etrata e in uscita
        );
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(0, -0.15),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
