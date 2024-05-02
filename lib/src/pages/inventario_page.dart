

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';

import 'package:funeraria14/src/pages/add_inventario_page.dart';
import 'package:funeraria14/src/pages/list_inventario_page.dart';




class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final bordersvertical = MediaQuery.of(context).size.height * 4 / 100;
    final bordershorizontal = MediaQuery.of(context).size.width * 6 / 100;



    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 2,
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, colors: [
            
             Color.fromARGB(255, 164, 201, 247),Color.fromARGB(255, 2, 56, 144),
             
            Color.fromARGB(255, 124, 140, 239),
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 65, bottom: 20),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                       'assets/images/cruz.png',
                        height: 70,
                        width: 70,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Inventario",textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const  Padding(
                      padding: EdgeInsets.symmetric(horizontal:20.0),
                      child:  Text(
                        "Registra tus productos y mira todo lo que hay disponible 📦", textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: bordersvertical),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: bordershorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      
                          
                        MaterialButton(
                          onPressed: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddInventarioPage()));
                            
                          },
                          height: 50,
                          // margin: EdgeInsets.symmetric(horizontal: 50),
                          color: const Color.fromARGB(255, 2, 56, 144),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          // decoration: BoxDecoration(
                          // ),
                          
                           child: const Center(
                            child: Text(
                        "Agregar producto",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,fontSize: 18),
                            ),
                          ),),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InventarioListPage()));
                          },
                          height: 50,
                          // margin: EdgeInsets.symmetric(horizontal: 50),
                          color: const Color.fromARGB(255, 2, 56, 144),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          // decoration: BoxDecoration(
                          // ),
                          child: const Center(
                            child: Text(
                              "Ver productos",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,fontSize: 18),
                            ),
                          ),
                        ),
                          
                        const Text(
                          "Recuerda que toda actividad de la aplicación queda registrada en la consola de administración",
                          style: TextStyle(color: Colors.grey),textAlign: TextAlign.center
                        ),
                        
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
