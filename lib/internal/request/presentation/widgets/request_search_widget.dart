import 'package:flutter/material.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/presentation/widgets/request_card_widget.dart';

class RequestSearchWidget extends StatefulWidget {
  final List<Request> requests;

  const RequestSearchWidget({super.key, required this.requests});

  @override
  State<RequestSearchWidget> createState() => _RequestSearchWidgetState();
}

class _RequestSearchWidgetState extends State<RequestSearchWidget> {
  List<Request> filteredRequests = [];
  String searchQuery = "";
  int? selectedStatus;
  bool sortByDateDesc = false;

  @override
  void initState() {
    super.initState();
    filteredRequests = widget.requests;
  }

  void _filterRequests() {
    setState(() {
      filteredRequests = widget.requests.where((request) {
        final queryLower = searchQuery.toLowerCase();
        final matchesSearch = request.folio.toString().contains(queryLower) ||
            request.name.toLowerCase().contains(queryLower) ||
            request.desc.toLowerCase().contains(queryLower);
        final matchesStatus = selectedStatus == null || request.status == selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();

      if (sortByDateDesc) {
        filteredRequests.sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
      }
    });
  }

  void _clearFilters() {
    setState(() {
      searchQuery = "";
      selectedStatus = null;
      sortByDateDesc = false;
      filteredRequests = widget.requests;
    });
  }

  DateTime _parseDate(String date) {
    final parts = date.split('-');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filtrar"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedStatus,
                isExpanded: true,
                hint: const Text("Selecciona un estatus"),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Registrada")),
                  DropdownMenuItem(value: 2, child: Text("Validada")),
                  DropdownMenuItem(value: 3, child: Text("Asignada")),
                  DropdownMenuItem(value: 4, child: Text("En proceso")),
                  DropdownMenuItem(value: 5, child: Text("Terminada")),
                  DropdownMenuItem(value: 6, child: Text("Finalizado")),
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
                  const Text("Ordenar por fecha"),
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
                        onPressed: _showFilterDialog,
                      ),
                      if (selectedStatus != null || searchQuery.isNotEmpty || sortByDateDesc)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearFilters,
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
          child: ListView.builder(
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) {
              return RequestCardWidget(request: filteredRequests[index]);
            },
          ),
        ),
      ],
    );
  }
}