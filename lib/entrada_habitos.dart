import 'package:flutter/material.dart';

class EntradaHabitosPage extends StatefulWidget {
  final String? habito; // Para editar nome do hábito existente
  final String? descricao; // Para editar a descrição do hábito existente
  final String? frequencia; // Para editar a frequência do hábito existente

  const EntradaHabitosPage({
    Key? key,
    this.habito,
    this.descricao,
    this.frequencia,
  }) : super(key: key);

  @override
  State<EntradaHabitosPage> createState() => _EntradaHabitosPageState();
}

class _EntradaHabitosPageState extends State<EntradaHabitosPage> {
  late final TextEditingController _habitoController;
  late final TextEditingController _descricaoController;
  String? _frequenciaSelecionada = "Todos os dias";
  final List<String> _diasSelecionados = [];

  @override
  void initState() {
    super.initState();
    _habitoController = TextEditingController(text: widget.habito);
    _descricaoController = TextEditingController(text: widget.descricao);
    _frequenciaSelecionada = widget.frequencia ?? "Todos os dias";
  }

  @override
  void dispose() {
    _habitoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  int _getLimiteDiasPorFrequencia(String frequencia) {
  switch (frequencia) {
    case "1 vez na semana": return 1;
    case "3 vezes na semana": return 3;
    case "Todos os dias": return 7;
    default: return 7;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.habito == null ? "Criar Hábito" : "Editar Hábito"),
      //   backgroundColor: Colors.white,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nome do hábito
            TextField(
              controller: _habitoController,
              decoration: const InputDecoration(
                labelText: "Nome do hábito",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Descrição do hábito
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: "Descrição do hábito",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Frequência do hábito
            DropdownButtonFormField<String>(
              value: _frequenciaSelecionada,
              decoration: const InputDecoration(
                labelText: "Frequência",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Todos os dias", child: Text("Todos os dias")),
                DropdownMenuItem(value: "1 vez na semana", child: Text("1 vez na semana")),
                DropdownMenuItem(value: "3 vezes na semana", child: Text("3 vezes na semana")),
              ],
              onChanged: (value) {
                setState(() {
                  _frequenciaSelecionada = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Seleção de dias (apenas para frequências semanais)
            if (_frequenciaSelecionada == "1 vez na semana" ||
                _frequenciaSelecionada == "3 vezes na semana") ...[
              const Text(
                "Selecione os dias:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: ["dom", "seg", "ter", "qua", "qui", "sex", "sáb"]
                    .map((dia) => ChoiceChip(
                          label: Text(dia),
                          selected: _diasSelecionados.contains(dia),
                          onSelected: (selected) {
                            setState(() {
                               int maxDiasPermitidos = _getLimiteDiasPorFrequencia(_frequenciaSelecionada!);

                                if (selected) {
                                  if (_diasSelecionados.length < maxDiasPermitidos) {
                                    _diasSelecionados.add(dia);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Você só pode escolher $maxDiasPermitidos dia(s).")),
                                    );
                                  }
                                } else {
                                  _diasSelecionados.remove(dia);
                                }
                            });
                          },
                        )).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.black,
                child: Icon(Icons.close, color: Colors.white),
              ),
              FloatingActionButton(
                onPressed: () {
                  final novoHabito = _habitoController.text.trim();
                  final descricao = _descricaoController.text.trim();

                  if (novoHabito.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Por favor, insira um nome para o hábito."),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'habito': novoHabito,
                    'descricao': descricao,
                    'frequencia': _frequenciaSelecionada,
                    'dias': _frequenciaSelecionada != "Todos os dias" ? _diasSelecionados : null,
                  });
                }, 
                backgroundColor: Colors.black,
                child: Icon(Icons.check, color: Colors.white),
              ),
            ],
          ),
      ),
    );
  }
}
