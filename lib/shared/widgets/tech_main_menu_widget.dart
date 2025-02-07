import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_services_history_screen.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/screens/technician_services_screen.dart';
import 'package:help_desk/internal/users/profile/presentation/screens/profile_screen.dart';

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
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFA10046),
      body: SafeArea(
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
                    text: 'Mis servicios',
                  ),
                  GButton(
                    icon:  Icons.history,
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
    );
  }
}