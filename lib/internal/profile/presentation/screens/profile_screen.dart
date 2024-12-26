import 'package:flutter/material.dart';
import 'package:help_desk/internal/announcements/domain/entities/announcement.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final List<Announcement> announcements = [
    Announcement(id: '1', title: 'Anuncio 1', description: 'Descripción del primer anuncio', imagePath: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
    Announcement(id: '2', title: 'Anuncio 2', description: 'Descripción del segundo anuncio', imagePath: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
    Announcement(id: '3', title: 'Anuncio 3', description: 'Descripción del tercer anuncio', imagePath: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
    Announcement(id: '4', title: 'Anuncio 4', description: 'Descripción del cuarto anuncio', imagePath: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
    Announcement(id: '5', title: 'Anuncio 5', description: 'Descripción del quinto anuncio', imagePath: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
  ];


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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text('Correo electrónico', style: titleStyle,),
                  const SizedBox(height: 10),
                  Text('correo@test.com', style: subTitleStyle,),
                  const SizedBox(height: 30),
                  Text('Numero de empleado', style: titleStyle,),
                  const SizedBox(height: 10),
                  Text('123124', style: subTitleStyle,),
                  const SizedBox(height: 30),
                  Text('Entidad', style: titleStyle,),
                  const SizedBox(height: 10),
                  Text('Dirección de nuevas tecnologías de la información', style: subTitleStyle,),
                ],
              ),
              Positioned(
                bottom: 10,
                child: ElevatedButton(
                  onPressed: () {
                    // GoRouter.of(context).go('/main');
                    print('lol');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1A42),
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
          )
        ),
      ],
    );
  }
}