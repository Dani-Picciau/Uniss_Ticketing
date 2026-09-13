import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/components/professor_request_list/professor_request_list_item.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/professor_request_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ShowProfessorsRequestsList extends StatelessWidget {
  final List<ProfessorRequestUiModel> requests;
  final bool showDeleteButton;
  final bool showReassignButton;
  final VoidCallback? onRefreshRequired;

  const ShowProfessorsRequestsList({
    super.key,
    required this.requests,
    this.showDeleteButton = false,
    this.showReassignButton = false,
    this.onRefreshRequired,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: UnissLabel(
          text: 'Nessuna richiesta al momento.',
          textType: UnissTextType.bodyMedium,
        ),
      );
    }

    return FadeIn(
      offset: const Offset(-50, 0),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return ProfessorRequestListItem(
            request: requests[index],
            showDeleteButton: showDeleteButton,
            showReassignButton: showReassignButton,
            onRefreshRequired: onRefreshRequired,
          );
        },
      ),
    );
  }
}
