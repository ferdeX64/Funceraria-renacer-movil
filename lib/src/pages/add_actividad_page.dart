import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:funeraria14/src/bloc/signup_bloc.dart';
import 'package:funeraria14/src/services/actividad_service.dart';

class AddActividadPage extends StatefulWidget {
  const AddActividadPage({super.key});

  @override
  State<AddActividadPage> createState() => _AddActividadPageState();
}

class _AddActividadPageState extends State<AddActividadPage> {
  final _formKey = GlobalKey<FormState>();
  late SignUpBloc bloc;

  final TextEditingController _actividadDescriptionTextController =
      TextEditingController();
  final ActividadService _actividadService = ActividadService();
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
                      "Agregar actividad",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal:20.0),
                      child:  Text(
                        "Registra la visita de un cliente o algo que destaque",
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
                        Center(
                          child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    StreamBuilder(
                                        stream: bloc
                                            .actividadDescriptionStream,
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
                                              decoration:
                                                  InputDecoration(
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .black),
                                                ),
                                                labelText:
                                                    "Descripción de la actividad:",
                                                labelStyle:
                                                    const TextStyle(
                                                        color: Colors
                                                            .black),
                                                errorStyle:
                                                    const TextStyle(
                                                        color:
                                                            Colors.red),
                                                errorText: snapshot
                                                    .error
                                                    ?.toString(),
                                              ),
                                              maxLength: 255,
                                              maxLines: 2);
                                        }),
                                    _onSaving
                                        ? const Padding(
                                            padding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20.0),
                                            child:
                                                Text(
                                                          "Enviado ✔️",
                                                          ),)
                                        : Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                vertical: 20.0),
                                            child: Tooltip(
                                              message:
                                                  "Guardar tu actividad.",
                                              child:
                                                  ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .blue),
                                                      onPressed: () {
                                                        if (_actividadDescriptionTextController
                                                                .text
                                                                .length >=
                                                            5) {
                                                          _onSaving =
                                                              true;
                                                              setState(() {});
                                                          _actividadService.postActividad(
                                                              _actividadDescriptionTextController
                                                                  .text,
                                                              context);
                                                          
                                                        }
                                                      },
                                                      label: const Text(
                                                          "Guardar",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      icon: const Icon(
                                                          Icons.save,
                                                          color: Colors
                                                              .white)),
                                            ),
                                          )
                                  ],
                                ),
                              )),
                        ),
                        const Text(
                            "Recuerda que toda actividad de la aplicación queda registrada en la consola de administración",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center),
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
