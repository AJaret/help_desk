import 'package:flutter/material.dart';

class SurveyWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSurveyCompleted;
  final GlobalKey<SurveyWidgetState> key;

  const SurveyWidget({required this.onSurveyCompleted, required this.key}) : super(key: key);

  @override
  State<SurveyWidget> createState() => SurveyWidgetState();
}

class SurveyWidgetState extends State<SurveyWidget> {
  int _selectedStars = 0;
  final TextEditingController _observationsController = TextEditingController();

  void submitSurvey() {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecciona una calificación.")),
      );
      return;
    }

    final feedbackData = {
      "rating": _selectedStars,
      "observations": _observationsController.text,
    };

    widget.onSurveyCompleted(feedbackData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("¡Gracias por tu feedback!")),
    );

    setState(() {
      _selectedStars = 0;
      _observationsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "En lo General, ¿Cómo te pareció el servicio brindado?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _selectedStars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _selectedStars = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text(
            "Observaciones y/o sugerencias",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _observationsController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Escribe tus comentarios aquí...",
            ),
          ),
        ],
      ),
    );
  }
}
