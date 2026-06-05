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

  bool isLoading = false;

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

  Future<void> actualizar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final movimientoActualizado = MovimientoModel(
      id: widget.movimiento.id,
      tipo: tipo,
      descripcion: descripcionController.text.trim(),
      valor: double.parse(valorController.text),
      fecha: fecha.toIso8601String(),
    );

    widget.onUpdate(movimientoActualizado);

    if (!mounted) return;

    Navigator.pop(context);
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
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
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
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    size: 42,
                    color: Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Editar Movimiento",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Actualiza la información del movimiento",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
              ),

              const SizedBox(height: 30),

              DropdownButtonFormField<String>(
                value: tipo,
                decoration: InputDecoration(
                  labelText: 'Tipo de movimiento',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    tipo == 'ingreso'
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: tipo == 'ingreso' ? Colors.green : Colors.red,
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
                    tipo = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: descripcionController,
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
                controller: valorController,
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
                onTap: seleccionarFecha,
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
                          '${fecha.day}/${fecha.month}/${fecha.year}',
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
                      colors: [Colors.orange, Color(0xffFFB74D)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : actualizar,
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
                        : const Icon(
                            Icons.save_as_rounded,
                            color: Colors.white,
                          ),
                    label: Text(
                      isLoading ? 'Actualizando...' : 'Actualizar Movimiento',
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
