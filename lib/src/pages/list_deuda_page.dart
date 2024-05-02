import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:funeraria14/src/bloc/signup_bloc.dart';
import 'package:funeraria14/src/models/deuda_model.dart';
import 'package:funeraria14/src/services/deuda_service.dart';
import 'package:funeraria14/src/widgets/details_deuda.dart';



class DeudaListPage extends StatefulWidget {
  const DeudaListPage({super.key});

  @override
  State<DeudaListPage> createState() => _DeudaListPageState();
}

class _DeudaListPageState extends State<DeudaListPage> {
  final ScrollController controller = ScrollController();



  late SignUpBloc bloc = SignUpBloc();
late final DeudaService _deudaService=DeudaService();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> deudaStream = FirebaseFirestore.instance
        .collection('Deudas')
        .orderBy("fecha", descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50),
              child: Text("Lista de deudas",
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
              stream: deudaStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: SizedBox(
                        child: Text('Error al consultar las deudas.')),
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
                    child: SizedBox(child: Text('Aun no hay deudas')),
                  );
                }
                return ListView(
                    controller: controller,
                    physics: const ScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Deuda model = Deuda.fromJson(
                          document.data() as Map<String, dynamic>);
                      return Slidable(
                          key: UniqueKey(),
                          // The start action pane is the one at the left or the top side.
                          startActionPane: ActionPane(
                            extentRatio: 0.3,
                            // A motion is a widget used to control how the pane animates.
                            motion: const StretchMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                             _deudaService.deleteDeuda(model);
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
                            onTap: (

                              
                            ) {
                              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => DeudaDetails(model: model)));
                            },
                            leading: SizedBox.square(
                                dimension: 65,
                                child: Image.asset(
                                                  'assets/images/deuda.png'),),
                            title: Text(model.detalleDeuda),
                            subtitle: Text('Deuda: ${model.valorDeuda.toString()} \$'),
                            trailing: Text('Debo: ${model.deudaFinal.toString()} \$'),
                          )));
                    }).toList());
              },
            ),
          )),
    );
  }
}

void doNothing(BuildContext context) {}
