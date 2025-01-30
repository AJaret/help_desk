import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/login/presentation/blocs/login_bloc/login_bloc.dart';

class ResetPasswordFormWidget extends StatefulWidget {
  const ResetPasswordFormWidget({super.key});

  @override
  State<ResetPasswordFormWidget> createState() =>
      _ResetPasswordFormWidgetState();
}

class _ResetPasswordFormWidgetState extends State<ResetPasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _employeeNumberController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _employeeNumberController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _employeeNumberController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _employeeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        print(state);
        if(state is ErrorPostingResetPassword){
          showCupertinoDialog(
            context: context, 
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Error'),
              content: Center(
                child: Text(state.message),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => GoRouter.of(context).pop(), 
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'RECUPERAR CONTRASEÑA',
              style: TextStyle(
                color: const Color(0xFF2C2927),
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
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
                  TextFormField(
                    controller: _employeeNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Número de empleado',
                      hintStyle: TextStyle(fontSize: size.width * 0.035),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (_isButtonEnabled && context.read<LoginBloc>().state is! PostingResetPassword) ? () {
                if (_formKey.currentState!.validate()) {
                  final email = _emailController.text.trim();
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(email)) {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text('Error'),
                          content: const Text('Ingrese un correo válido.'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('Aceptar'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    context.read<LoginBloc>().add(PostResetPassword(email: _emailController.text, employeeNumber: _employeeNumberController.text));
                  }
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1A42),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: context.read<LoginBloc>().state is PostingLogin ? const CircularProgressIndicator()
              : Text(
                  'Recuperar contraseña',
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
