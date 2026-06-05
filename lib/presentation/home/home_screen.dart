import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local/models/movimiento_model.dart';
import 'package:local/presentation/shared/widgets/drawer_widget.dart';
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

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    movimientos = await repository.getMovimientos();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> insertMovimiento(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final movimiento = MovimientoModel(
      tipo: 'gasto',
      descripcion: 'Compra comida',
      valor: 50000,
      fecha: DateTime.now().toString(),
    );

    final insert = await repository.insertMovimiento(movimiento);

    await getData();

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Movimiento insertado: $insert')));
  }

  Future<void> eliminarMovimiento(int id) async {
    await repository.deleteMovimiento(id);
  }

  Future<void> actualizarMovimiento(MovimientoModel movimiento) async {
    movimiento.descripcion = 'Editado';
    movimiento.tipo = 'ingreso';
    print(movimiento.toMap());
    await repository.updateMovimiento(movimiento);
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => insertMovimiento(context),
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(color: Colors.blue, size: 50),
            )
          : ListView.builder(
              itemCount: movimientos.length,

              itemBuilder: (context, index) {
                final movimiento = movimientos[index];

                return Dismissible(
                  key: ValueKey(movimiento.id),

                  // 👉 izquierda -> derecha
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),

                  // 👈 derecha -> izquierda
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  confirmDismiss: (direction) async {
                    // 👉 EDITAR
                    if (direction == DismissDirection.startToEnd) {
                      print('----------->');
                      await actualizarMovimiento(movimiento);

                      if (!context.mounted) return false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Editar ${movimiento.descripcion}"),
                        ),
                      );

                      // Cancela el dismiss
                      return false;
                    }

                    // 👈 ELIMINAR
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Eliminar"),
                          content: Text("¿Eliminar ${movimiento.descripcion}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancelar"),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text("Eliminar"),
                            ),
                          ],
                        ),
                      );
                    }

                    return false;
                  },

                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final eliminado = movimiento;

                      // Eliminar visualmente PRIMERO
                      setState(() {
                        movimientos.removeAt(index);
                      });

                      // Luego BD
                      await eliminarMovimiento(eliminado.id!);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${eliminado.descripcion} eliminado"),
                        ),
                      );
                    }
                  },

                  child: ListTile(
                    title: Text(movimiento.descripcion),

                    subtitle: Text(movimiento.fecha),

                    trailing: Text("\$ ${movimiento.valor}"),
                  ),
                );
              },
            ),
    );
  }
}
