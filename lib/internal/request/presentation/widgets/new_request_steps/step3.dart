import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/catalog/presentation/blocs/catalog_bloc/catalog_bloc.dart';

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
              onChanged: (value) => onLocationChange,
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
}
