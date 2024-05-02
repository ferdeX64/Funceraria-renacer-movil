// ignore_for_file: non_constant_identifier_names

class Fondos {
  String id_fondo;
  String fecha;
  String fecha_fondo;
   double dinero_caja;
    double total_caja;
  List<dynamic> transacciones;

  Fondos({
    required this.id_fondo,
    required this.fecha,
    required this.fecha_fondo,
    required this.dinero_caja,
    required this.total_caja,
    required this.transacciones,
  });
}