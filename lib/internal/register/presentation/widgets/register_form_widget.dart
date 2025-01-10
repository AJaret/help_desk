import 'package:diacritic/diacritic.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/register/presentation/blocs/user_register_bloc/user_register_bloc.dart';
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
  bool privacyPolicy = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  int? selectedValue;
  bool isFormValid = false;

  final TextEditingController textEditingController = TextEditingController();

  void _validateForm() {
    setState(() {
      isFormValid = employeeNumberController.text.isNotEmpty &&
          calendarFieldController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          selectedValue != null &&
          isEmailValid &&
          isPasswordValid &&
          privacyPolicy;
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
      SpecialCharacterValidationRule(),
      MinCharactersValidationRule(8),
    };

    setState(() {
      isPasswordValid = validationRules.every((rule) => rule.validate(password));
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

    return Column(
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
            const SizedBox(height: 20),
            BlocBuilder<CatalogBloc, CatalogState>(
              builder: (context, state) {
                if (state is CatalogInitial) {
                  context.read<CatalogBloc>().add(GetDependencies());
                } else if (state is GettingCatalog) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0XFF721538)),
                  );
                } else if (state is DependencyCatalogList) {
                  // Aquí devolvemos correctamente el DropdownButton2
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<int>(
                      isExpanded: true,
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Selecciona tu entidad',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      items: state.dependencyList.map((item) {
                        return DropdownMenuItem<int>(
                          value: item.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      }).toList(),
                      value: selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return state.dependencyList.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              item.label ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Buscar entidad',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (DropdownMenuItem<int> item, String searchValue) {
                          final matchingItem = state.dependencyList.firstWhere(
                            (dep) => dep.value == item.value,
                            orElse: () => Catalog(),
                          );
                          final normalizedLabel = removeDiacritics(matchingItem.label ?? '').toLowerCase();
                          final normalizedSearchValue = removeDiacritics(searchValue).toLowerCase();

                          return normalizedLabel.contains(normalizedSearchValue);
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: IconButton(
                      onPressed: () => context.read<CatalogBloc>().add(GetDependencies()),
                      icon: const Icon(Icons.refresh),
                    ),
                  );
                }

                return Container();
              },
            ),
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
                SpecialCharacterValidationRule(
                  customText: "Debe contener al menos un carácter especial.",
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
                              rule.validate(value) ? Icons.check_circle : Icons.cancel,
                              color: rule.validate(value) ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                rule.name,
                                style: TextStyle(
                                  color: rule.validate(value) ? Colors.green : Colors.red,
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
                                'https://gobiernodesolidaridad.gob.mx/avisosdeprivacidad'),
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
        BlocBuilder<UserRegisterBloc, UserRegisterState>(
          builder: (context, state) {
            if(state is UserRegisterInitial){
              return ElevatedButton(
                onPressed: isFormValid ? () {
                  UserRegister userData = UserRegister(
                    employeeNumber: employeeNumberController.value.text,
                    birthdate: calendarFieldController.value.text,
                    entityId: selectedValue,
                    email: emailController.value.text,
                    password: passwordController.value.text
                  );
                  context.read<UserRegisterBloc>().add(PostUserRegister(userData: userData));
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1A42),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
              );
            }else if(state is PostingUserRegister){
              return ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1A42),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                )
              );
            }else if(state is UserRegisterPosted){
              return ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.check),
                )
              );
            }else if(state is ErrorPostingUserRegister){
              return ElevatedButton(
                onPressed: isFormValid ? () {
                  print(employeeNumberController.value.text);
                  UserRegister userData = UserRegister(
                    employeeNumber: employeeNumberController.value.text,
                    birthdate: calendarFieldController.value.text,
                    entityId: selectedValue,
                    email: emailController.value.text,
                    password: passwordController.value.text
                  );
                  context.read<UserRegisterBloc>().add(PostUserRegister(userData: userData));
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1A42),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}