import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step1.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step2.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step3.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step4.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step5.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
import 'package:help_desk/shared/helpers/new_request_form_helper.dart';
import 'package:image_picker/image_picker.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});

  @override
  State<NewRequestScreen> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<NewRequestScreen> {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  final _formKeyStep4 = GlobalKey<FormState>();
  final _formKeyStep5 = GlobalKey<FormState>();

  int currentStep = 0;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController aditionalDescriptionController = TextEditingController();
  final TextEditingController inventoryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _extensionController = TextEditingController();
  final TextEditingController _referredPersonController = TextEditingController();
  final List<String> _inventoryNumbers = [];
  final List<String> _phoneNumbers = [];
  final List<String> _emails = [];
  final List<String> _extensions = [];
  final List<File> _files = [];
  final ImagePicker _imagePicker = ImagePicker();
  int characterCount = 0;
  int? selectedUbi;
  
  Future<void> _handleFileSelection() async {
    File? file = await selectFile(context, _imagePicker);
    if (file != null) {
      setState(() {
        _files.add(file);
      });
    }
  }

  void _addItem(List<String> items, TextEditingController controller) {
    final item = controller.text.trim();
    if (item.isNotEmpty) {
      setState(() {
        items.add(item);
      });
      controller.clear();
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        if (currentStep < 4) currentStep++;
      });
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return _formKeyStep1.currentState!.validate();
      case 1:
        return _formKeyStep2.currentState!.validate();
      case 2:
        return _formKeyStep3.currentState!.validate();
      case 3:
        return _formKeyStep4.currentState!.validate();
      case 4:
        return _formKeyStep5.currentState!.validate();
      default:
        return false;
    }
  }

  void _submitForm() {
    if (_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formulario enviado exitosamente")),
      );
    }
  }

  GlobalKey<FormState> _getCurrentFormKey() {
    switch (currentStep) {
      case 0:
        return _formKeyStep1;
      case 1:
        return _formKeyStep2;
      case 2:
        return _formKeyStep3;
      case 3:
        return _formKeyStep4;
      case 4:
        return _formKeyStep5;
      default:
        return _formKeyStep1;
    }
  }

  void _removeFile(int index) {setState(() {_files.removeAt(index);});}
  void _removeItem(int index, List<String> items) {setState(() {items.removeAt(index);});}
  void _previousStep() {setState(() {if (currentStep > 0) currentStep--;});}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CatalogBloc(getDependencyCatalogUseCase: AppDependencies.getDependency, getPhysicalLocationsCatalogUseCase: AppDependencies.getPhysicalLocations)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CatalogBloc, CatalogState>(
            listener: (context, state) {
              if(state is ErrorGettingPhysicalLocationsCatalog){
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
          ),
        ],
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0, bottom: 28.0, left: 15, right: 15),
            child: Column(
              children: [
                currentStep == 0 ? Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.blue[200]
                  ),
                  width: double.infinity,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 300,
                        child: Text('Entre mejor se encuentre descrita tu solicitud de ayuda, más rápida y eficiente será atendida. ¡Gracias!')
                      )
                    ],
                  ),
                ) : Container(),
                const SizedBox(height: 10),
                EasyStepper(
                  activeStep: currentStep,
                  steps: const [
                    EasyStep(
                      icon: Icon(Icons.account_balance_outlined),
                      title: 'Entidad',
                    ),
                    EasyStep(
                      icon: Icon(Icons.email),
                      title: 'Descripción',
                    ),
                    EasyStep(
                      icon: Icon(Icons.location_on),
                      title: 'Ubicación',
                    ),
                    EasyStep(
                      icon: Icon(Icons.assignment_ind_sharp),
                      title: 'Contactos',
                    ),
                    EasyStep(
                      icon: Icon(Icons.file_present_sharp),
                      title: 'Archivos',
                    ),
                  ],
                  onStepReached: (index) {
                    if (index <= currentStep) {
                      setState(() {
                        currentStep = index;
                      });
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _getCurrentFormKey(),
                      child: _buildStepContent(context),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1A42),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: currentStep > 0 ? _previousStep : null,
                      child: const Text("Anterior"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1A42),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: currentStep < 4 ? _nextStep : _submitForm,
                      child: Text(currentStep < 4 ? "Siguiente" : "Enviar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const Step1();
      case 1:
        return buildStep2(
          descriptionController: descriptionController,
          aditionalDescriptionController: aditionalDescriptionController,
          inventoryNumbers: _inventoryNumbers,
          addItem: _addItem,
          removeItem: _removeItem,
          inventoryController: inventoryController,
          characterCount: characterCount,
          onDescriptionChanged: (value) {
            setState(() {
              characterCount = value.length;
            });
          },
          context: context
        );
      case 2:
        return buildStep3(
          selectedUbi: selectedUbi,
          addressController: addressController,
          characterCount: characterCount,
          onLocationChange: (value) {
            setState(() {
              selectedUbi = value;
            });
          },
          context: context
        );
      case 3:
        return buildStep4(
          phoneController: _phoneController,
          emailController: _emailController,
          extensionController: _extensionController,
          referredPersonController: _referredPersonController,
          phoneNumbers: _phoneNumbers,
          emails: _emails,
          extensions: _extensions,
          addItem: _addItem,
          removeItem: _removeItem,
          context: context
        );
      case 4:
        return buildStep5(
          files: _files,
          handleFileSelectionModal: _handleFileSelection,
          removeFile: _removeFile,
          context: context
        );
      default:
        return const SizedBox.shrink();
    }
  }
}