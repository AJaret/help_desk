import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ResetPasswordScreen> {
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFA10046),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(
                  width: size.width,
                  child: Stack(
                    children: [
                      GoRouter.of(context).canPop() ? Positioned(
                        left: 10,
                        top: size.height * 0.025,
                        child: IconButton(
                          onPressed: (){
                            GoRouter.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: size.height * 0.03,
                          )
                        ),
                      ) : Container(),
                      Center(
                        child: Image.asset(
                          'assets/images/logos/sello_logo.png',
                          fit: BoxFit.contain,
                          width: 100,
                        ),
                      ),
                    ]
                  ),
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
                          child: const Center(
                            child: Text('lol'),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ) 
    );
  }
}