import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/login/presentation/blocs/login_bloc/login_bloc.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    
    return Form(
      key: _formKey,
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
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
                  controller: _passwordController,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => GoRouter.of(context).push('/resetPassword'),
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
                const SizedBox(height: 5),
                const Divider(color: Colors.black38,),
                const SizedBox(height: 5),
                Column(
                  children: [
                    Text('¿Eres técnico? inicia sesión aquí', style: TextStyle(color: const Color(0XFF2C2927), fontSize: size.width * 0.04)),
                    TextButton(
                      onPressed: () => GoRouter.of(context).push('/techLogin'),
                      child: Text('Inicio de sesión', style: TextStyle(color: Colors.blue.shade800, fontSize: size.width * 0.04),),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isButtonEnabled ?
            () {
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(PostLogin(email: _emailController.text, password: _passwordController.text));
              }
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A42),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: context.read<LoginBloc>().state is PostingLogin ?
            const CircularProgressIndicator()
            : 
            Text(
              'Iniciar sesión',
              style: TextStyle(fontSize: size.width * 0.04),
            ),
          ),
        ],
      ),
    );
  }
}