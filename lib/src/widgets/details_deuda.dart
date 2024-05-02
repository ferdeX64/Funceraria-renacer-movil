import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funeraria14/src/bloc/signup_bloc.dart';
import 'package:funeraria14/src/models/deuda_model.dart';
import 'package:funeraria14/src/services/deuda_service.dart';

class DeudaDetails extends StatefulWidget {
  final Deuda model;
  const DeudaDetails({super.key, required this.model});

  @override
  State<DeudaDetails> createState() => _DeudaDetailsState();
}

class _DeudaDetailsState extends State<DeudaDetails> {
  final ScrollController controller = ScrollController();
  late final DeudaService _deudaService=DeudaService();
  late SignUpBloc bloc = SignUpBloc();

  TextEditingController _ingresoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Text(widget.model.detalleDeuda,
                    style: const TextStyle(color: Colors.black)),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 252, 250, 251)),
        body: Scrollbar(
          interactive: true,
          thickness: 10.0,
          controller: controller,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                  controller: controller,
                  physics: const ScrollPhysics(),
                  children: widget.model.transacciones.map((document) {
                    return Card(
                        child: ListTile(
                      onTap: () {},
                      leading: SizedBox.square(
                        dimension: 65,
                        child: Image.asset('assets/images/pago.png'),
                      ),
                      title: Text('Pague: ${document.anticipo.toString()}\$'),
                      subtitle: Text(document.fechaTransaccion),
                      trailing:
                          Text('Debo: ${document.deudaTotal.toString()} \$'),
                    ));
                  }).toList())),
        ),
        floatingActionButton: FloatingActionButton(
          
          backgroundColor: Colors.blueGrey.withOpacity(0.1),
          onPressed: () {
            _ingresoTextController = TextEditingController();
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      surfaceTintColor: Colors.white,
                      title: const Text('Agregar pago'),
                      content: StreamBuilder(
                          stream: bloc.videonameStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                                onChanged: bloc.changeVideoname,
                                controller: _ingresoTextController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  // for below version 2 use this
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+(\.\d{0,2})?$')),
// for version 2 and greater youcan also use this
                                ],
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onSaved: (value) {},
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelText: "Ingrese el pago \$:",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  errorStyle:
                                      const TextStyle(color: Colors.red),
                                  errorText: snapshot.error?.toString(),
                                ),
                                maxLength: 6,
                                maxLines: 1);
                          }),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                               
                            },
                            child: const Text('Cancelar')),
                        TextButton(
                            onPressed: () {
                              if (_ingresoTextController.text.isNotEmpty) {
                                _deudaService.pagoDeuda(widget.model,double.parse(_ingresoTextController.text));
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          surfaceTintColor: Colors.white,
                                          title: const Text('Exito'),
                                          content: const Text(
                                              'Pago registrado'),
                                          actions: <Widget>[
                                            // ignore: deprecated_member_use
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                   Navigator.pop(context);
                                                },
                                                child: const Text('Ok'))
                                          ],
                                        ));
                              }
                            },
                            child: const Text('Pagar'))
                      ],
                    ));
          },
          child: const Icon(
            Icons.paid,
            color: Colors.white,
          ),
        ));
  }
}
