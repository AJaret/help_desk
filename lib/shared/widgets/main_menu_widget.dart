import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:help_desk/internal/users/announcements/presentation/screens/announcements_screen.dart';
import 'package:help_desk/internal/users/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/users/profile/presentation/screens/profile_screen.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/screens/history_screen.dart';
import 'package:help_desk/internal/users/request/presentation/screens/new_request_screen.dart';
import 'package:help_desk/internal/users/request/presentation/screens/request_screen.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

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
    AnnouncementsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFA10046),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
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
                              child: _widgetOptions.elementAt(_selectedIndex),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          )
        ),
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        backgroundColor: const Color(0XFF2C2927),
        onPressed: () {
          showModalBottomSheet<String>(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            builder: (BuildContext context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => CatalogBloc(getDependencyCatalogUseCase: AppDependencies.getDependency, getPhysicalLocationsCatalogUseCase: AppDependencies.getPhysicalLocations)),
                  BlocProvider(create: (context) => RequestBloc(AppDependencies.postRequestUseCase, AppDependencies.postNewRequest, AppDependencies.deleteRequestUsecase)),
                ],
                child: const NewRequestScreen(),
              )
            )
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ) : Container(),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Color(0XFF721538)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GNav(
                rippleColor: const Color.fromARGB(255, 230, 222, 212),
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: const Color(0xFFD4CBC0),
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon:  Icons.inventory_2_outlined,
                    text: 'Mis solicitudes',
                  ),
                  GButton(
                    icon: Icons.schedule_rounded,
                    text: 'Historial',
                  ),
                  GButton(
                    icon: Icons.newspaper,
                    text: 'Anuncios',
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
    );
  }
}