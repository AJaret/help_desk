import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/technician_services_bloc/technician_services_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/widgets/technician_service_card.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class TechnicianServicesSearchWidget extends StatefulWidget {
  final String requestType;
  const TechnicianServicesSearchWidget({super.key, required this.requestType});

  @override
  State<TechnicianServicesSearchWidget> createState() => _TechnicianServicesWidgetState();
}

class _TechnicianServicesWidgetState extends State<TechnicianServicesSearchWidget> {
  List<TechnicianService> allServices = [];
  List<TechnicianService> filteredServices = [];
  String searchQuery = "";
  String? selectedStatus;
  bool sortByDateDesc = false;

  @override
  void initState() {
    super.initState();
  }

  void _filterRequests() {
    setState(() {
      filteredServices = allServices.where((request) {
        final queryLower = searchQuery.toLowerCase();
        final matchesSearch = request.requestFolio.toString().toLowerCase().contains(queryLower) || (request.dependency != null ? request.dependency!.toLowerCase().contains(queryLower) : false) || (request.status != null ? request.status!.toLowerCase().contains(queryLower) : false);
        final matchesStatus = selectedStatus == null || request.status == selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();

      if (sortByDateDesc) {
        filteredServices.sort((a, b) {
          DateTime dateA = DateTime.parse(a.date!);
          DateTime dateB = DateTime.parse(b.date!);
          return dateA.compareTo(dateB);
        });
      }
    });
  }

  void _clearFilters() {
    setState(() {
      searchQuery = "";
      selectedStatus = null;
      sortByDateDesc = false;
      filteredServices = List.from(allServices);
    });
  }

  void _showFilterDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filtrar"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                hint: const Text("Selecciona un estatus"),
                items: widget.requestType == 'Finished' ?
                const [
                  DropdownMenuItem(value: 'Servicio finalizado', child: Text("Servicio finalizado")),
                  DropdownMenuItem(value: 'Servicio cancelado', child: Text("Servicio cancelado")),
                  DropdownMenuItem(value: 'Servicio cerrado', child: Text("Servicio cerrado")),
                ]
                : const [
                  DropdownMenuItem(value: 'Servicio registrado', child: Text("Servicio registrado")),
                  DropdownMenuItem(value: 'Servicio validado', child: Text("Servicio validado")),
                  DropdownMenuItem(value: 'Servicio asignado', child: Text("Servicio asignado")),
                  DropdownMenuItem(value: 'Servicio en proceso', child: Text("Servicio en proceso"))
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                  _filterRequests();
                  Navigator.of(context).pop();
                },
              ),
              Row(
                children: [
                  const Text("Ordenar por fecha ascendente"),
                  Checkbox(
                    value: sortByDateDesc,
                    onChanged: (value) {
                      setState(() {
                        sortByDateDesc = value!;
                      });
                      _filterRequests();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _clearFilters();
                Navigator.of(context).pop();
              },
              child: const Text("Limpiar Filtros"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechnicianServicesBloc, TechnicianServicesState>(
      builder: (context, state) {
        if (state is TechnicianServicesInitial) {
          context.read<TechnicianServicesBloc>().add(GetTechnicianServices());
        } else if (state is GettingTechnicianServices) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TechnicianServicesSuccess) {
          if (allServices.isEmpty) {
            allServices = widget.requestType == 'Finished' ? state.services .where((request) => request.status == 'Servicio finalizado' || request.status == 'Servicio cerrado' || request.status == 'Servicio cancelado').toList()
                : state.services.where((request) => request.status != 'Servicio finalizado' && request.status != 'Servicio cancelado' && request.status != 'Servicio cerrado').toList();
            allServices.sort((a, b) {
              DateTime dateA = DateTime.parse(a.date!);
              DateTime dateB = DateTime.parse(b.date!);
              return dateB.compareTo(dateA);
            });
            filteredServices = List.from(allServices);
          }
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Buscar por folio, nombre o descripción",
                        border: const OutlineInputBorder(),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.filter_alt),
                              onPressed: () => _showFilterDialog(),
                            ),
                            if (selectedStatus != null ||
                                searchQuery.isNotEmpty ||
                                sortByDateDesc)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _clearFilters(),
                              ),
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                        _filterRequests();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: filteredServices.isNotEmpty
                      ? BlocProvider(
                          create: (context) => TechnicianServicesBloc(AppDependencies.getTechnicianServicesUsecase, AppDependencies.getTechnicianServiceDetailsUsecase, AppDependencies.getDocumentByIdUsecase),
                          child: ListView.builder(
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              return TechnicianServiceCardWidget(request: filteredServices[index]);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                          "No se encontraron servicios ${widget.requestType == 'Finished' ? 'Finalizados' : 'asignados'}",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ))),
            ],
          );
        } else if (state is ErrorGettingTechnicianServices) {
          return Center(
            child: IconButton(
                onPressed: () => context.read<TechnicianServicesBloc>().add(GetTechnicianServices()),
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 60,
                )),
          );
        }
        return Container();
      },
    );
  }
}
