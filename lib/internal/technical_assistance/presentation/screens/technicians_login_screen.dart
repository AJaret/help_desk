import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/internal/technical_assistance/presentation/widgets/technicians_login_form_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class TechniciansLoginScreen extends StatelessWidget {
  const TechniciansLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFA10046),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                width: size.width,
                child: Stack(children: [
                  GoRouter.of(context).canPop()
                      ? Positioned(
                          left: 10,
                          top: size.height * 0.025,
                          child: IconButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: size.height * 0.03,
                              )),
                        )
                      : Container(),
                  Center(
                    child: Image.asset(
                      'assets/images/logos/sello_logo.png',
                      fit: BoxFit.contain,
                      width: 100,
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 100,
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4CBC0),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        child: BlocProvider(
                          create: (context) => LoginBloc(AppDependencies.postLoginUseCase, AppDependencies.postResetPasswordUseCase),
                          child: const TechniciansLoginFormWidget(),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      )
    );
  }
}
