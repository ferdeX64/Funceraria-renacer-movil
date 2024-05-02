// ignore: file_names
import 'dart:convert';

DeudaAdd deudaAddFromJson(String str) => DeudaAdd.fromJson(json.decode(str));

String deudaAddToJson(DeudaAdd data) => json.encode(data.toJson());

class DeudaAdd {
    String? fechaDeuda;
    String? fecha;
    double? valorDeuda;
    String? detalleDeuda;
    double? deudaFinal;
    String? fechaTransaccion;
    double? anticipo;
    double? deudaTotal;

    DeudaAdd({
        this.fechaDeuda,
        this.fecha,
        this.valorDeuda,
        this.detalleDeuda,
        this.deudaFinal,
        this.fechaTransaccion,
        this.anticipo,
        this.deudaTotal,
    });

    factory DeudaAdd.fromJson(Map<String, dynamic> json) => DeudaAdd(
        fechaDeuda: json["fecha_deuda"],
        fecha: json["fecha"],
        valorDeuda: json["valor_deuda"]?.toDouble(),
        detalleDeuda: json["detalle_deuda"],
        deudaFinal: json["deuda_final"]?.toDouble(),
        fechaTransaccion: json["fecha_transaccion"],
        anticipo: json["anticipo"]?.toDouble(),
        deudaTotal: json["deuda_total"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "fecha_deuda": fechaDeuda,
        "fecha": fecha,
        "valor_deuda": valorDeuda,
        "detalle_deuda": detalleDeuda,
        "deuda_final": deudaFinal,
        "fecha_transaccion": fechaTransaccion,
        "anticipo": anticipo,
        "deuda_total": deudaTotal,
    };
}
