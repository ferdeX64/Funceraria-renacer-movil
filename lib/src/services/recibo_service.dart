import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:funeraria14/src/models/actividad_model.dart';
import 'package:funeraria14/src/models/fondos_model.dart';

class ReciboService {
  ReciboService();
  final db = FirebaseFirestore.instance;
  Future<String> uploadImage(File image) async {
    final cloudinary = CloudinaryPublic('dcdvfurak', 'doyxxv6g', cache: false);
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      // ignore: avoid_print
      print(e.message);
      // ignore: avoid_print
      print(e.request);
      return "";
    }
  }
  Future postRecibo(List<dynamic> url, BuildContext context) async {
    final now = DateTime.now();
    String dia = now.day.toString();
    final mes = now.month.toString();
    final year = now.year.toString();
    String solofechavariosdoc = '$year/$mes/$dia';
    List<Fondos> fondos = [];
    db
        .collection('Fondos')
        .where("fecha", isEqualTo: solofechavariosdoc)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        fondos.add(Fondos(
            id_fondo: docSnapshot.data()['id_fondo'],
            fecha: docSnapshot.data()['fecha'],
            fecha_fondo: docSnapshot.data()['fecha_fondo'],
            dinero_caja:
                double.parse(docSnapshot.data()['dinero_caja'].toString()),
            total_caja:
                double.parse(docSnapshot.data()['total_caja'].toString()),
            transacciones: docSnapshot.data()['transacciones']));
      }
      if (fondos.isEmpty) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  surfaceTintColor: Colors.white,
                  title: const Text('Error'),
                  content: const Text('El recibo solo se debe subir al final del día.'),
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
      } else {showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  surfaceTintColor: Colors.white,
                  title: const Text('Exito'),
                  content: const Text('El recibo se subio correctamente.'),
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
        db.collection("Fondos").doc(fondos[0].id_fondo).update({
          "url_recibo":url
        });
        postActividad();
      }
    }, onError: (e) {});
  }
  Future<int> postActividad() async {
    final now = DateTime.now();

    var diasemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    var meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    String dianombre = diasemana[now.weekday - 1];
    String dia = now.day.toString();
    final mesletras = meses[now.month - 1];
    final mes = now.month.toString();
    final year = now.year.toString();
    final hour = now.hour.toString();
    final minute = now.minute.toString();
    final second = now.second.toString();
    String solofechavariosdoc = '$year/$mes/$dia';
    String solofechavariosdocletras = '$dianombre, $dia de $mesletras de $year';
    String solohora = '$hour:$minute:$second';
    List<Actividad> actividades = [];
  

    db
        .collection('Actividades secretaria')
        .where("fecha", isEqualTo: solofechavariosdoc)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        actividades.add(Actividad(
            id_actividad: docSnapshot.data()['id_actividad'],
            fecha: docSnapshot.data()['fecha'],
            fecha_actividad: docSnapshot.data()['fecha_actividad'],
            actividad: docSnapshot.data()['actividad']));
      }
      if (actividades.isEmpty) {
        db.collection('Actividades secretaria').add({
          "fecha_actividad": solofechavariosdocletras,
          "fecha": solofechavariosdoc,
          "actividad": [
            {
              "descripcion": 'Se subio el recibo del depósito del día de hoy.',
              "hora": solohora,
            }
          ],
        }).then((documentSnapshot) => db
            .collection("Actividades secretaria")
            .doc(documentSnapshot.id)
            .update({"id_actividad": documentSnapshot.id}));
      } else {
        db
            .collection("Actividades secretaria")
            .doc(actividades[0].id_actividad)
            .update({
          "actividad": FieldValue.arrayUnion([
            {"descripcion":  'Se subio el recibo del depósito del día de hoy.', "hora": solohora}
          ])
        });

        return 500;
      }
    }, onError: (e) {});
    return 201;
  }
}
