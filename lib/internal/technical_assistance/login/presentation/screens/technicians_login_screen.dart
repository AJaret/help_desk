import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/login/presentation/blocs/technical_assistance_login_bloc/technical_assistance_login_bloc.dart';
import 'package:help_desk/internal/technical_assistance/login/presentation/widgets/technicians_login_form_widget.dart';
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
                              create: (context) => TechnicalAssistanceLoginBloc(AppDependencies.postTechniciansLoginUseCase),
                              child: BlocListener<TechnicalAssistanceLoginBloc, TechnicalAssistanceLoginState>(
                                listener: (context, state) {
                                  if(state is PostingTechnicalAssistanceLogin){
                                    showCupertinoDialog(
                                      context: context, 
                                      builder: (context) =>  const CupertinoAlertDialog(
                                        title: Text('Iniciando sesión'),
                                        content: CupertinoActivityIndicator(),
                                      ),
                                    );
                                  }else if(state is ErrorPostingTechnicalAssistanceLogin){
                                    GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
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
                                  }else if(state is TechnicalAssistanceLoginSuccess){
                                    GoRouter.of(context).go('/mainTech');
                                  }
                                },
                                child: const TechniciansLoginFormWidget(),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
