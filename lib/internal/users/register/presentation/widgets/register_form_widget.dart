import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/users/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/users/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/users/register/presentation/blocs/user_register_bloc/user_register_bloc.dart';
import 'package:help_desk/shared/helpers/dependency_searc.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  DateTime? selectedDate;
  TextEditingController calendarFieldController = TextEditingController();
  TextEditingController employeeNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstLastNameController = TextEditingController();
  TextEditingController secondLastNameController = TextEditingController();
  bool privacyPolicy = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isDecentralized = false;
  int? selectedValue;
  bool isFormValid = false;

  final TextEditingController textEditingController = TextEditingController();

  void _validateForm() {
    setState(() {
      if (isDecentralized) {
        isFormValid = employeeNumberController.text.isNotEmpty &&
            calendarFieldController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            firstLastNameController.text.isNotEmpty &&
            selectedValue != null &&
            isEmailValid &&
            isPasswordValid &&
            privacyPolicy;
      } else {
        isFormValid = employeeNumberController.text.isNotEmpty &&
            calendarFieldController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            selectedValue != null &&
            isEmailValid &&
            isPasswordValid &&
            privacyPolicy;
      }
    });
  }

  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    setState(() {
      isEmailValid = emailRegex.hasMatch(email);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        calendarFieldController.text =
            "${picked.year}-${picked.month}-${picked.day}";
        _validateForm();
      });
    }
  }

  void _validatePassword(String password) {
    final validationRules = {
      DigitValidationRule(),
      UppercaseValidationRule(),
      LowercaseValidationRule(),
      MinCharactersValidationRule(8),
    };

    setState(() {
      isPasswordValid =
          validationRules.every((rule) => rule.validate(password));
    });
  }

  Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<UserRegisterBloc, UserRegisterState>(
      listener: (context, state) {
        if(state is PostingUserRegister){
          showCupertinoDialog(
            context: context,
            builder: (context) => const CupertinoAlertDialog(
              title: Text('Registrando datos'),
              content: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }
        if(state is UserRegisterPosted){
          GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
          String userEmail = emailController.text;
          calendarFieldController.text = '';
          employeeNumberController.text = '';
          emailController.text = '';
          passwordController.text = '';
          nameController.text = '';
          firstLastNameController.text = '';
          secondLastNameController.text = '';
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "HelpDesk",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF721538),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: Colors.green,
                      size: 50,
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "Gracias por registrarte, hemos enviado un mensaje a ",
                          ),
                          TextSpan(
                            text: userEmail,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: " en el que encontrarás un enlace para verificar tu correo electrónico. Una vez hayas verificado tu correo, podrás iniciar sesión",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Aceptar"),
                  ),
                ],
              );
            },
          );
        }
        if(state is ErrorPostingUserRegister){
          GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title:
                    const Text('Help desk'),
                content: Text(state.message),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'REGISTRO',
            style: TextStyle(
              color: const Color(0xFF2C2927),
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, state) {
                  if (state is CatalogInitial) {
                    context.read<CatalogBloc>().add(GetDependencies());
                  } else if (state is GettingCatalog) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0XFF721538)),
                    );
                  } else if (state is DependencyCatalogList) {
                    return CustomDropdown(
                      dependencyList: state.dependencyList,
                      onSelected: (selectedEntity) {
                        setState(() {
                          selectedValue = selectedEntity.value;
                          isDecentralized =
                              selectedEntity.decentralized ?? false;
                          _validateForm();
                        });
                      },
                    );
                  } else {
                    return Center(
                      child: IconButton(
                        onPressed: () =>
                            context.read<CatalogBloc>().add(GetDependencies()),
                        icon: const Icon(Icons.refresh),
                      ),
                    );
                  }

                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: employeeNumberController,
                onChanged: (value) => _validateForm(),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: calendarFieldController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Fecha de nacimiento',
                        hintStyle: TextStyle(fontSize: size.width * 0.035),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
              isDecentralized ? const SizedBox(height: 20) : Container(),
              isDecentralized
                  ? TextField(
                      controller: nameController,
                      onChanged: (value) => _validateForm(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Nombre(s) *',
                        hintStyle: TextStyle(fontSize: size.width * 0.035),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : Container(),
              isDecentralized ? const SizedBox(height: 20) : Container(),
              isDecentralized
                  ? TextField(
                      controller: firstLastNameController,
                      onChanged: (value) => _validateForm(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Primer apellido *',
                        hintStyle: TextStyle(fontSize: size.width * 0.035),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : Container(),
              isDecentralized ? const SizedBox(height: 20) : Container(),
              isDecentralized
                  ? TextField(
                      controller: secondLastNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Segundo apellido',
                        hintStyle: TextStyle(fontSize: size.width * 0.035),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                onChanged: (value) {
                  _validateEmail(value);
                  _validateForm();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Correo electrónico',
                  hintStyle: TextStyle(fontSize: size.width * 0.035),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorText: !isEmailValid && emailController.text.isNotEmpty
                      ? 'Por favor, ingresa un correo válido'
                      : null,
                ),
              ),
              const SizedBox(height: 25),
              FancyPasswordField(
                controller: passwordController,
                onChanged: (value) {
                  _validatePassword(value);
                  _validateForm();
                },
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  hintStyle: const TextStyle(fontSize: 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                hasStrengthIndicator: false,
                validationRules: {
                  DigitValidationRule(
                    customText: "Debe contener al menos un número.",
                  ),
                  UppercaseValidationRule(
                    customText: "Debe contener al menos una letra mayúscula.",
                  ),
                  LowercaseValidationRule(
                    customText: "Debe contener al menos una letra minúscula.",
                  ),
                  MinCharactersValidationRule(
                    8,
                    customText: "Debe tener al menos 8 caracteres.",
                  ),
                },
                validationRuleBuilder: (rules, value) {
                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rules.map((rule) {
                          return Row(
                            children: [
                              Icon(
                                rule.validate(value)
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: rule.validate(value)
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  rule.name,
                                  style: TextStyle(
                                    color: rule.validate(value)
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    value: privacyPolicy,
                    onChanged: (x) {
                      setState(() {
                        privacyPolicy = x ?? false;
                        _validateForm();
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Autorizo el uso de mis datos de acuerdo a las ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Políticas de privacidad',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchURL(
                                  'https://helpdesk.playadelcarmen.gob.mx/politicas/aviso_privacidad.html'),
                          ),
                          const TextSpan(
                            text: '.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isFormValid
                ? () {
                    UserRegister userData = UserRegister(
                        employeeNumber:
                            employeeNumberController.value.text,
                        birthdate: calendarFieldController.value.text,
                        entityId: selectedValue,
                        email: emailController.value.text,
                        password: passwordController.value.text);
                    context
                        .read<UserRegisterBloc>()
                        .add(PostUserRegister(userData: userData));
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B1A42),
              padding: const EdgeInsets.symmetric(
                  horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Registrarse',
              style: TextStyle(fontSize: size.width * 0.04),
            ),
          )
        ],
      ),
    );
  }
}
