// To parse this JSON data, do
//
//     final addCliente = addClienteFromJson(jsonString);

import 'dart:convert';

AddCliente addClienteFromJson(String str) => AddCliente.fromJson(json.decode(str));

String addClienteToJson(AddCliente data) => json.encode(data.toJson());

class AddCliente {
    String? idCliente;
    String? celularCliente;
    String? nombreCliente;

    AddCliente({
        this.idCliente,
        this.celularCliente,
        this.nombreCliente,
    });

    factory AddCliente.fromJson(Map<String, dynamic> json) => AddCliente(
        idCliente: json["id_cliente"],
        celularCliente: json["celular_cliente"],
        nombreCliente: json["nombre_cliente"],
    );

    Map<String, dynamic> toJson() => {
        "id_cliente": idCliente,
        "celular_cliente": celularCliente,
        "nombre_cliente": nombreCliente,
    };
}
