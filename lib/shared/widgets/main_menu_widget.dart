import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:help_desk/internal/users/profile/presentation/screens/profile_screen.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/delete_request_bloc/delete_request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_details_bloc/request_details_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/screens/history_screen.dart';
import 'package:help_desk/internal/users/request/presentation/screens/new_request_screen.dart';
import 'package:help_desk/internal/users/request/presentation/screens/request_screen.dart';

class MainMenuWidget extends StatefulWidget {
  const MainMenuWidget({super.key});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    RequestScreen(),
    HistoryScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RequestBloc, RequestState>(
          listener: (context, state) {
            if (state is PostingNewRequest) {
              showCupertinoDialog(
                context: context,
                builder: (context) => const CupertinoAlertDialog(
                  title: Text('Registrando la solicitud'),
                  content: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              );
            } 
            if (state is GettingRequests) {
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
            if (state is GetRequestSuccess) {
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
            }
            if (state is ErrorGettingRequests) {
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
        ),
        BlocListener<RequestDetailsBloc, RequestDetailsState>(
          listener: (context, state) {
            if (state is ErrorGettingRequestDetails) {
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Error'),
                  content: Center(
                    child: Text(state.message),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => GoRouter.of(context).pop(),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            }
          }
        ),
        BlocListener<DeleteRequestBloc, DeleteRequestState>(
          listener: (context, state) {
            if (state is DeletingRequest) {
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
              showCupertinoDialog(
                context: context,
                builder: (context) => const CupertinoAlertDialog(
                  title: Text('Cancelando la solicitud'),
                  content: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              );
            } 
            else if (state is DeleteRequestSuccess) {
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Solicitud cancelada'),
                  content: const Text('La solicitud ha sido cancelada'),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        context.read<RequestBloc>().add(GetRequests());
                        GoRouter.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            } 
            else if (state is ErrorDeletingRequest) {
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            }
          },
        )
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFA10046),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logos/sello_logo.png',
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width * 0.3,
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
                                  ? BlocBuilder<RequestBloc, RequestState>(
                                      builder: (context, state) {
                                        if (state is GettingRequests) {
                                          return const CupertinoActivityIndicator();
                                        } else if (state is GetRequestSuccess) {
                                          return _widgetOptions[_selectedIndex];
                                        } else if (state is ErrorGettingRequests) {
                                          return Center(
                                            child: IconButton(
                                              onPressed: () => context.read<RequestBloc>().add(GetRequests()),
                                              icon: const Icon(
                                                Icons.sync,
                                                size: 60,
                                              )
                                            ),
                                          );
                                        }
                                        return const RequestScreen();
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
            }),
          ),
        ),
        floatingActionButton: _selectedIndex == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: const Color(0XFF721530),
                    onPressed: () {
                      context.read<RequestBloc>().add(GetRequests());
                    },
                    child: const Icon(Icons.sync, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    backgroundColor: const Color(0XFF721530),
                    onPressed: () {
                      showModalBottomSheet<String>(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: true,
                        builder: (BuildContext modalContext) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          width: MediaQuery.of(context).size.width,
                          child: const NewRequestScreen(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
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
                  topRight: Radius.circular(25),
                ),
                color: Color(0XFF721538),
              ),
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
                  color: Colors.white,
                  tabs: const [
                    GButton(
                      icon: Icons.inventory_2_outlined,
                      text: 'Mis solicitudes',
                    ),
                    GButton(
                      icon: Icons.schedule_rounded,
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
