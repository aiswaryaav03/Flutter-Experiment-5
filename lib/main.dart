import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Budget Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  const BudgetHomePage({super.key});

  @override
  State<BudgetHomePage> createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();

  double? _balance;
  String _status = '';

  void _calculateBudget() {
    if (_formKey.currentState!.validate()) {
      final income = double.parse(_incomeController.text);
      final expenses = double.parse(_expenseController.text);

      setState(() {
        _balance = income - expenses;

        if (_balance! > 0) {
          _status = 'Budget Surplus';
        } else if (_balance! < 0) {
          _status = 'Budget Deficit';
        } else {
          _status = 'Budget Balanced';
        }
      });
    }
  }

  void _clearForm() {
    _incomeController.clear();
    _expenseController.clear();

    setState(() {
      _balance = null;
      _status = '';
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Budget Calculator'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 60,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Manage Your Monthly Budget',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _incomeController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Monthly Income (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter your income';
                        }

                        final income = double.tryParse(value);

                        if (income == null || income < 0) {
                          return 'Enter a valid income';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _expenseController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Monthly Expenses (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money_off),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter your expenses';
                        }

                        final expenses =
                            double.tryParse(value);

                        if (expenses == null || expenses < 0) {
                          return 'Enter valid expenses';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _calculateBudget,
                            child: const Text('Calculate'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearForm,
                            child: const Text('Clear'),
                          ),
                        ),
                      ],
                    ),

                    if (_balance != null) ...[
                      const SizedBox(height: 24),

                      const Text(
                        'Remaining Balance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '₹${_balance!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _balance! >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _status,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _balance! > 0
                              ? Colors.green
                              : _balance! < 0
                                  ? Colors.red
                                  : Colors.blue,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}