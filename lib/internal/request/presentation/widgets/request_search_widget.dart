import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:help_desk/internal/request/presentation/widgets/request_card_widget.dart';

class RequestSearchWidget extends StatefulWidget {
  final String requestType;
  const RequestSearchWidget({super.key, required this.requestType});

  @override
  State<RequestSearchWidget> createState() => _RequestSearchWidgetState();
}

class _RequestSearchWidgetState extends State<RequestSearchWidget> {
  List<Request> filteredRequests = [];
  String searchQuery = "";
  String? selectedStatus;
  bool sortByDateDesc = false;

  void _filterRequests(List<Request> requests) {
    setState(() {
      filteredRequests = requests.where((request) {
        final queryLower = searchQuery.toLowerCase();
        final matchesSearch = request.folio.toString().contains(queryLower) ||
            (request.dependency != null
                ? request.dependency!.toLowerCase().contains(queryLower)
                : false) ||
            (request.status != null
                ? request.status!.toLowerCase().contains(queryLower)
                : false);
        final matchesStatus = selectedStatus == null || request.status == selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();

      if (sortByDateDesc) {
        filteredRequests
            .sort((a, b) => _parseDate(b.date!).compareTo(_parseDate(a.date!)));
      }
    });
  }

  void _clearFilters(List<Request> requests) {
    setState(() {
      searchQuery = "";
      selectedStatus = null;
      sortByDateDesc = false;
      filteredRequests = requests;
    });
  }

  DateTime _parseDate(String date) {
    final parts = date.split('-');
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  void _showFilterDialog(List<Request> requests) {
    showDialog(
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
                  DropdownMenuItem(value: 'Registrada', child: Text("Registrada")),
                  DropdownMenuItem(value: 'Validada', child: Text("Validada")),
                  DropdownMenuItem(value: 'Asignada', child: Text("Asignada")),
                  DropdownMenuItem(value: 'En proceso', child: Text("En proceso")),
                  DropdownMenuItem(value: 'Terminada', child: Text("Terminada")),
                  DropdownMenuItem(value: 'Finalizado', child: Text("Finalizado")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                  _filterRequests(requests);
                  Navigator.of(context).pop();
                },
              ),
              Row(
                children: [
                  const Text("Ordenar por fecha"),
                  Checkbox(
                    value: sortByDateDesc,
                    onChanged: (value) {
                      setState(() {
                        sortByDateDesc = value!;
                      });
                      _filterRequests(requests);
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
                _clearFilters(requests);
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
        if(state is RequestInitial){
          context.read<RequestBloc>().add(PostRequest());
        }
        else if(state is PostingRequest){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else if(state is RequestSuccess){
          widget.requestType == 'Finished' ? filteredRequests = state.requests.where((request) => request.status == 'Finalizada').toList() : filteredRequests = state.requests;
          return filteredRequests.isEmpty ? Center(
            child: Text("No se encontraron solicitudes ${widget.requestType == 'Finished' ? 'Finalizadas' : 'pendientes'}", style: const TextStyle(fontSize: 20,), textAlign: TextAlign.center,),
          ) :
          Column(
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
                              onPressed: () => _showFilterDialog(state.requests),
                            ),
                            if (selectedStatus != null || searchQuery.isNotEmpty || sortByDateDesc)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _clearFilters(state.requests),
                              ),
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                        _filterRequests(state.requests);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    return RequestCardWidget(request: filteredRequests[index]);
                  },
                ),
              ),
            ],
          );
        }else if(state is ErrorPostingRequest){
          return Center(
            child: IconButton(
              onPressed: () => context.read<RequestBloc>().add(PostRequest()),
              icon: const Icon(Icons.refresh_rounded, size: 60,)
            ),
          );
        }
        return Container();
      },
    );
  }
}
