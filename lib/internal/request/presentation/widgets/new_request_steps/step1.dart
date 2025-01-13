import 'package:flutter/material.dart';

Widget buildStep1() {
  return const Column(
    children: [
      Text('Estás creando una solicitud de servicio para la entidad:', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
      SizedBox(height: 20),
      Text('DIRECCIÓN DE NUEVAS TECNOLOGÍAS DE LA INFORMACIÓN Y COMUNICACIONES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      SizedBox(height: 20),
      Text('Nombre del titular:', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
      SizedBox(height: 20),
      Text('GUSTAVO ALFONSO GONZALEZ VELAZQUEZ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
    ],
  );
}