import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:funeraria14/src/models/actividad_model.dart';

import 'package:funeraria14/src/models/inventario_model.dart';

class InventarioService {
  InventarioService();
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

  Future postProducto(Inventario inventario) async {
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
    db.collection('Inventario').add({
      "fecha_inventario": solofechavariosdocletras,
      "fecha": "$solofechavariosdoc $solohora",
      "cantidad": inventario.cantidad,
      "nombre_producto": inventario.nombreProducto,
      "url_foto": inventario.urlFoto
    }).then((documentSnapshot) => db
        .collection("Inventario")
        .doc(documentSnapshot.id)
        .update({"id_producto": documentSnapshot.id}));
    postActividad(inventario.nombreProducto, inventario.cantidad);
  }

  Future postActividad(String? descripcion, int? cantidad) async {
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
              "descripcion": 'Se agrego al inventario $cantidad $descripcion',
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
            {
              "descripcion": 'Se agrego al inventario  $cantidad $descripcion',
              "hora": solohora
            }
          ])
        });
      }
    }, onError: (e) {});
  }

  Future deleteProducto(Inventario model) async {
    db.collection("Inventario").doc(model.idProducto).delete().then(
          // ignore: avoid_print
          (doc) => print("Document deleted"),
          // ignore: avoid_print
          onError: (e) => print("Error updating document $e"),
        );
  }

  Future updateCantidad(Inventario model, cantidad) async {
    db
        .collection("Inventario")
        .doc(model.idProducto)
        .update({"cantidad": int.parse(cantidad)});
        postActualizacion(model.nombreProducto, int.parse(cantidad));
  }

  Future postActualizacion(String? descripcion, int? cantidad) async {
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
              "descripcion": 'Se actualizo $descripcion a $cantidad ',
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
            {
              "descripcion": 'Se actualizo $descripcion a $cantidad ',
              "hora": solohora
            }
          ])
        });
      }
    }, onError: (e) {});
  }
}
