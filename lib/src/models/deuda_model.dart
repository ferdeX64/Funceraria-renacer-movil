// To parse this JSON data, do
//
//     final deuda = deudaFromJson(jsonString);

import 'dart:convert';

Deuda deudaFromJson(String str) => Deuda.fromJson(json.decode(str));

String deudaToJson(Deuda data) => json.encode(data.toJson());

class Deuda {
    String fechaDeuda;
    String fecha;
    String idDeuda;
    double valorDeuda;
    String detalleDeuda;
    double deudaFinal;
    List<Transaccione> transacciones;

    Deuda({
        required this.fechaDeuda,
        required this.fecha,
        required this.idDeuda,
        required this.valorDeuda,
        required this.detalleDeuda,
        required this.deudaFinal,
        required this.transacciones,
    });

    factory Deuda.fromJson(Map<String, dynamic> json) => Deuda(
        fechaDeuda: json["fecha_deuda"],
        fecha: json["fecha"],
        idDeuda: json["id_deuda"],
        valorDeuda: json["valor_deuda"]?.toDouble(),
        detalleDeuda: json["detalle_deuda"],
        deudaFinal: json["deuda_final"]?.toDouble(),
        transacciones: List<Transaccione>.from(json["transacciones"].map((x) => Transaccione.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "fecha_deuda": fechaDeuda,
        "fecha": fecha,
        "id_deuda": idDeuda,
        "valor_deuda": valorDeuda,
        "detalle_deuda": detalleDeuda,
        "deuda_final": deudaFinal,
        "transacciones": List<dynamic>.from(transacciones.map((x) => x.toJson())),
    };
}

class Transaccione {
    String fechaTransaccion;
    double anticipo;
    double deudaTotal;

    Transaccione({
        required this.fechaTransaccion,
        required this.anticipo,
        required this.deudaTotal,
    });

    factory Transaccione.fromJson(Map<String, dynamic> json) => Transaccione(
        fechaTransaccion: json["fecha_transaccion"],
        anticipo: json["anticipo"]?.toDouble(),
        deudaTotal: json["deuda_total"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "fecha_transaccion": fechaTransaccion,
        "anticipo": anticipo,
        "deuda_total": deudaTotal,
    };
}
