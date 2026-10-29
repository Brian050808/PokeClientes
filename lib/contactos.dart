
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactos extends StatefulWidget {
  const Contactos({super.key});

  @override
  State<Contactos> createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
  List<Contact> contactos = [];
  Contact? seleccionado;
  bool cargando = true;
  String? error;

  final String mensaje =
      'Bienvenido a la UTTEC, en los próximos días recibirás más información acerca de la carrera.';

  @override
  void initState() {
    super.initState();
    cargarContactos();
  }

  Future<void> cargarContactos() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final permiso = await FlutterContacts.permissions.request(PermissionType.read);

      if (permiso != PermissionStatus.granted && permiso != PermissionStatus.limited) {
        if (!mounted) return;
        setState(() {
          error = 'Debes conceder permiso para acceder a tus contactos.';
          cargando = false;
        });
        return;
      }

      final resultado = await FlutterContacts.getAll(
        properties:{
          ContactProperty.phone,
        },
      );

      if (!mounted) return;

      resultado.sort(
            (a, b) => (a.displayName ?? '').toLowerCase().compareTo(
          (b.displayName ?? '').toLowerCase(),
        ),
      );

      setState(() {
        contactos = resultado
            .where(
              (c) => c.phones.any(
                (p) => p.number.trim().isNotEmpty,
          ),
        )
            .toList();
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Error al cargar los contactos: $e';
        cargando = false;
      });
    }
  }

  Future<void> abrirWhatsApp() async {
    final contacto = seleccionado;
    if (contacto == null || contacto.phones.isEmpty) return;

    final numero = contacto.phones.first.number.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (numero.isEmpty) return;

    final url = Uri.https(
      'wa.me',
      '/$numero',
      {'text': mensaje},
    );

    try {
      final abierto = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp.'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al abrir WhatsApp.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
        actions: [
          IconButton(
            onPressed: cargarContactos,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: cargarContactos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: contactos.isEmpty
                ? const Center(
              child: Text(
                'No se encontraron contactos con teléfono.',
              ),
            )
                : ListView.builder(
              itemCount: contactos.length,
              itemBuilder: (context, index) {
                final contacto = contactos[index];
                final telefono =
                    contacto.phones.first.number;

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (contacto.displayName ?? '').isNotEmpty
                          ? (contacto.displayName ?? '')[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(contacto.displayName ?? 'Sin nombre'),
                  subtitle: Text(telefono),
                  selected:
                  seleccionado?.id == contacto.id,
                  trailing: seleccionado?.id ==
                      contacto.id
                      ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                      : null,
                  onTap: () {
                    setState(() {
                      seleccionado = contacto;
                    });
                  },
                );
              },
            ),
          ),
          if (seleccionado != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: abrirWhatsApp,
                    icon: const Icon(Icons.chat),
                    label: const Text(
                      'Enviar mensaje por WhatsApp',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
