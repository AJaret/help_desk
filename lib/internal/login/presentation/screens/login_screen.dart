import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFA10046),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/logos/login_logo.png',
                  height: 250,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFD4CBC0),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                height: size.height * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'INICIO DE SESIÓN',
                      style: TextStyle(
                        color: const Color(0xFF2C2927),
                        fontSize: size.width * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Correo electrónico',
                              hintStyle: TextStyle(fontSize: size.width * 0.035),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          FancyPasswordField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Contraseña',
                            ),
                            hasStrengthIndicator: false,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: null,
                            child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.blue.shade800, fontSize: size.width * 0.04),),
                          ),
                          const SizedBox(height: 5),
                          const Divider(color: Colors.black38,),
                          const SizedBox(height: 5),
                          Column(
                            children: [
                              Text('¿Aún no estas registrado?', style: TextStyle(color: const Color(0XFF2C2927), fontSize: size.width * 0.04)),
                              TextButton(
                                onPressed: () => GoRouter.of(context).push('/register'),
                                child: Text('Crea una cuenta', style: TextStyle(color: Colors.blue.shade800, fontSize: size.width * 0.04),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/main');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1A42), // Dark red button color
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: size.width * 0.04),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}