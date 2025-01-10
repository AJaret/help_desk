import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';
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
  final List<String> _phoneNumbers = [];
  final TextEditingController _emailController = TextEditingController();
  final List<String> _emails = [];
  final TextEditingController _extensionController = TextEditingController();
  final List<String> _extensions = [];
  int characterCount = 0;
  final List<File> _files = [];
  final ImagePicker _imagePicker = ImagePicker();
  int? selectedUbi;
  
  Future<void> _selectFile() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Tomar una foto'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _imagePicker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _files.add(File(pickedFile.path));
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Seleccionar desde la galería'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _files.add(File(pickedFile.path));
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Añadir archivo'),
              onTap: () async {
                Navigator.of(context).pop();
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'zip', 'mp4'],
                );
                if (result != null) {
                  setState(() {
                    _files.add(File(result.files.single.path!));
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
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

  void _removeItem(int index, List<String> items) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        if (currentStep < 4) currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
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

  Widget _buildStepContent(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const Column(
          children: [
            Text('Estás creando una solicitud de servicio para la entidad:', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 20),
            Text('DIRECCIÓN DE NUEVAS TECNOLOGÍAS DE LA INFORMACIÓN Y COMUNICACIONES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            SizedBox(height: 20),
            Text('Nombre del titular:', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 20),
            Text('GUSTAVO ALFONSO GONZALEZ VELAZQUEZ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ],
        );
      case 1:
        return Column(
          children: [
            TextFormField(
              minLines: 5,
              maxLines: 10,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              maxLength: 4000,
              controller: descriptionController,
              onChanged: (value) {
                setState(() {
                  characterCount = value.length;
                });
              },
              decoration: InputDecoration(
                counterText: '$characterCount/4000 Máximo',
                labelText: "Describe la solicitud del servicio *",
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "El campo es requerido" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              minLines: 3,
              maxLines: 8,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              maxLength: 4000,
              controller: aditionalDescriptionController,
              decoration: const InputDecoration(
                labelText: "Observaciones adicionales",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    maxLength: 200,
                    controller: inventoryController,
                    decoration: const InputDecoration(
                      labelText: "Número de inventario",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: "Ingrese el número de inventario único para identificar el artículo.",
                  child: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: const Text("Información"),
                          content: const Text("Indica el número de inventario del equipo; laptop, computadora de escritorio, impresora. Ejemplo 12345678901"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cerrar"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            BlocBuilder<CatalogBloc, CatalogState>(
              builder: (context, state) {
                if(state is CatalogInitial){
                  context.read<CatalogBloc>().add(GetPhysicalLocations());
                }else if(state is GettingCatalog){
                  return const Center(child: CircularProgressIndicator());
                }else if(state is PhysicalLocationsCatalogList){
                  return DropdownButtonFormField<int>(
                    value: selectedUbi,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Color(0xFF8B1A42),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    hint: const Text(
                      "Selecciona una opción",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    items: state.locationsList.isNotEmpty ? 
                    state.locationsList.map((location) {
                      return DropdownMenuItem(
                        value: location.value,
                        child: Text(location.label ?? ''),
                      );
                    }).toList() :
                    const [],
                    onChanged: (value) {
                      setState(() {
                        selectedUbi = value;
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    dropdownColor: Colors.white,
                  );
                }else if(state is ErrorGettingPhysicalLocationsCatalog){
                  return Center(
                    child: IconButton(
                      onPressed: () => context.read<CatalogBloc>().add(GetPhysicalLocations()),
                      icon: const Icon(Icons.refresh)
                    )
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Ubicación física del servicio",
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "La dirección es requerida" : null,
            ),
          ],
        );
      case 3:
        return SingleChildScrollView(
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      
                    )
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F3FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone_android, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Registra un teléfono de contacto',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'x${_phoneNumbers.length}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Teléfono',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _addItem(_phoneNumbers, _phoneController),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Agregar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _phoneNumbers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(
                                      _phoneNumbers[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () => _removeItem(index, _phoneNumbers),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      
                    )
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F3FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.mail, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Anexa correos adicionales',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'x${_emails.length}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Teléfono',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _addItem(_emails, _emailController),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Agregar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _emails.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(
                                      _emails[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () => _removeItem(index, _emails),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      
                    )
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F3FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'Extensión(es) de contacto',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Opcional x${_extensions.length}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _extensionController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Extensión',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _addItem(_extensions, _extensionController),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Agregar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _extensions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.circle, size: 8, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Text(
                                      _extensions[index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () => _removeItem(index, _extensions),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _selectFile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Añadir archivo o tomar foto',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            if (_files.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _files.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      _files[index].path.endsWith('.pdf')
                          ? Icons.picture_as_pdf
                          : _files[index].path.endsWith('.zip')
                              ? Icons.archive
                              : Icons.image,
                      color: Colors.blue,
                    ),
                    title: Text(_files[index].path.split('/').last),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFile(index),
                    ),
                  );
                },
              ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}