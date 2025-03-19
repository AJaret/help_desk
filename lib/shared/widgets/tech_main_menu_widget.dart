import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/technician_services_bloc/technician_services_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_profile_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_services_history_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_services_screen.dart';

class TechMainMenuWidget extends StatefulWidget {
  const TechMainMenuWidget({super.key});

  @override
  State<TechMainMenuWidget> createState() => _TechMainMenuWidgetState();
}

class _TechMainMenuWidgetState extends State<TechMainMenuWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TechnicianServicesScreen(),
    TechnicianServicesHistoryScreen(),
    TechnicianProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<TechnicianServicesBloc, TechnicianServicesState>(
      listener: (context, state) {
        if (state is GettingTechnicianServices) {
          GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
          showCupertinoDialog(
            context: context,
            builder: (context) => const CupertinoAlertDialog(
              title: Text('Cargando solicitudes'),
              content: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }
        if (state is TechnicianServicesSuccess) {
          GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
        }
        if (state is ErrorGettingTechnicianServices) {
          GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: Center(child: Text(state.message)),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFA10046),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  child: Center(
                    child: Image.asset(
                      'assets/images/logos/sello_logo.png',
                      fit: BoxFit.contain,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 100,
                      minWidth: constraints.maxWidth,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4CBC0),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: _selectedIndex == 0
                                ? BlocBuilder<TechnicianServicesBloc, TechnicianServicesState>(
                                    builder: (context, state) {
                                      if (state is GettingTechnicianServices) {
                                        return const CupertinoActivityIndicator();
                                      } else if (state is TechnicianServicesSuccess) {
                                        return _widgetOptions[_selectedIndex];
                                      } else if (state is ErrorGettingTechnicianServices) {
                                        return Center(
                                          child: IconButton(
                                            onPressed: () => context.read<TechnicianServicesBloc>().add(GetTechnicianServices()),
                                            icon: const Icon(
                                              Icons.sync,
                                              size: 60,
                                            )
                                          ),
                                        );
                                      }
                                      return const TechnicianServicesScreen();
                                    },
                                  )
                                : _widgetOptions[_selectedIndex], 
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          })),
        ),
        floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
            ? FloatingActionButton(
                backgroundColor: const Color(0XFF721530),
                onPressed: () {
                  context
                      .read<TechnicianServicesBloc>()
                      .add(GetTechnicianServices());
                },
                child: const Icon(Icons.sync, color: Colors.white),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: Container(
            color: const Color(0xFFD4CBC0),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Color(0XFF721538)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GNav(
                  rippleColor: const Color.fromARGB(255, 230, 222, 212),
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: const Color(0xFFD4CBC0),
                  color: Colors.black,
                  tabs: const [
                    GButton(
                      icon: Icons.inventory_2_outlined,
                      text: 'Mis servicios',
                    ),
                    GButton(
                      icon: Icons.history,
                      text: 'Historial',
                    ),
                    GButton(
                      icon: Icons.account_circle_outlined,
                      text: 'Perfil',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                      GoRouter.of(context).refresh();
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
