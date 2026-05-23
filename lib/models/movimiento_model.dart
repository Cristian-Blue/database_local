class MovimientoModel {
  int? id;
  String tipo; // ingreso o gasto
  String descripcion;
  double valor;
  String fecha;

  MovimientoModel({
    this.id,
    required this.tipo,
    required this.descripcion,
    required this.valor,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'descripcion': descripcion,
      'valor': valor,
      'fecha': fecha,
    };
  }

  factory MovimientoModel.fromMap(Map<String, dynamic> map) {
    return MovimientoModel(
      id: map['id'],
      tipo: map['tipo'],
      descripcion: map['descripcion'],
      valor: map['valor'],
      fecha: map['fecha'],
    );
  }
}
