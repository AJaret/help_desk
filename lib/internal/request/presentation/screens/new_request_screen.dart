import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/new_request.dart';
import 'package:help_desk/internal/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step1.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step2.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step3.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step4.dart';
import 'package:help_desk/internal/request/presentation/widgets/new_request_steps/step5.dart';
import 'package:help_desk/shared/helpers/form_helper.dart';
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
  String? folio; 
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

  Future<NewRequest> _submitForm() async {
    if (_validateCurrentStep()) {
      List<Document> documents = [];
      
      if (_files.isNotEmpty) {
        for (File file in _files) {
          final base64String = await encodeFileToBase64(file);
          final extensionFile = file.path.split('.').last.toLowerCase();
          documents.add(
            Document(
              file: base64String,
              fileExtension: extensionFile,
              type: extensionFile,
            ),
          );
        }
      }

      NewRequest requestData = NewRequest(
        documentNumber: '',
        serviceDescription: descriptionController.text,
        observations: aditionalDescriptionController.text,
        inventoryNumber: _inventoryNumbers,
        serviceLocation: selectedUbi.toString(),
        physicalServiceLocation: addressController.text,
        addressWith: _referredPersonController.text,
        phoneList: _phoneNumbers,
        extensions: _extensions,
        emails: _emails,
        documents: documents,
      );

      return requestData;
    }else{
      return NewRequest();
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
    return MultiBlocListener(
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
        BlocListener<RequestBloc, RequestState>(
          listener: (context, state) {
            if(state is PostingNewRequest){
              showCupertinoDialog(
                context: context, 
                builder: (context) => const CupertinoAlertDialog(
                title: Text('Registrando la solicitud'),
                  content: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              );
            }
            else if(state is PostRequestSuccess){
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
              currentStep = 5;
              folio = state.folio;
            }
            else if(state is ErrorPostingRequest){
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
                  EasyStep(
                    icon: Icon(Icons.check_circle),
                    title: 'Solicitud creada',
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
              currentStep < 5 ? Row(
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
                    onPressed: () async{
                      if(currentStep < 4){
                        _nextStep();
                      }else if(currentStep < 5){
                        NewRequest data = await _submitForm();
                        if(data.serviceDescription != null){
                          context.read<RequestBloc>().add(PostNewRequest(requestData: data));
                        }
                      }else{
                        GoRouter.of(context).pop();
                      }
                    },
                    child: Text(currentStep < 4 ? "Siguiente" : currentStep < 5 ? "Enviar" : "Aceptar"),
                  ),
                ],
              ) : Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1A42),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => GoRouter.of(context).pop(),
                  child: const Text("Aceptar"),
                ),
              ),
            ],
          ),
        ),
      ),
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
      case 5:
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, size: MediaQuery.of(context).size.width * 0.3, color: Colors.green,),
              const SizedBox(height: 20),
              Text('Solicitud creada correctamente', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05), textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              Text('Numero de folio:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.05), textAlign: TextAlign.center,),
              const SizedBox(height: 10),
              Text(folio ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.05), textAlign: TextAlign.center,),
            ],
          )
        );
      default:
        return const SizedBox.shrink();
    }
  }
}