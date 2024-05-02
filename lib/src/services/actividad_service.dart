import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funeraria14/src/models/actividad_model.dart';
import 'package:funeraria14/src/models/fondos_model.dart';

class ActividadService {
  ActividadService();
  final db = FirebaseFirestore.instance;

  Future<int> postActividad(String descripcion, BuildContext context) async {
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
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              surfaceTintColor: Colors.white,
              title: const Text('Exito'),
              content: const Text('Actvidad agregada correctamente.'),
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
              "descripcion": descripcion,
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
            {"descripcion": descripcion, "hora": solohora}
          ])
        });

        return 500;
      }
    }, onError: (e) {});
    return 201;
  }

  Future<int> postIngreso(
      String descripcion, String ingreso, BuildContext context) async {
    final now = DateTime.now();
    
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  surfaceTintColor: Colors.white,
                  title: const Text('Exito'),
                  content: const Text('Ingreso agregado correctamente.'),
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
              "descripcion": descripcion,
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
            {"descripcion": descripcion, "hora": solohora}
          ])
        });

      }

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
          db.collection('Fondos').add({
            "fecha_fondo": solofechavariosdocletras,
            "dinero_caja": 0,
            "fecha": solofechavariosdoc,
            "total_caja":
                double.parse((double.parse(ingreso)).toStringAsFixed(2)),
            "transacciones": [
              {
                "detalle_transaccion": descripcion,
                "ingreso":
                    double.parse((double.parse(ingreso)).toStringAsFixed(2)),
                "hora": solohora,
                "saldo_total":
                    double.parse((double.parse(ingreso)).toStringAsFixed(2))
              }
            ]
          }).then((documentSnapshot) => db
              .collection("Fondos")
              .doc(documentSnapshot.id)
              .update({"id_fondo": documentSnapshot.id}));
        } else {
          db.collection("Fondos").doc(fondos[0].id_fondo).update({
            "total_caja": double.parse(
                (fondos[0].transacciones[fondos[0].transacciones.length - 1]
                            ['saldo_total'] +
                        double.parse(ingreso))
                    .toStringAsFixed(2)),
            "transacciones": FieldValue.arrayUnion([
              {
                "detalle_transaccion": descripcion,
                "ingreso": double.parse((double.parse(ingreso)).toStringAsFixed(2)),
                "hora": solohora,
                "saldo_total": double.parse(
                    (fondos[0].transacciones[fondos[0].transacciones.length - 1]
                                ['saldo_total'] +
                            double.parse(ingreso))
                        .toStringAsFixed(2)),
              }
            ]),
          });
        }
      }, onError: (e) {});
    }, onError: (e) {});
    return 201;
  }

  Future<int> postGasto(
      String descripcion, String gasto, BuildContext context) async {
    final now = DateTime.now();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              surfaceTintColor: Colors.white,
              title: const Text('Exito'),
              content: const Text('Gasto agregado correctamente.'),
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
              "descripcion": descripcion,
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
            {"descripcion": descripcion, "hora": solohora}
          ])
        });
      }

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
          db.collection('Fondos').add({
            "fecha_fondo": solofechavariosdocletras,
            "dinero_caja": 0,
            "fecha": solofechavariosdoc,
            "total_caja":
                -double.parse((double.parse(gasto)).toStringAsFixed(2)),
            "transacciones": [
              {
                "detalle_transaccion": descripcion,
                "gasto": double.parse((double.parse(gasto)).toStringAsFixed(2)),
                "hora": solohora,
                "saldo_total":
                    -double.parse((double.parse(gasto)).toStringAsFixed(2))
              }
            ]
          }).then((documentSnapshot) => db
              .collection("Fondos")
              .doc(documentSnapshot.id)
              .update({"id_fondo": documentSnapshot.id}));
        } else {
          db.collection("Fondos").doc(fondos[0].id_fondo).update({
            "total_caja": double.parse(
                (fondos[0].transacciones[fondos[0].transacciones.length - 1]
                            ['saldo_total'] -
                        double.parse(gasto))
                    .toStringAsFixed(2)),
            "transacciones": FieldValue.arrayUnion([
              {
                "detalle_transaccion": descripcion,
                "gasto": double.parse((double.parse(gasto)).toStringAsFixed(2)),
                "hora": solohora,
                "saldo_total": double.parse(
                    (fondos[0].transacciones[fondos[0].transacciones.length - 1]
                                ['saldo_total'] -
                            double.parse(gasto))
                        .toStringAsFixed(2)),
              }
            ]),
          });
        }
      }, onError: (e) {});
    }, onError: (e) {});
    return 201;
  }
}
