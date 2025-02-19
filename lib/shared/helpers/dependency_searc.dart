import 'package:flutter/material.dart';
import 'package:help_desk/internal/users/catalog/domain/entities/dependency.dart';

class CustomDropdown extends StatefulWidget {
  final List<Catalog> dependencyList;
  final Function(Catalog) onSelected;
  final String? selectedLabel;

  const CustomDropdown({super.key, required this.dependencyList, required this.onSelected, this.selectedLabel});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List<Catalog> filteredList = [];
  String? selectedLabel;

  @override
  void initState() {
    super.initState();
    filteredList = widget.dependencyList;
    selectedLabel = widget.selectedLabel;
  }

  String removeDiacritics(String input) {
    const withDiacritics = 'ÁÉÍÓÚáéíóúÜüÑñ';
    const withoutDiacritics = 'AEIOUaeiouUuNn';

    return input.split('').map((char) {
      final index = withDiacritics.indexOf(char);
      return index != -1 ? withoutDiacritics[index] : char;
    }).join();
  }

  void _showDropdownModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (context) {
        List<Catalog> localFilteredList = List.from(widget.dependencyList);
        TextEditingController searchController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Buscar entidad",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          final normalizedSearch = removeDiacritics(value).toLowerCase();

                          localFilteredList = widget.dependencyList.where((item) {
                            final normalizedLabel = removeDiacritics(item.label ?? '').toLowerCase();
                            return normalizedLabel.contains(normalizedSearch);
                          }).toList();
                        });
                      }
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: localFilteredList.length,
                        itemBuilder: (context, index) {
                          final item = localFilteredList[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  item.label ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedLabel = item.label;
                                  });
                                  widget.onSelected(item);
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider()
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDropdownModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedLabel ?? "Selecciona tu entidad",
                style: const TextStyle(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }
}
