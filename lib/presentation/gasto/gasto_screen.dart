import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local/constants/gasto_constants.dart';
import 'package:local/models/movimiento_model.dart';
import 'package:local/presentation/gasto/add_screen.dart';
import 'package:local/presentation/gasto/update_screen.dart';
import 'package:local/presentation/shared/widgets/custom_snackbar.dart';
import 'package:local/repository/movimiento_repository.dart';

class GastoScreen extends StatefulWidget {
  const GastoScreen({super.key});

  @override
  State<GastoScreen> createState() => _GastoScreenState();
}

class _GastoScreenState extends State<GastoScreen> {
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

  Future<void> deleteData(BuildContext context, int id) async {
    final int delete = await repository.deleteMovimiento(id);

    CustomSnackBar.show(
      context,
      message: delete > 0 ? message['delete']! : message['error']!,
      type: delete > 0 ? SnackType.success : SnackType.error,
    );
    getData();
  }

  Future<void> updateData(MovimientoModel movi) async {
    final update = await repository.updateMovimiento(movi);
    CustomSnackBar.show(
      context,
      message: update > 0 ? message['delete']! : message['error']!,
      type: update > 0 ? SnackType.success : SnackType.error,
    );
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,

            isScrollControlled: true,
            builder: (BuildContext context) {
              return AddScreen(update: getData);
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: SpinKitDancingSquare(color: Colors.blue, size: 50))
          : ListView.builder(
              itemCount: movimientos.length,
              itemBuilder: (context, i) {
                MovimientoModel mov = movimientos[i];
                return Slidable(
                  key: ValueKey(mov.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 1,
                        onPressed: (_) => {
                          showModalBottomSheet<void>(
                            context: context,

                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return UpdateScreen(
                                movimiento: mov,
                                onUpdate: updateData,
                              );
                            },
                          ),
                        },
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Update',
                      ),
                      SlidableAction(
                        onPressed: (_) => deleteData(context, mov.id!),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(mov.valor.toString()),
                    subtitle: Text(mov.descripcion),
                    leading: Icon(
                      mov.tipo == 'gasto'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
