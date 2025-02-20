import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/users/register/presentation/blocs/user_register_bloc/user_register_bloc.dart';
import 'package:help_desk/internal/users/register/presentation/widgets/register_form_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    context.read<CatalogBloc>().add(GetDependencies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFA10046),
        body: BlocProvider(
          create: (context) => UserRegisterBloc(postUserRegisterUseCase: AppDependencies.postUser),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
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
                            width: 110,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
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
                                child: const RegisterFormWidget()),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ));
  }
}
