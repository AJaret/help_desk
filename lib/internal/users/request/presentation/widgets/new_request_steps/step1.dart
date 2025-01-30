import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Step1 extends StatefulWidget {
  const Step1({super.key});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  
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
    return Column(
      children: [
        const Text('Estás creando una solicitud de servicio para la entidad:', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        const SizedBox(height: 20),
        Text(userDependency ?? 'No data', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        const SizedBox(height: 20),
        const Text('Nombre del titular:', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        const SizedBox(height: 20),
        Text(userDependencyDirector ?? 'No data', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      ],
    );
  }
}