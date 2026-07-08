import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/appbar/common_appbar.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/side_menu/side_menu.dart';
import 'package:ticketing_webapp/ui/components/sliding_menu/sliding_menu.dart';
import 'package:ticketing_webapp/ui/components/wave_clipper.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/bloc/admin_manager_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/bloc/admin_manager_state.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/config/admin_manager_menu_config.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class AdminManagerScreen extends StatelessWidget {
  const AdminManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminManagerCubit(),
      child: Scaffold(
        extendBodyBehindAppBar: true,

        appBar: CommonAppbar(),

        body: Stack(
          // Serve per sovrapporre sfondo, wave e schermata informazioni
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: context.colors.backgroundGradient2,
              ),
            ),

            ClipPath(
              clipper: WaveClipper(), // Richiamiamo la classe creata prima
              child: Container(
                width: double.infinity,
                height: 370, // Quanto scende l'onda prima di fermarsi
                // Un bianco semitrasparente sta benissimo sui gradienti!
                color: context.colors.whiteAlpha03,
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.only(
                left: 16,
                right: 16,
                top: 80,
                bottom: 16,
              ),
              child: FadeIn(
                offset: const Offset(0, -250),
                duration: const Duration(
                  milliseconds: 1000,
                ), // Dall'alto verso il basso
                // Animazione al caricamento
                child: BlocBuilder<AdminManagerCubit, AdminManagerState>(
                  builder: (context, state) {
                    final sidebarItems = AdminManagerMenuConfig.getSidebarItems(
                      state.currentTabIndex,
                    );
                    return LayoutBuilder(
                      builder: (context, outerConstraints) {
                        final isDesktop = outerConstraints.maxWidth > 800;

                        final header = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UnissLabel(
                              text: 'Salve Patrizia',
                              textType: UnissTextType.headingLarge,
                              color: context.colors.black,
                            ),
                            SlidingMenu(
                              selectedIndex: state.currentTabIndex,
                              onMenuChanged: (index) => context
                                  .read<AdminManagerCubit>()
                                  .changeTab(index),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );

                        final whiteBox = Container(
                          decoration: BoxDecoration(
                            color: context.colors.warmPaper,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.blackAlpha015,
                                blurRadius: 20,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Flex(
                              direction: isDesktop
                                  ? Axis.horizontal
                                  : Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: isDesktop ? 280 : double.infinity,
                                  child: SideMenu(
                                    items: sidebarItems,
                                    selectedIndex: state.currentSidebarIndex,
                                    onMenuChanged: (index) => context
                                        .read<AdminManagerCubit>()
                                        .changeSidebarTab(index),
                                  ),
                                ),
                                const SizedBox(width: 16, height: 16),
                                Container(
                                  width: isDesktop ? 2 : null,
                                  height: isDesktop ? null : 2,
                                  decoration: BoxDecoration(
                                    color: context.colors.lightGray,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                // Contenuto: scroll interno solo su desktop
                                isDesktop
                                    ? const Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [/* contenuto */],
                                          ),
                                        ),
                                      )
                                    : const Column(
                                        children: [
                                          /* contenuto */
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        );

                        if (isDesktop) {
                          return Column(
                            children: [
                              header,
                              Expanded(child: whiteBox),
                            ],
                          );
                        } else {
                          return ScrollConfiguration(
                            behavior: ScrollConfiguration.of(
                              context,
                            ).copyWith(scrollbars: false),
                            child: SingleChildScrollView(
                              child: Column(children: [header, whiteBox]),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
