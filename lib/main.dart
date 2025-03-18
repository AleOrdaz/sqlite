import 'package:flutter/material.dart';
import 'package:sqlite/db.dart';
import 'package:sqlite/singleton.dart';
import 'package:sqlite/user.dart';

final dbHelper = DatabaseHelper();

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized(); //Inicializa los widgets

  await dbHelper.init(); // initialize the database

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _insert(context), //Llamado a un ALERTDIALOG
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _select(context),
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _update(3, 'Alejandro Ordaz', 28),
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _delete(1),
              child: const Text('delete'),
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods
  void _insert(BuildContext context) async {
    final name = TextEditingController();
    final age = TextEditingController();

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
                Map<String, dynamic> row = {
                  DatabaseHelper.columnName: name.text,
                  DatabaseHelper.columnAge: int.parse(age.text)
                };
                final id = await dbHelper.insert(row);

                debugPrint('inserted row id: $id'); // = print("");

                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _select(BuildContext context) async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    singleton.users = allRows;
    for (final row in allRows) {
      debugPrint(row.toString());
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => Users()));
  }



  void _update(id, Nombre, edad) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: Nombre,
      DatabaseHelper.columnAge: edad
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }
}
/*
* FutureBuilder<String>(
    future: downloadData(), // function where you call your api
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
      if( snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: Text('Please wait its loading...'));
      }else{
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Center(child: new Text('${snapshot.data}'));  // snapshot.data  :- get your object which is pass from your downloadData() function
      }
    },
  );
}
Future<String> downloadData()async{
  //   var response =  await http.get('https://getProjectList');
  return Future.value("Data download successfully"); // return your response
}
* */