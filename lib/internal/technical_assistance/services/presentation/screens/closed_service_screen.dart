import 'dart:convert';
import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/presentation/blocs/service_requirements_bloc/service_requirements_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class ClosedServiceScreen extends StatefulWidget {
  final ClosedService closedServiceData;
  const ClosedServiceScreen({super.key, required this.closedServiceData});

  @override
  State<ClosedServiceScreen> createState() => _ClosedServiceScreenState();
}

class _ClosedServiceScreenState extends State<ClosedServiceScreen> {
  String? _pdfPath;
  bool _isPdfSaved = false;

  @override
  void initState() {
    super.initState();
    context.read<ServiceRequirementsBloc>().add(PostCloseService(widget.closedServiceData));
  }

  Future<void> _fetchAndSavePdf() async {
    final state = BlocProvider.of<ServiceRequirementsBloc>(context).state;

    if (state is CloseServiceSuccess && !_isPdfSaved) {
      print("📥 Recibido PDF en base64, iniciando guardado...");
      await _savePdfTemporarily(state.pdfBase64);
      setState(() {
        _isPdfSaved = true;
      });
    }
  }

  Future<void> _savePdfTemporarily(String pdfBase64) async {
    try {
      Uint8List bytes = base64Decode(pdfBase64);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/document.pdf';
      File tempFile = File(tempPath);
      
      await tempFile.writeAsBytes(bytes);

      if (await tempFile.exists()) {
        print("✅ PDF guardado en: $tempPath");
        setState(() {
          _pdfPath = tempPath;
        });
      } else {
        print("❌ Error: el archivo PDF no se creó correctamente.");
      }
    } catch (e) {
      print("🚨 Error al procesar el PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al procesar el PDF: $e")),
      );
    }
  }

  Future<void> _downloadPdf(BuildContext context) async {
    if (_pdfPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay archivo PDF disponible para descargar.")),
      );
      return;
    }

    try {
      Uint8List fileBytes = await File(_pdfPath!).readAsBytes();
      
      // 🔹 Usar `FileSaver` para guardar el archivo donde el usuario elija
      await FileSaver.instance.saveFile(
        name: "reporte_servicio",
        bytes: fileBytes,
        ext: "pdf",
        mimeType: MimeType.pdf,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ PDF guardado con éxito")),
      );
    } catch (e) {
      print("🚨 Error al guardar el PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar el PDF: $e")),
      );
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    if (_pdfPath == null || !(await File(_pdfPath!).exists())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se encontró el archivo PDF para compartir")),
      );
      return;
    }

    try {
      final box = context.findRenderObject() as RenderBox?;

      // Asegurar que la posición de origen sea válida en iPad
      final Rect sharePosition = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100); // Fallback en caso de error

      await Share.shareXFiles(
        [XFile(_pdfPath!)],
        text: "Compartiendo PDF",
        sharePositionOrigin: sharePosition,
      );
    } catch (e) {
      print("🚨 Error al compartir el PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al compartir el PDF: $e")),
      );
    }
  }

  Future<void> _sharePdfWhatsApp(BuildContext context) async {
    if (_pdfPath == null || !(await File(_pdfPath!).exists())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se encontró el archivo PDF para compartir")),
      );
      return;
    }

    try {
      final box = context.findRenderObject() as RenderBox?;
      String message = Uri.encodeComponent("Reporte y encuesta de servicio");
      String whatsappUrl = "https://wa.me/?text=$message";

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      }

      await Share.shareXFiles(
        [XFile(_pdfPath!)],
        text: "Reporte en PDF 📄",
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : const Rect.fromLTWH(0, 0, 100, 100),
      );
    } catch (e) {
      print("🚨 Error al compartir el PDF en WhatsApp: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al compartir en WhatsApp: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visor de PDF"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/mainTech');
          },
        ),
        actions: [
          if (Platform.isAndroid)
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _downloadPdf(context),
              tooltip: "Descargar PDF",
            ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _sharePdf(context),
              tooltip: "Compartir PDF",
            ),
          ),
          TextButton(
            onPressed: () => _sharePdfWhatsApp(context),
            child: const Text('WhatsApp', style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<ServiceRequirementsBloc, ServiceRequirementsState>(
          listener: (context, state) {
            if (state is CloseServiceSuccess) {
              _fetchAndSavePdf();
            }
            if (state is ErrorClosingService) {
              GoRouter.of(context).canPop() ? GoRouter.of(context).pop() : null;
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Error'),
                  content: Center(child: Text(state.message)),
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
          child: _pdfPath == null
              ? const Center(child: CircularProgressIndicator())
              : SfPdfViewer.file(File(_pdfPath!)),
        ),
      ),
    );
  }
}