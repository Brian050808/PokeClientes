import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:url_launcher/url_launcher.dart';

/// Escáner de códigos QR (ZXing, software libre).
class CamaraPage extends StatefulWidget {
  const CamaraPage({super.key});

  @override
  State<CamaraPage> createState() => _CamaraPageState();
}

class _CamaraPageState extends State<CamaraPage> {
  String? _contenido;
  bool _procesando = false;

  Future<void> _alEscanear(Code codigo) async {
    if (_procesando) return;

    final contenido = codigo.text;
    if (!codigo.isValid || contenido == null || contenido.isEmpty) return;
    if (!mounted) return;

    setState(() => _contenido = contenido);

    final uri = Uri.tryParse(contenido);

    // Solo abre enlaces HTTP o HTTPS.
    if (uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty) {
      _procesando = true;
      try {
        final abierto =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!abierto && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir el enlace')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al abrir el enlace: $e')),
          );
        }
      } finally {
        _procesando = false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código no contiene un enlace web válido'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escáner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ReaderWidget(
            onScan: _alEscanear,
            codeFormat: Format.qrCode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Text(
                _contenido ?? 'Escanea un código QR',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
