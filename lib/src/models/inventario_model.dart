// To parse this JSON data, do
//
//     final inventario = inventarioFromJson(jsonString);

import 'dart:convert';

Inventario inventarioFromJson(String str) => Inventario.fromJson(json.decode(str));

String inventarioToJson(Inventario data) => json.encode(data.toJson());

class Inventario {
    String? nombreProducto;
    String? fechaIngreso;
    int? cantidad;
    List<String>? urlFoto;
    String? idProducto;

    Inventario({
        this.nombreProducto,
        this.fechaIngreso,
        this.cantidad,
        this.urlFoto,
        this.idProducto,
    });

    factory Inventario.fromJson(Map<String, dynamic> json) => Inventario(
        nombreProducto: json["nombre_producto"],
        fechaIngreso: json["fecha_ingreso"],
        cantidad: json["cantidad"],
        urlFoto: json["url_foto"] == null ? [] : List<String>.from(json["url_foto"]!.map((x) => x)),
        idProducto: json["id_producto"],
    );

    Map<String, dynamic> toJson() => {
        "nombre_producto": nombreProducto,
        "fecha_ingreso": fechaIngreso,
        "cantidad": cantidad,
        "url_foto": urlFoto == null ? [] : List<dynamic>.from(urlFoto!.map((x) => x)),
        "id_producto": idProducto,
    };
}
