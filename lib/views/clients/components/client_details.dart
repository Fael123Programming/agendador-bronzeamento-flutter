import 'package:flutter/material.dart';

class ClientDetails extends StatefulWidget {
  final Map<String, dynamic>? clientData;

  const ClientDetails({super.key, this.clientData});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clientData == null
            ? 'Adicionar cliente'
            : 'Detalhes de cliente'),
      ),
      body: const Center(
        child: Text(
          'Form',
        ),
      ),
    );
  }
}
