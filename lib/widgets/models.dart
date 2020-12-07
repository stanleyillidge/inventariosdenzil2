class Modificacion {
  String key;
  DateTime fecha;
  dynamic data;
}

class Referencia {
  String key;
  String nombre;
  Referencia({this.key, this.nombre});
  factory Referencia.fromFirebase(Map<String, dynamic> json) {
    return Referencia(key: json['key'], nombre: json['nombre']);
  }
  Map toJson() {
    return {
      'key': key,
      'nombre': nombre,
    };
  }
}

class Locations {
  String location;
  Referencia sede;
  Referencia ubicacion;
  Referencia subUbicacion;
  String key;
  String nombre;
  int cantidad;
  String descripcion;
  String imagen;
  dynamic file;
  Modificacion modificacion;
  int buenos;
  int malos;
  int regulares;

  Locations({
    this.location,
    this.sede,
    this.ubicacion,
    this.subUbicacion,
    this.key,
    this.nombre,
    this.cantidad,
    this.descripcion,
    this.imagen,
    this.file,
    this.modificacion,
    this.buenos,
    this.malos,
    this.regulares,
  });
  factory Locations.fromFirebase(Map<String, dynamic> json) {
    var location;
    var sede;
    var ubicacion;
    var subUbicacion;
    if ((json['sede'] == null) &&
        (json['ubicacion'] == null) &&
        (json['subUbicacion'] == null)) {
      location = 'sede';
      sede = Referencia.fromFirebase(json);
    } else if ((json['sede'] != null) &&
        (json['ubicacion'] == null) &&
        (json['subUbicacion'] == null)) {
      location = 'ubicacion';
      sede = Referencia(key: json['sede']);
      ubicacion = Referencia.fromFirebase(json);
    } else if ((json['sede'] != null) &&
        (json['ubicacion'] != null) &&
        (json['subUbicacion'] == null)) {
      location = 'subUbicacion';
      sede = Referencia(key: json['sede']);
      ubicacion = Referencia(key: json['ubicacion']);
      subUbicacion = Referencia.fromFirebase(json);
    }

    return Locations(
      location: location,
      sede: sede,
      ubicacion: ubicacion,
      subUbicacion: subUbicacion,
      key: json['key'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      file: json['file'],
      modificacion: json['modificacion'],
      buenos: (json['Buenos'] != null)
          ? json['Buenos']
          : (json['Bueno'] != null)
              ? json['Bueno']
              : 0,
      malos: (json['Malos'] != null)
          ? json['Malos']
          : (json['Malo'] != null)
              ? json['Malo']
              : 0,
      regulares: (json['Regulares'] != null)
          ? json['Regulares']
          : (json['Regular'] != null)
              ? json['Regular']
              : 0,
    );
  }
  factory Locations.fromLocal(Map<dynamic, dynamic> json) {
    return Locations(
      location: json['location'],
      sede: (json['sede'] != null)
          ? Referencia(key: json['sede']['key'], nombre: json['sede']['nombre'])
          : null,
      ubicacion: (json['ubicacion'] != null)
          ? Referencia(
              key: json['ubicacion']['key'],
              nombre: json['ubicacion']['nombre'])
          : null,
      subUbicacion: (json['subUbicacion'] != null)
          ? Referencia(
              key: json['subUbicacion']['key'],
              nombre: json['subUbicacion']['nombre'])
          : null,
      key: json['key'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      file: json['file'],
      modificacion: json['modificacion'],
      buenos: json['buenos'],
      malos: json['malos'],
      regulares: json['regulares'],
    );
  }
  Map toJson() {
    return {
      'location': location,
      'sede': (sede != null) ? sede.toJson() : null,
      'ubicacion': (ubicacion != null) ? ubicacion.toJson() : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion.toJson() : null,
      'key': key,
      'nombre': nombre,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'imagen': imagen,
      'file': file,
      'modificacion': modificacion,
      'buenos': buenos,
      'malos': malos,
      'regulares': regulares,
    };
  }
}

class Articulo {
  int cantidad;
  int fechaModif;
  String articulo;
  String creacion;
  String descripcion;
  String disponibilidad;
  String estado;
  String etiqueta;
  String etiquetaId;
  String fechaEtiqueta;
  String file;
  String imagen;
  String key;
  String modificaciones;
  String nombre;
  String nombreImagen;
  String observaciones;
  String serie;
  Referencia sede;
  Referencia ubicacion;
  Referencia subUbicacion;
  int valor;
  Articulo({
    this.articulo,
    this.cantidad,
    this.creacion,
    this.descripcion,
    this.disponibilidad,
    this.estado,
    this.etiqueta,
    this.etiquetaId,
    this.fechaEtiqueta,
    this.fechaModif,
    this.file,
    this.imagen,
    this.key,
    this.modificaciones,
    this.nombre,
    this.nombreImagen,
    this.observaciones,
    this.serie,
    this.sede,
    this.ubicacion,
    this.subUbicacion,
    this.valor,
  });
  factory Articulo.fromFirebase(Map<String, dynamic> json) {
    var sede;
    var ubicacion;
    var subUbicacion;
    if ((json['sede'] == null) &&
        (json['ubicacion'] == null) &&
        (json['subUbicacion'] == null)) {
      sede = Referencia.fromFirebase(json);
    } else if ((json['sede'] != null) &&
        (json['ubicacion'] == null) &&
        (json['subUbicacion'] == null)) {
      sede = Referencia(key: json['sede']);
      ubicacion = Referencia.fromFirebase(json);
    } else if ((json['sede'] != null) &&
        (json['ubicacion'] != null) &&
        (json['subUbicacion'] == null)) {
      sede = Referencia(key: json['sede']);
      ubicacion = Referencia(key: json['ubicacion']);
      subUbicacion = Referencia.fromFirebase(json);
    }

    return Articulo(
      sede: sede,
      ubicacion: ubicacion,
      subUbicacion: subUbicacion,
      articulo: json['articulo'],
      cantidad: json['cantidad'],
      creacion: json['creacion'],
      descripcion: json['descripcion'],
      disponibilidad: json['disponibilidad'],
      estado: json['estado'],
      etiqueta: json['etiqueta'],
      etiquetaId: json['etiquetaId'],
      fechaEtiqueta: json['fechaEtiqueta'],
      fechaModif: json['fechaModif'],
      file: json['file'],
      imagen: json['imagen'],
      key: json['key'],
      modificaciones: json['modificaciones'],
      nombre: json['nombre'],
      nombreImagen: json['nombreImagen'],
      observaciones: json['observaciones'],
      valor: json['valor'],
      serie: json['serie'],
    );
  }
  factory Articulo.fromLocal(Map<dynamic, dynamic> json) {
    return Articulo(
      sede: (json['sede'] != null)
          ? Referencia(key: json['sede']['key'], nombre: json['sede']['nombre'])
          : null,
      ubicacion: (json['ubicacion'] != null)
          ? Referencia(
              key: json['ubicacion']['key'],
              nombre: json['ubicacion']['nombre'])
          : null,
      subUbicacion: (json['subUbicacion'] != null)
          ? Referencia(
              key: json['subUbicacion']['key'],
              nombre: json['subUbicacion']['nombre'])
          : null,
      articulo: json['articulo'],
      cantidad: json['cantidad'],
      creacion: json['creacion'],
      descripcion: json['descripcion'],
      disponibilidad: json['disponibilidad'],
      estado: json['estado'],
      etiqueta: json['etiqueta'],
      etiquetaId: json['etiquetaId'],
      fechaEtiqueta: json['fechaEtiqueta'],
      fechaModif: json['fechaModif'],
      file: json['file'],
      imagen: json['imagen'],
      key: json['key'],
      modificaciones: json['modificaciones'],
      nombre: json['nombre'],
      nombreImagen: json['nombreImagen'],
      observaciones: json['observaciones'],
      valor: json['valor'],
      serie: json['serie'],
    );
  }
  Map toJson() {
    return {
      'sede': (sede != null) ? sede.toJson() : null,
      'ubicacion': (ubicacion != null) ? ubicacion.toJson() : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion.toJson() : null,
      'articulo': articulo,
      'cantidad': cantidad,
      'creacion': creacion,
      'descripcion': descripcion,
      'disponibilidad': disponibilidad,
      'estado': estado,
      'etiqueta': etiqueta,
      'etiquetaId': etiquetaId,
      'fechaEtiqueta': fechaEtiqueta,
      'fechaModif': fechaModif,
      'file': file,
      'imagen': imagen,
      'key': key,
      'modificaciones': modificaciones,
      'nombre': nombre,
      'nombreImagen': nombreImagen,
      'observaciones': observaciones,
      'valor': valor,
      'serie': serie,
    };
  }
}

class Resumen {
  String key;
  String nombre;
  int cantidad;
  int buenos;
  int malos;
  int regulares;
  List<Articulo> articulos;

  Resumen({
    this.key,
    this.nombre,
    this.cantidad,
    this.buenos,
    this.malos,
    this.regulares,
    this.articulos,
  });
  factory Resumen.fromFirebase(Map<dynamic, dynamic> json) {
    return Resumen(
      key: json['key'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      buenos: json['buenos'],
      malos: json['malos'],
      regulares: json['regulares'],
    );
  }
  Map toJson() => {
        'key': key,
        'nombre': nombre,
        'cantidad': cantidad,
        'buenos': buenos,
        'malos': malos,
        'regulares': regulares,
      };
}

class SubUbicacion extends Locations {
  List<Resumen> articulos;
}

class Ubicacion extends Locations {
  List<SubUbicacion> subUbicaciones;
}

class Sede extends Locations {
  List<Ubicacion> ubicaciones;
  Sede({
    location,
    sede,
    ubicacion,
    subUbicacion,
    key,
    nombre,
    cantidad,
    descripcion,
    imagen,
    file,
    modificacion,
    buenos,
    malos,
    regulares,
    this.ubicaciones,
  });
  factory Sede.fromFirebase(Map<String, dynamic> json) {
    var location;
    var sede;
    var ubicacion;
    var subUbicacion;
    if ((json['sede'] == null) &&
        (json['ubicacion'] == null) &&
        (json['subUbicacion'] == null)) {
      location = 'sede';
      sede = Referencia.fromFirebase(json);
    } else if ((json['sede'] != null) &&
        (json['ubicacion'] == null) &&
        (json['subUbicacion'] == null)) {
      location = 'ubicacion';
      sede = Referencia(key: json['sede']);
      ubicacion = Referencia.fromFirebase(json);
    } else if ((json['sede'] != null) &&
        (json['ubicacion'] != null) &&
        (json['subUbicacion'] == null)) {
      location = 'subUbicacion';
      sede = Referencia(key: json['sede']);
      ubicacion = Referencia(key: json['ubicacion']);
      subUbicacion = Referencia.fromFirebase(json);
    }

    return Sede(
      location: location,
      sede: sede,
      ubicacion: ubicacion,
      subUbicacion: subUbicacion,
      key: json['key'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      file: json['file'],
      modificacion: json['modificacion'],
      buenos: (json['Buenos'] != null)
          ? json['Buenos']
          : (json['Bueno'] != null)
              ? json['Bueno']
              : 0,
      malos: (json['Malos'] != null)
          ? json['Malos']
          : (json['Malo'] != null)
              ? json['Malo']
              : 0,
      regulares: (json['Regulares'] != null)
          ? json['Regulares']
          : (json['Regular'] != null)
              ? json['Regular']
              : 0,
    );
  }
  Map toJson() {
    return {
      'location': location,
      'sede': (sede != null) ? sede.toJson() : null,
      'ubicacion': (ubicacion != null) ? ubicacion.toJson() : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion.toJson() : null,
      'key': key,
      'nombre': nombre,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'imagen': imagen,
      'file': file,
      'modificacion': modificacion,
      'buenos': buenos,
      'malos': malos,
      'regulares': regulares,
    };
  }
}

class LocalDataBase2 extends Locations {
  List<Sede> sedes;
  LocalDataBase2({
    location,
    sede,
    ubicacion,
    subUbicacion,
    key,
    nombre,
    cantidad,
    descripcion,
    imagen,
    file,
    modificacion,
    buenos,
    malos,
    regulares,
    this.sedes,
  });
  factory LocalDataBase2.fromLocal(Map<String, dynamic> json) {
    var sedes = [];
    if (json['sedes'] != null) {
      json['sedes'].forEach((sede) {
        sedes.add(Sede.fromFirebase(sede));
      });
    }
    return LocalDataBase2(
      location: json['location'],
      sede: (json['sede'] != null)
          ? Referencia(key: json['sede']['key'], nombre: json['sede']['nombre'])
          : null,
      ubicacion: (json['ubicacion'] != null)
          ? Referencia(
              key: json['ubicacion']['key'],
              nombre: json['ubicacion']['nombre'])
          : null,
      subUbicacion: (json['subUbicacion'] != null)
          ? Referencia(
              key: json['subUbicacion']['key'],
              nombre: json['subUbicacion']['nombre'])
          : null,
      key: json['key'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      file: json['file'],
      modificacion: json['modificacion'],
      buenos: json['buenos'],
      malos: json['malos'],
      regulares: json['regulares'],
      sedes: sedes,
    );
  }
  Map toJson() {
    var sedesx = [];
    if (sedes != null) {
      sedes.forEach((sede) {
        sedesx.add(Sede.fromFirebase(sede.toJson()).toJson());
      });
    }
    return {
      'location': location,
      'sedes': (sedes != null) ? sedesx : null,
      'sede': (sede != null) ? sede.toJson() : null,
      'ubicacion': (ubicacion != null) ? ubicacion.toJson() : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion.toJson() : null,
      'key': key,
      'nombre': nombre,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'imagen': imagen,
      'file': file,
      'modificacion': modificacion,
      'buenos': buenos,
      'malos': malos,
      'regulares': regulares,
    };
  }
}

class LocalDataBase extends Locations {}

/* class Sede {
  String nivelEstudios;
  String nombre;
  String codigo;
  String siguiente;
  bool siguienteTest = false;
  Sede({
    this.nivelEstudios,
    this.nombre,
    this.codigo,
    this.siguiente,
    this.siguienteTest: false,
  });
  Map toJson() => {
        'nivelEstudios': nivelEstudios,
        'codigo': codigo,
        'nombre': nombre,
        'siguiente': siguiente,
        'siguienteTest': siguienteTest,
      };
} */
