import 'package:flutter/material.dart';
import 'package:sqlite/db.dart';
import 'package:sqlite/home.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              Card(
                child: Row(
                  children: [
                    Text('user1 - 27'),
                    IconButton(
                      onPressed: ()=>_delete(1),
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => _update(context, 1, 'user1', 27),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Text('user2 - 29'),
                    IconButton(
                      onPressed: ()=>_delete(2),
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => _update(context, 2, 'user2', 29),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Text('user3 - 30'),
                    IconButton(
                      onPressed: ()=>_delete(3),
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => _update(context, 3, 'user3', 30),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _update(BuildContext context, int id, String nom, int edad) async {
    final name = TextEditingController();
    final age = TextEditingController();

    name.text = nom;
    age.text = edad.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insertar nuevo usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nombre'),
              TextFormField(
                controller: name,
                obscureText: false ,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    errorText: null
                ),
                onChanged: (texto) {
                },
              ),
              const SizedBox(height: 20,),
              const Text('Años(int)'),
              TextFormField(
                controller: age,
                obscureText: false ,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    errorText: null
                ),
                onChanged: (texto) {
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                ///JSON
                _update2(id, name.text, int.parse(age.text)); // = print("");

                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  void _update2(id, Nombre, edad) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: Nombre,
      DatabaseHelper.columnAge: edad
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }
}
