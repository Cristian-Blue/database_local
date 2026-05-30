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

  void _guardar(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final movimiento = {
      "tipo": _tipo,
      "descripcion": _descripcionController.text.trim(),
      "valor": double.parse(_valorController.text),
      "fecha": _fecha.toIso8601String(),
    };

    final insert = await repository.insertMovimiento(
      MovimientoModel.fromMap(movimiento),
    );
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
      heightFactor: 0.8,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  "Insertar movimiento",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _tipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
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

                const SizedBox(height: 16),

                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese una descripción';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un valor';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Valor inválido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: _seleccionarFecha,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    child: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _guardar(context),
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
