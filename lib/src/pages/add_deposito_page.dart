import 'dart:io';

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';


import 'package:funeraria14/src/services/recibo_service.dart';
import 'package:image_picker/image_picker.dart';

class AddDepositoPage extends StatefulWidget {
  const AddDepositoPage({super.key});

  @override
  State<AddDepositoPage> createState() => _AddDepositoPageState();
}

class _AddDepositoPageState extends State<AddDepositoPage> {
  final _formKey = GlobalKey<FormState>();

  File? _imagen;
  final ReciboService _reciboService = ReciboService();
  final ImagePicker _picker = ImagePicker();

  var _onSaving = false;

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
                      "Agregar un recibo",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Sube la fotografía del deposito al final del día 🌇 ",
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
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 7.0),
                                      child: Text(
                                          "Selecciona la imagen del recibo:"),
                                    ),
                                    SizedBox(
                                      height: 130,
                                      child: _imagen == null
                                          ? Image.asset(
                                              'assets/images/recibo.png')
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
                                                    if (_imagen != null) {
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
    _onSaving = true;
    setState(() {});

    //Vincula el valor de las controles del formulario a los atributos del modelo
    _formKey.currentState!.save();
    List<dynamic> urlFoto;
    if (_imagen != null) {
      urlFoto = [await _reciboService.uploadImage(_imagen!)];
      // ignore: use_build_context_synchronously
      _reciboService.postRecibo(urlFoto, context);
    }
  }
}
