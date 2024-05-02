import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:funeraria14/src/models/actividad_model.dart';
import 'package:funeraria14/src/models/adddeuda_model.dart';
import 'package:funeraria14/src/models/deuda_model.dart';

class DeudaService {
  DeudaService();
  final db = FirebaseFirestore.instance;
  Future postDeuda(DeudaAdd deuda) async {
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
    db.collection('Deudas').add({
      "fecha_deuda": solofechavariosdocletras,
      "fecha": '$solofechavariosdoc $solohora',
      "valor_deuda": deuda.valorDeuda,
      "detalle_deuda": deuda.detalleDeuda,
      "deuda_final": deuda.valorDeuda! - deuda.anticipo!,
      "transacciones": [
        {
          "fecha_transaccion": '$solofechavariosdocletras $solohora',
          "anticipo": deuda.anticipo,
          "deuda_total": deuda.valorDeuda! - deuda.anticipo!
        }
      ],
    }).then((documentSnapshot) => db
        .collection("Deudas")
        .doc(documentSnapshot.id)
        .update({"id_deuda": documentSnapshot.id}));
    postActividad(deuda.detalleDeuda!, deuda.anticipo.toString());
  }

  Future postActividad(String deuda, String monto) async {
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
              "descripcion":
                  'Se agrego la deuda de $deuda y se pago de anticipo $monto \$',
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
              "descripcion":
                  'Se agrego la deuda de $deuda y se pago de anticipo $monto \$',
              "hora": solohora
            }
          ])
        });
      }
    }, onError: (e) {});
  }

  Future deleteDeuda(Deuda model) async {
    db.collection("Deudas").doc(model.idDeuda).delete().then(
          // ignore: avoid_print
          (doc) => print("Document deleted"),
          // ignore: avoid_print
          onError: (e) => print("Error updating document $e"),
        );
  }

  Future pagoDeuda(Deuda model, double pago) async {
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

    final year = now.year.toString();
    final hour = now.hour.toString();
    final minute = now.minute.toString();
    final second = now.second.toString();

    String solofechavariosdocletras = '$dianombre, $dia de $mesletras de $year';
    String solohora = '$hour:$minute:$second';
    db.collection("Deudas").doc(model.idDeuda).update({
      "deuda_final":
          double.parse((model.transacciones[model.transacciones.length - 1].deudaTotal -
                  pago).toStringAsFixed(2)),
      "transacciones": FieldValue.arrayUnion([
        {
          "anticipo": pago,
          "deuda_total":
              double.parse((model.transacciones[model.transacciones.length - 1].deudaTotal -
                  pago).toStringAsFixed(2)),
          "fecha_transaccion": '$solofechavariosdocletras $solohora',
        }
      ]),
    });
  }
}
