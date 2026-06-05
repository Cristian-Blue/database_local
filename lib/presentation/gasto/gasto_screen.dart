import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local/constants/gasto_constants.dart';
import 'package:local/models/movimiento_model.dart';
import 'package:local/presentation/gasto/add_screen.dart';
import 'package:local/presentation/gasto/update_screen.dart';
import 'package:local/presentation/shared/widgets/custom_snackbar.dart';
import 'package:local/presentation/shared/widgets/drawer_widget.dart';
import 'package:local/repository/movimiento_repository.dart';

class GastoScreen extends StatefulWidget {
  static const name = 'gasto';

  const GastoScreen({super.key});

  @override
  State<GastoScreen> createState() => _GastoScreenState();
}

class _GastoScreenState extends State<GastoScreen> {
  final MovimientoRepository repository = MovimientoRepository();

  List<MovimientoModel> movimientos = [];
  Map<String, double> resumen = {'ingresos': 0, 'gastos': 0, 'balance': 0};

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
    resumen = await repository.getResumenFinanciero();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteData(BuildContext context, int id) async {
    final delete = await repository.deleteMovimiento(id);

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
      message: update > 0 ? "Movimiento actualizado" : message['error']!,
      type: update > 0 ? SnackType.success : SnackType.error,
    );

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(title: const Text('Gasto')),
      backgroundColor: const Color(0xffF4F6FA),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Movimiento", style: TextStyle(color: Colors.white)),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddScreen(update: getData),
          );
        },
      ),

      body: isLoading
          ? const Center(
              child: SpinKitDancingSquare(color: Colors.indigo, size: 50),
            )
          : RefreshIndicator(
              onRefresh: getData,
              child: Column(
                children: [
                  _buildHeader(),

                  Expanded(
                    child: movimientos.isEmpty
                        ? const Center(
                            child: Text(
                              'No existen movimientos',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 100,
                            ),
                            itemCount: movimientos.length,
                            itemBuilder: (context, i) {
                              final mov = movimientos[i];

                              return Slidable(
                                key: ValueKey(mov.id),

                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (_) => UpdateScreen(
                                            movimiento: mov,
                                            onUpdate: updateData,
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Editar',
                                    ),
                                    SlidableAction(
                                      onPressed: (_) =>
                                          deleteData(context, mov.id!),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Eliminar',
                                    ),
                                  ],
                                ),

                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.all(16),

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.05),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),

                                  child: Row(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: mov.tipo == 'gasto'
                                              ? Colors.red.shade50
                                              : Colors.green.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          mov.tipo == 'gasto'
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          color: mov.tipo == 'gasto'
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),

                                      const SizedBox(width: 15),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mov.descripcion,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              mov.tipo.toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        mov.tipo == 'gasto'
                                            ? "- \$${mov.valor}"
                                            : "+ \$${mov.valor}",
                                        style: TextStyle(
                                          color: mov.tipo == 'gasto'
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Balance Total",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 10),

          Text(
            "\$ ${resumen['balance']?.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: _resumeCard(
                  title: "Ingresos",
                  value: resumen['ingresos']!,
                  color: Colors.green,
                  icon: Icons.arrow_upward,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _resumeCard(
                  title: "Gastos",
                  value: resumen['gastos']!,
                  color: Colors.red,
                  icon: Icons.arrow_downward,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resumeCard({
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),

          const SizedBox(height: 8),

          Text(title, style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 4),

          Text(
            "\$ ${value.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
