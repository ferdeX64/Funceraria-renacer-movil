import 'dart:io';

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funeraria14/src/bloc/signup_bloc.dart';
import 'package:funeraria14/src/models/inventario_model.dart';

import 'package:funeraria14/src/services/inventario_service.dart';
import 'package:image_picker/image_picker.dart';

class AddInventarioPage extends StatefulWidget {
  const AddInventarioPage({super.key});

  @override
  State<AddInventarioPage> createState() => _AddInventarioPageState();
}

class _AddInventarioPageState extends State<AddInventarioPage> {
  final _formKey = GlobalKey<FormState>();

  File? _imagen;
  late final Inventario _inventario = Inventario();
  final InventarioService _inventarioService = InventarioService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _actividadDescriptionTextController =
      TextEditingController();
  late SignUpBloc bloc;
  final TextEditingController _ingresoTextController = TextEditingController();

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
                padding: const EdgeInsets.only(top: 65, bottom: 0),
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
                      "Agregar un producto",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal:20.0),
                      child:  Text(
                        "Llego un nuevo producto? Registralo ahora!",
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
                                    horizontal: 7.0, vertical: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                                _inventario.nombreProducto =
                                                    value.toString();
                                              },
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                labelText:
                                                    "Nombre del producto:",
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
                                        stream: bloc.videonameStream,
                                        builder: (context, snapshot) {
                                          return TextFormField(
                                              onChanged:
                                                  bloc.changeVideoname,
                                              controller:
                                                  _ingresoTextController,
                                              keyboardType:
                                                  TextInputType.phone,
                                              inputFormatters: <TextInputFormatter>[
                                                // for below version 2 use this
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'[0-9]')),
                        // for version 2 and greater youcan also use this
                                              ],
                                              textCapitalization:
                                                  TextCapitalization
                                                      .sentences,
                                              onSaved: (value) {
                                                //Este evento se ejecuta cuando se cumple la validación y cambia el estado del Form
                                                _inventario.cantidad =
                                                    int.parse(
                                                        value.toString());
                                              },
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                labelText:
                                                    "Ingrese la cantidad:",
                                                labelStyle: const TextStyle(
                                                    color: Colors.black),
                                                errorStyle: const TextStyle(
                                                    color: Colors.red),
                                                errorText: snapshot.error
                                                    ?.toString(),
                                              ),
                                              maxLength: 6,
                                              maxLines: 1);
                                        }),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7.0),
                                      child: Text(
                                          "Selecciona la imagen del producto:"),
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: _imagen == null
                                          ? Image.asset(
                                              'assets/images/caja.png')
                                          : Image.file(_imagen!),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton.icon(
                                            onPressed: () => _selectImage(
                                                ImageSource.camera),
                                            icon: const Icon(Icons.camera),
                                            label: const Text("Cámara")),
                                        ElevatedButton.icon(
                                            onPressed: () => _selectImage(
                                                ImageSource.gallery),
                                            icon: const Icon(Icons.image),
                                            label: const Text("Galería")),
                                      ],
                                    ),
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
                                              message: "Guardar producto.",
                                              child: ElevatedButton.icon(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                  onPressed: () {
                                                    if (_actividadDescriptionTextController
                                                                .text
                                                                .length >=
                                                            5 &&
                                                        _ingresoTextController
                                                            .text
                                                            .isNotEmpty &&
                                                        _imagen != null) {
                                                      _sendForm();
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
                                          )
                                  ],
                                ),
                              )),
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

  Future _selectImage(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _imagen = File(pickedFile.path);
    } else {
      _imagen = null;
      //print('No image selected.');
    }
    setState(() {});
  }

  _sendForm() async {
    if (!_formKey.currentState!.validate()) return;
  _onSaving=true;
    setState(() {});

    //Vincula el valor de las controles del formulario a los atributos del modelo
    _formKey.currentState!.save();

    if (_imagen != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                surfaceTintColor: Colors.white,
                title: const Text('Exito'),
                content: const Text('Producto agregada correctamente.'),
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
      _inventario.urlFoto = [await _inventarioService.uploadImage(_imagen!)];
      // ignore: use_build_context_synchronously
      _inventarioService.postProducto(_inventario);
    }
  }
}
