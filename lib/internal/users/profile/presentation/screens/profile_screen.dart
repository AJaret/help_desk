import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userDependency;
  String? userDependencyDirector;

  @override
  void initState() {
    getDependencyData();
    super.initState();
  }

  Future<void> getDependencyData() async{
    const storage = FlutterSecureStorage();
    userDependency = await storage.read(key: 'userDependency');
    userDependencyDirector = await storage.read(key: 'userDependencyDirector');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.045);
    TextStyle subTitleStyle = TextStyle(fontSize: size.width * 0.035);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PERFIL',
          style: TextStyle(
            color: const Color(0xFF2C2927),
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.62,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Entidad', style: titleStyle,),
                  const SizedBox(height: 10),
                  Text(userDependency ?? 'No data', style: subTitleStyle,),
                  const SizedBox(height: 30),
                  Text('Director de la entidad', style: titleStyle,),
                  const SizedBox(height: 10),
                  Text(userDependencyDirector ?? 'No data', style: subTitleStyle,),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        launchUrl(Uri.parse('https://helpdesk.gobiernodesolidaridad.gob.mx/helpdesk/assets/manual_usuario.pdf'));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: const Color(0xFF8B1A42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.description, color: Colors.white, size: 40),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ver",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                "Manual del usuario",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text('Confirmar cierre de sesión'),
                                content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async{
                                      context.read<LoginBloc>().add(Logout());
                                      await Future.delayed(const Duration(milliseconds: 500), ()=>());
                                      GoRouter.of(context).refresh();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cerrar sesión'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF721538),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}