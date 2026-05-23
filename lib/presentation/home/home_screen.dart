import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local/models/movimiento_model.dart';
import 'package:local/repository/movimiento_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovimientoRepository repository = MovimientoRepository();
  List<MovimientoModel> movimientos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    isLoading = true;
    setState(() {});
    movimientos = await repository.getMovimientos();
    isLoading = false;
    setState(() {});
  }

  Future insertMovimiento(BuildContext context) async {
    isLoading = true;
    setState(() {});
    final movimiento = MovimientoModel(
      tipo: 'gasto',
      descripcion: 'Compra comida',
      valor: 50000,
      fecha: DateTime.now().toString(),
    );
    int insert = await repository.insertMovimiento(movimiento);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Movimiento insertado: $insert')));
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => insertMovimiento(context),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(color: Colors.blue, size: 50),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: movimientos.length,
              itemBuilder: (context, index) {
                final movimiento = movimientos[index];
                return ListTile(
                  title: Text(movimiento.descripcion),
                  subtitle: Text(movimiento.fecha),
                );
              },
            ),
    );
  }
}
