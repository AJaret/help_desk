import 'package:flutter/material.dart';
import 'package:help_desk/internal/announcements/domain/entities/announcement.dart';
import 'package:help_desk/internal/announcements/presentation/widgets/anouncements_list_widget.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ANUNCIOS',
          style: TextStyle(
            color: const Color(0xFF2C2927),
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.62,
            child: AnnouncementsListWidget(announcements: announcements)
          ),
        ),
      ],
    );
  }
}