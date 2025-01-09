import 'package:flutter/material.dart';
import 'package:help_desk/internal/request/domain/entities/service.dart';

class ServicesWidget extends StatelessWidget {
  final List<Service> services;

  const ServicesWidget({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Servicios',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            services.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    service.serviceNumber ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    service.registrationDate ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      service.status ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      service.assignedAgent ?? 'No asignado',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('No hay servicios asociados'),
                  ),
          ],
        ),
      ),
    );
  }
}