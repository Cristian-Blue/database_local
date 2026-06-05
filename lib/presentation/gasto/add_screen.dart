import 'package:flutter/material.dart';
import 'package:local/constants/gasto_constants.dart';
import 'package:local/models/movimiento_model.dart';
import 'package:local/presentation/shared/widgets/custom_snackbar.dart';
import 'package:local/repository/movimiento_repository.dart';

class AddScreen extends StatefulWidget {
  final Function update;

  const AddScreen({super.key, required this.update});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final MovimientoRepository repository = MovimientoRepository();

  final _formKey = GlobalKey<FormState>();

  final _descripcionController = TextEditingController();
  final _valorController = TextEditingController();

  String _tipo = 'ingreso';
  DateTime _fecha = DateTime.now();

  bool isLoading = false;

  Future<void> _seleccionarFecha() async {
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fecha = fechaSeleccionada;
      });
    }
  }

  Future<void> _guardar(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final movimiento = {
      "tipo": _tipo,
      "descripcion": _descripcionController.text.trim(),
      "valor": double.parse(_valorController.text),
      "fecha": _fecha.toIso8601String(),
    };

    final insert = await repository.insertMovimiento(
      MovimientoModel.fromMap(movimiento),
    );

    if (!mounted) return;

    CustomSnackBar.show(
      context,
      message: insert > 0 ? message['insert']! : message['error']!,
      type: insert > 0 ? SnackType.success : SnackType.error,
    );

    widget.update();

    Navigator.pop(context, movimiento);
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: .92,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffF4F6FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 40,
                    color: Colors.indigo,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Nuevo Movimiento",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Registra un ingreso o un gasto",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
              ),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: InputDecoration(
                  labelText: 'Tipo de movimiento',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    _tipo == 'ingreso'
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: _tipo == 'ingreso' ? Colors.green : Colors.red,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                  DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipo = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: const Icon(Icons.description_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese una descripción';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _valorController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Valor',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un valor';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Valor inválido';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Debe ser mayor a cero';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _seleccionarFecha,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.indigo,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          '${_fecha.day}/${_fecha.month}/${_fecha.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                height: 58,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Colors.indigo, Color(0xff5C6BC0)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : () => _guardar(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded, color: Colors.white),
                    label: Text(
                      isLoading ? 'Guardando...' : 'Guardar Movimiento',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
