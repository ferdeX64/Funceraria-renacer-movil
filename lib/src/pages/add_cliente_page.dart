import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funeraria14/src/bloc/signup_bloc.dart';
import 'package:funeraria14/src/models/cliente_model.dart';
import 'package:funeraria14/src/services/cliente_service.dart';


class AddClientePage extends StatefulWidget {
  const AddClientePage({super.key});

  @override
  State<AddClientePage> createState() => _AddClientePageState();
}

class _AddClientePageState extends State<AddClientePage> {
  final _formKey = GlobalKey<FormState>();
  late SignUpBloc bloc;
  
  late final AddCliente _cliente=AddCliente();
  final TextEditingController _actividadDescriptionTextController =
      TextEditingController();
  final TextEditingController _ingresoTextController = TextEditingController();

  final ClienteService _clienteService =ClienteService();
  var _onSaving = false;
  @override
  void initState() {
    bloc = SignUpBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final bordersvertical = MediaQuery.of(context).size.height * 4 / 100;
    final bordershorizontal = MediaQuery.of(context).size.width * 6 / 100;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 2,
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, colors: [
            Color.fromARGB(255, 164, 201, 247),
            Color.fromARGB(255, 2, 56, 144),
            Color.fromARGB(255, 124, 140, 239),
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 65, bottom: 20),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/cruz.png',
                        height: 70,
                        width: 70,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Agregar Cliente",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Ingresa los datos del Cliente",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: bordersvertical),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: bordershorizontal,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder(
                                      stream:
                                          bloc.actividadDescriptionStream,
                                      builder: (context, snapshot) {
                                        return TextFormField(
                                            onChanged: bloc
                                                .changeActividadDescription,
                                            controller:
                                                _actividadDescriptionTextController,
                                            keyboardType:
                                                TextInputType.text,
                                            textCapitalization:
                                                TextCapitalization
                                                    .sentences,
                                            onSaved: (value) {
                                              //Este evento se ejecuta cuando se cumple la validación y cambia el estado del Form
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              labelText:
                                                  "Nombre del cliente:",
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red),
                                              errorText: snapshot.error
                                                  ?.toString(),
                                            ),
                                            maxLength: 255,
                                            maxLines: 2);
                                      }),
                                  StreamBuilder(
                                      stream: bloc.celularStream,
                                      builder: (context, snapshot) {
                                        return TextFormField(
                                            onChanged:
                                                bloc.changeCelular,
                                            controller:
                                                _ingresoTextController,
                                            keyboardType:
                                                TextInputType.phone,
                                            inputFormatters: <TextInputFormatter>[
                                              // for below version 2 use this
                                              FilteringTextInputFormatter
                                                  .allow(RegExp(
                                                      r'[0-9]')),
                        // for version 2 and greater youcan also use this
                                            ],
                                            textCapitalization:
                                                TextCapitalization
                                                    .sentences,
                                            onSaved: (value) {
                                              //Este evento se ejecuta cuando se cumple la validación y cambia el estado del Form
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              labelText:
                                                  "Ingrese el celular del cliente:",
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              errorStyle: const TextStyle(
                                                  color: Colors.red),
                                              errorText: snapshot.error
                                                  ?.toString(),
                                            ),
                                            maxLength: 10,
                                            maxLines: 1);
                                      }),
                                  
                                  
                                ],
                              ),
                            )),
                  _onSaving
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20.0),
                                              child: Text(
                                                "Enviado ✔️",
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20.0),
                                              child: Tooltip(
                                                message:
                                                    "Registra tu cliente.",
                                                child: ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.blue),
                                                    onPressed: () {
                                                      _cliente.nombreCliente =
                                                          _actividadDescriptionTextController
                                                              .text;
                                                      _cliente.celularCliente =_ingresoTextController.text;
                                                         
                                                            
                                                     
                                                      if (_actividadDescriptionTextController
                                                                  .text
                                                                  .length >=
                                                              5 &&
                                                          _ingresoTextController
                                                              .text.length>9
                                                              ) {
                                                        _onSaving = true;
                                                        setState(() {});
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      surfaceTintColor:
                                                                          Colors.white,
                                                                      title: const Text(
                                                                          'Exito'),
                                                                      content:
                                                                          const Text('Cliente agregado correctamente.'),
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
                                                        _clienteService.postCliente(_cliente);                                          
                                                                
                                                      }
                                                    },
                                                    label: const Text(
                                                        "Guardar",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white)),
                                                    icon: const Icon(
                                                        Icons.save,
                                                        color: Colors.white)),
                                              ),
                                            ),const Text(
                                            "Recuerda que toda actividad de la aplicación queda registrada en la consola de administración",
                                            style: TextStyle(color: Colors.grey),textAlign: TextAlign.center
                                            ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
