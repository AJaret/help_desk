import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/users/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';

Widget buildStep3({
  required int? selectedUbi,
  required TextEditingController addressController,
  required int characterCount,
  required Function(int?) onLocationChange,
  required BuildContext context
}) {
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
                "Selecciona una ubicación para el servicio *",
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
              onChanged: (value) => onLocationChange(value),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              dropdownColor: Colors.white,
              validator: (value) => value == null ? "La ubicación es requerida" : null,
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
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Ubicación física del servicio *",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? "La dirección es requerida" : null,
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: "Especifica el lugar en el que se llevará acabo el servicio",
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text("Información"),
                    content: const Text("Especifica el lugar en el que se llevará acabo el servicio, por ejemplo: oficina del jefe de departamento de sistemas en planta alta"),
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
}
