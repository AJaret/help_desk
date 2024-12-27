import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/internal/login/presentation/widgets/login_form_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(161, 0, 70, 1),
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
                  child: BlocProvider(
                    create: (context) => LoginBloc(AppDependencies.postLoginUseCase),
                    child: const LoginFormWidget(),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
