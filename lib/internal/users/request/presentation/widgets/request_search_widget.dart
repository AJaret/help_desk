import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/users/request/domain/entities/request.dart';
import 'package:help_desk/internal/users/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/users/request/presentation/widgets/request_card_widget.dart';
import 'package:help_desk/shared/helpers/app_dependencies.dart';

class RequestSearchWidget extends StatefulWidget {
  final String requestType;
  const RequestSearchWidget({super.key, required this.requestType});

  @override
  State<RequestSearchWidget> createState() => _RequestSearchWidgetState();
}

class _RequestSearchWidgetState extends State<RequestSearchWidget> {
  List<Request> allRequests = [];
  List<Request> filteredRequests = [];
  String searchQuery = "";
  String? selectedStatus;
  bool sortByDateDesc = false;

  @override
  void initState() {
    super.initState();
  }

  void _filterRequests() {
    setState(() {
      filteredRequests = allRequests.where((request) {
        final queryLower = searchQuery.toLowerCase();
        final matchesSearch =
            request.requestId.toString().contains(queryLower) ||
                (request.dependency != null
                    ? request.dependency!.toLowerCase().contains(queryLower)
                    : false) ||
                (request.status != null
                    ? request.status!.toLowerCase().contains(queryLower)
                    : false);
        final matchesStatus =
            selectedStatus == null || request.status == selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();

      if (sortByDateDesc) {
        filteredRequests.sort((a, b) {
          DateTime dateA = DateTime.parse(a.registrationDate!);
          DateTime dateB = DateTime.parse(b.registrationDate!);
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
      filteredRequests = List.from(allRequests);
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
                items: const [
                  DropdownMenuItem(
                      value: 'Solicitud registrada', child: Text("Registrada")),
                  DropdownMenuItem(
                      value: 'Solicitud validada', child: Text("Validada")),
                  DropdownMenuItem(
                      value: 'Solicitud asignada', child: Text("Asignada")),
                  DropdownMenuItem(
                      value: 'Solicitud en proceso', child: Text("En proceso")),
                  DropdownMenuItem(
                      value: 'Solicitud terminada', child: Text("Terminada")),
                  DropdownMenuItem(
                      value: 'Solicitud finalizado', child: Text("Finalizado")),
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
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        if (state is RequestInitial) {
          context.read<RequestBloc>().add(GetRequests());
        } else if (state is GettingRequests) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetRequestSuccess) {
          if (allRequests.isEmpty) {
            allRequests = widget.requestType == 'Finished'
                ? state.requests
                    .where((request) =>
                        request.status == 'Solicitud finalizado' ||
                        request.status == 'Solicitud cancelada')
                    .toList()
                : state.requests
                    .where((request) =>
                        request.status != 'Solicitud finalizado' &&
                        request.status != 'Solicitud cancelada')
                    .toList();
            allRequests.sort((a, b) {
              DateTime dateA = DateTime.parse(a.registrationDate!);
              DateTime dateB = DateTime.parse(b.registrationDate!);
              return dateB.compareTo(dateA);
            });
            filteredRequests = List.from(allRequests);
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
                  child: filteredRequests.isNotEmpty
                      ? BlocProvider(
                          create: (context) => RequestBloc(AppDependencies.postRequestUseCase, AppDependencies.postNewRequest, AppDependencies.deleteRequestUsecase),
                          child: ListView.builder(
                            itemCount: filteredRequests.length,
                            itemBuilder: (context, index) {
                              return RequestCardWidget(
                                  request: filteredRequests[index]);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                          "No se encontraron solicitudes ${widget.requestType == 'Finished' ? 'Finalizadas' : 'pendientes'}",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ))),
            ],
          );
        } else if (state is ErrorGettingRequests) {
          return Center(
            child: IconButton(
                onPressed: () => context.read<RequestBloc>().add(GetRequests()),
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
