import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/login/presentation/blocs/login_bloc/login_bloc.dart';

class TechniciansLoginFormWidget extends StatefulWidget {
  const TechniciansLoginFormWidget({super.key});

  @override
  State<TechniciansLoginFormWidget> createState() => _TechniciansLoginWidgetState();
}

class _TechniciansLoginWidgetState extends State<TechniciansLoginFormWidget> {

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
            'INICIO DE SESIÓN PARA TÉCNICOS',
            style: TextStyle(
              color: const Color(0xFF2C2927),
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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