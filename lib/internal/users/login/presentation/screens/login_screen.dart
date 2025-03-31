import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:help_desk/internal/users/login/presentation/widgets/login_form_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showText = false;
  bool _showTextPrivacy = false;

  void _toggleText() {
    setState(() {
      _showText = !_showText;
    });
  }

  void _toggleTextPrivacy() {
    setState(() {
      _showTextPrivacy = !_showTextPrivacy;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(161, 0, 70, 1),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _showText = false;
            _showTextPrivacy = false;
          });
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/logos/login_logo.png',
                    width: size.width * 0.8,
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
                  height: size.height * 0.70,
                  child: BlocProvider(
                    create: (context) => LoginBloc(AppDependencies.postLoginUseCase, AppDependencies.postResetPasswordUseCase),
                    child: BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if(state is PostingLogin){
                          showCupertinoDialog(
                            context: context, 
                            builder: (context) =>  const CupertinoAlertDialog(
                              title: Text('Iniciando sesión'),
                              content: CupertinoActivityIndicator(),
                            ),
                          );
                        }else if(state is ErrorPostingLogin){
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
                        }else if(state is LoginSuccess){
                          GoRouter.of(context).go('/main');
                        }
                      },
                      child: const LoginFormWidget(),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _showTextPrivacy ? const Color.fromRGBO(161, 0, 70, 1) : Colors.transparent
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
                    launchUrl(Uri.parse('https://gobiernodesolidaridad.gob.mx/avisos-de-privacidad-de-la-oficialia-mayor'));
                    setState(() {
                      _showTextPrivacy = false;
                    });
                  },
                  child: !_showTextPrivacy ? Container() : AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _showTextPrivacy ? 240 : 165,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      "Ver políticas de privacidad",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: _toggleTextPrivacy,
                  backgroundColor: const Color(0XFF721538),
                  child: const Icon(Icons.lock, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _showText ? const Color.fromRGBO(161, 0, 70, 1) : Colors.transparent
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
                    launchUrl(Uri.parse('https://helpdesk.gobiernodesolidaridad.gob.mx/helpdesk/assets/manual_usuario.pdf'));
                    setState(() {
                      _showText = false;
                    });
                  },
                  child: !_showText ? Container() : AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _showText ? 240 : 165,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      "Ver manual del usuario",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: _toggleText,
                  backgroundColor: const Color(0XFF721538),
                  child: const Icon(Icons.description, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
