import 'package:flutter/material.dart';
import 'package:local/models/movimiento_model.dart';

class UpdateScreen extends StatefulWidget {
  final MovimientoModel movimiento;
  final ValueChanged<MovimientoModel> onUpdate;

  const UpdateScreen({
    super.key,
    required this.movimiento,
    required this.onUpdate,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController descripcionController;
  late TextEditingController valorController;

  late String tipo;
  late DateTime fecha;

  @override
  void initState() {
    super.initState();

    tipo = widget.movimiento.tipo;

    descripcionController = TextEditingController(
      text: widget.movimiento.descripcion,
    );

    valorController = TextEditingController(
      text: widget.movimiento.valor.toString(),
    );

    fecha = DateTime.parse(widget.movimiento.fecha);
  }

  @override
  void dispose() {
    descripcionController.dispose();
    valorController.dispose();
    super.dispose();
  }

  Future<void> seleccionarFecha() async {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (nuevaFecha != null) {
      setState(() {
        fecha = nuevaFecha;
      });
    }
  }

  void actualizar() {
    if (!_formKey.currentState!.validate()) return;

    final movimientoActualizado = MovimientoModel(
      id: widget.movimiento.id,
      tipo: tipo,
      descripcion: descripcionController.text.trim(),
      valor: double.parse(valorController.text),
      fecha: fecha.toIso8601String(),
    );

    widget.onUpdate(movimientoActualizado);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              "Editar movimiento",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: tipo,
              decoration: const InputDecoration(
                labelText: "Tipo",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "ingreso", child: Text("Ingreso")),
                DropdownMenuItem(value: "gasto", child: Text("Gasto")),
              ],
              onChanged: (value) {
                setState(() {
                  tipo = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Ingrese una descripción";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Valor",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingrese un valor";
                }

                if (double.tryParse(value) == null) {
                  return "Valor inválido";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: seleccionarFecha,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Fecha",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                child: Text("${fecha.day}/${fecha.month}/${fecha.year}"),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: actualizar,
              icon: const Icon(Icons.save),
              label: const Text("Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
