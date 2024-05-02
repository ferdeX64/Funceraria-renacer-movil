import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:funeraria14/src/models/actividad_model.dart';
import 'package:funeraria14/src/models/cliente_model.dart';

class ClienteService{
  ClienteService();
    final db = FirebaseFirestore.instance;
  Future postCliente(AddCliente cliente) async {
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
    db.collection('Clientes').add({
      "fecha_cliente": solofechavariosdocletras,
      "fecha": "$solofechavariosdoc $solohora",
      "nombre_cliente": cliente.nombreCliente,
      "celular_cliente": cliente.celularCliente,
    }).then((documentSnapshot) => db
        .collection("Clientes")
        .doc(documentSnapshot.id)
        .update({"id_cliente": documentSnapshot.id}));
    postActividad(cliente);
  }

  Future postActividad(AddCliente cliente) async {
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
              "descripcion": 'Se agrego al cliente ${cliente.nombreCliente}',
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
              "descripcion":  'Se agrego al cliente ${cliente.nombreCliente}',
              "hora": solohora
            }
          ])
        });
      }
    }, onError: (e) {});
  }
   Future deleteCliente(AddCliente model) async {
    db.collection("Clientes").doc(model.idCliente).delete().then(
          // ignore: avoid_print
          (doc) => print("Document deleted"),
          // ignore: avoid_print
          onError: (e) => print("Error updating document $e"),
        );
  }
}