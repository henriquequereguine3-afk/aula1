import 'package:flutter/material.dart';

class Receita {
  final String descricao;
  final double valor;
  final DateTime data;

  Receita({required this.descricao, required this.valor, required this.data});
}

class Despesas {
  final String descricao;
  final double valor;
  final DateTime data;

  Despesas({required this.descricao, required this.valor, required this.data});
}

class Investimentos {
  final String descricao;
  final double valor;
  final DateTime data;

  Investimentos({
    required this.descricao,
    required this.valor,
    required this.data,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Receita> _receitas = [
    Receita(descricao: 'Salário mensal', valor: 4500.00, data: DateTime.now()),
    Receita(
      descricao: 'Projeto Freelance',
      valor: 1500.00,
      data: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  final List<Despesas> _despesas = [
    Despesas(descricao: 'Aluguel', valor: 1500.00, data: DateTime.now()),
    Despesas(descricao: 'Luz', valor: 250.00, data: DateTime.now()),
    Despesas(
      descricao: 'Almoço',
      valor: 35.00,
      data: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Despesas(descricao: 'Internet', valor: 100.00, data: DateTime.now()),
  ];
  final List<Investimentos> _investimentos = [
    Investimentos(
      descricao: 'Renda Fixa',
      valor: 1500.00,
      data: DateTime.now(),
    ),
    Investimentos(descricao: 'Ações', valor: 250.00, data: DateTime.now()),
    Investimentos(
      descricao: 'Fundos Imobiliários',
      valor: 35.00,
      data: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  String _formatCurrency(double value) {
    String fixed = value.toStringAsFixed(2);
    List<String> parts = fixed.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(
      reg,
      (Match match) => '${match[1]}.',
    );

    return 'R\$ $integerPart,$decimalPart';
  }

  String _formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  void _showAddReceitaDialog() {
    final formKey = GlobalKey<FormState>();
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Receita'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex: Salário, Venda de notebook',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor (R\$)',
                    hintText: 'Ex: 1500.00',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return 'Insira um valor numérico válido maior que 0';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                descricaoController.dispose();
                valorController.dispose();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final descricao = descricaoController.text;
                  final valor = double.parse(
                    valorController.text.replaceAll(',', '.'),
                  );
                  setState(() {
                    _receitas.add(
                      Receita(
                        descricao: descricao,
                        valor: valor,
                        data: DateTime.now(),
                      ),
                    );
                  });
                  descricaoController.dispose();
                  valorController.dispose();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.arrow_upward, color: Colors.green),
                text: 'Receitas',
              ),
              Tab(
                icon: Icon(Icons.arrow_downward, color: Colors.red),
                text: 'Despesas',
              ),
              Tab(
                icon: Icon(Icons.pie_chart, color: Colors.amber),
                text: 'Investimentos',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tela de Receitas
            Scaffold(
              body: _receitas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 80,
                            color: Colors.green.shade200,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma receita registrada',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _receitas.length,
                      itemBuilder: (context, index) {
                        final receita = _receitas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(
                              receita.descricao,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(_formatDate(receita.data)),
                            trailing: Text(
                              _formatCurrency(receita.valor),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: _showAddReceitaDialog,
                backgroundColor: Colors.green,
                tooltip: 'Adicionar Receita',
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            // Tela de Despesas
            Scaffold(
              body: _despesas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 80,
                            color: Colors.green.shade200,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma despesa registrada',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _despesas.length,
                      itemBuilder: (context, index) {
                        final despesa = _despesas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              ),
                            ),
                            title: Text(
                              despesa.descricao,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(_formatDate(despesa.data)),
                            trailing: Text(
                              _formatCurrency(despesa.valor),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: _showAddReceitaDialog,
                backgroundColor: Colors.green,
                tooltip: 'Adicionar Despesas',
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            // Tela de Investimentos
            Scaffold(
              body: _investimentos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 80,
                            color: Colors.green.shade200,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma investimento registrado',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _investimentos.length,
                      itemBuilder: (context, index) {
                        final investimento = _investimentos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(
                              investimento.descricao,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(_formatDate(investimento.data)),
                            trailing: Text(
                              _formatCurrency(investimento.valor),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: _showAddReceitaDialog,
                backgroundColor: Colors.green,
                tooltip: 'Adicionar Investimentos',
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
