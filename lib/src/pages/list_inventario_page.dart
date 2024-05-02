import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:funeraria14/src/bloc/signup_bloc.dart';
import 'package:funeraria14/src/models/inventario_model.dart';
import 'package:funeraria14/src/services/inventario_service.dart';


class InventarioListPage extends StatefulWidget {
  const InventarioListPage({super.key});

  @override
  State<InventarioListPage> createState() => _InventarioListPageState();
}

class _InventarioListPageState extends State<InventarioListPage> {
  final ScrollController controller = ScrollController();

  late final InventarioService _inventarioService = InventarioService();

  late SignUpBloc bloc = SignUpBloc();

  TextEditingController _ingresoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> inventarioStream = FirebaseFirestore.instance
        .collection('Inventario')
        .orderBy("fecha", descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50),
              child: Text("Lista de inventario",
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 252, 250, 251)),
      body: Scrollbar(
          interactive: true,
          thickness: 10.0,
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: inventarioStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: SizedBox(
                        child: Text('Error al consultar los Pedidos.')),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: SizedBox(child: Text('Aun no hay productos')),
                  );
                }
                return ListView(
                    controller: controller,
                    physics: const ScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Inventario model = Inventario.fromJson(
                          document.data() as Map<String, dynamic>);
                      return Slidable(
                          key: UniqueKey(),
                          // The start action pane is the one at the left or the top side.
                          startActionPane: ActionPane(
                            extentRatio: 0.3,
                            // A motion is a widget used to control how the pane animates.
                            motion: const StretchMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                              _inventarioService
                                  .deleteProducto(model);
                            }),

                            // A pane can dismiss the Slidable.

                            // All actions are defined in the children parameter.
                            children: [
                              // A SlidableAction can have an icon and/or a label.
                              SlidableAction(
                                onPressed: doNothing,
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Eliminar',
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                          child: Card(
                              child: ListTile(
                            onTap: () {
                              _ingresoTextController  = TextEditingController();
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        surfaceTintColor: Colors.white,
                                        title:
                                            const Text('Actualizar cantidad'),
                                        content: StreamBuilder(
                                            stream: bloc.videonameStream,
                                            builder: (context, snapshot) {
                                              return TextFormField(
                                                  onChanged:
                                                      bloc.changeVideoname,
                                                  controller:
                                                      _ingresoTextController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  inputFormatters: <TextInputFormatter>[
                                                    // for below version 2 use this
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                                  ],
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  onSaved: (value) {},
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    labelText:
                                                        "Ingrese la cantidad:",
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                    errorStyle: const TextStyle(
                                                        color: Colors.red),
                                                    errorText: snapshot.error
                                                        ?.toString(),
                                                  ),
                                                  maxLength: 6,
                                                  maxLines: 1);
                                            }),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancelar')),
                                          TextButton(
                                              onPressed: () {
                                                if (_ingresoTextController
                                                    .text.isNotEmpty) {
                                                  _inventarioService
                                                      .updateCantidad(
                                                          model,
                                                          _ingresoTextController
                                                              .text);
                                                            
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            surfaceTintColor:
                                                                Colors.white,
                                                            title: const Text(
                                                                'Exito'),
                                                            content: const Text(
                                                                'Cantidad actualizada.'),
                                                            actions: <Widget>[
                                                              // ignore: deprecated_member_use
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                   
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Ok'))
                                                            ],
                                                          ));
                                                }
                                              },
                                              child: const Text('Actualizar'))
                                        ],
                                      ));
                            },
                            leading: SizedBox.square(
                                dimension: 65,
                                child: Image(
                                    image: NetworkImage(model.urlFoto![0]))),
                            title: Text(model.nombreProducto!),
                            subtitle: Text('Cantidad: ${model.cantidad.toString()}'),
                          )));
                    }).toList());
              },
            ),
          )),
    );
  }
}

void doNothing(BuildContext context) {}
