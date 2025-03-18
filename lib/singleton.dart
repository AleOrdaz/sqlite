class Singleton {
  static Singleton? _instance; //Crea la instancia para usar singleton

  Singleton._internal() { //Si ya existe una instancia nos la devuelve
    _instance = this;
  }

  //Verifica si singleton es null/vacio, si es así crea una nueva instancia
  //si no devuelve la que ya existe
  factory Singleton() => _instance ?? Singleton._internal();

  var users;
}

final singleton = Singleton();