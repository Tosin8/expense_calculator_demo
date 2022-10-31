import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'ExpenseListModel.dart';

void main() {
  final expenses = ExpenseListModel();

  runApp(
    ScopedModel<ExpenseListModel>(
      model: expenses,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoped Model Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scoped Model Demo'),
        ),
        body: ScopedModelDescendant<ExpenseListModel>(
          builder: (context, child, expenses) {
            return ListView.separated(
              itemCount: expenses.items == null ? 1 : expenses.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text(
                      'Total expenses: ' + expenses.totalExpense.toString(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  index = index - 1;
                  return Dismissible(
                      key: Key(expenses.items[index].id.toString()),
                      onDismissed: (direction) {
                        expenses.delete(expenses.items[index]);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Item with id, ' +
                                expenses.items[index].id.toString() +
                                ' is dismissed')));
                      },
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormPage(
                                          id: expenses.items[index].id,
                                          expenses: expenses,
                                        )));
                          },
                          leading: const Icon(Icons.monetization_on),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          title: Text(
                            expenses.items[index].category +
                                ':' +
                                expenses.items[index].amount.toString() +
                                '\nspent on ' +
                                expenses.items[index].formattedDate,
                            style: const TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )));
                }
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          },
        ),
        floatingActionButton: ScopedModelDescendant<ExpenseListModel>(
            builder: (context, child, expenses) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScopedModelDescendant<ExpenseListModel>(
                              builder: (context, child, expenses) {
                            return FormPage(
                              id: 0,
                              expenses: expenses,
                            );
                          })));
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        }));
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.id, required this.expenses}) : super(key: key);

  final int id;
  final ExpenseListModel expenses;

  @override
  State<FormPage> createState() => _FormPageState(id: id, expenses: expenses);
}

class _FormPageState extends State<FormPage> {
   _FormPageState({required this.id, required this.expenses});

  final int id;
  final ExpenseListModel expenses;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  double _amount;
  DateTime _date;
  String _category;

  void _submit() {
    final form = formKey.currentState;

    if (form?.validate()) {
      form?.save();

      if (id == 0) {
        expenses.add(Expense(0, _amount, _date, _category));
      } else {
        expenses.update(Expense(id, _amount, _date, _category));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Enter expense details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child : Form(
          key: formKey,
           child: 
           Column(
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 22), decoration: const InputDecoration(
                  icon: Icon(Icons.monetization_on), 
                  labelText: 'Amount',
                  labelStyle: TextStyle(fontSize: 18)),
                
              validator: (val)
{
  Pattern pattern = r'^[1-9]\d*(\.\d+)?$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(val)) {
    return 'Enter valid amount';
  } else {
    return null;
  }
}        , 
initalValue: 
id == 0? '' : expenses.byId(id).amount.toString(), onSaved: (val) => _amount = double.parse(val), ),
              TextFormField(
                style: const TextStyle(fontSize: 22), decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: 'Enter Date',
                  labelText: 'Date',
                  
                  labelStyle: TextStyle(fontSize: 18), ),

                
              validator: (val) {
                Pattern pattern = r'^((?:19|20)\d\d)[-/.](0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])$';

                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(val)) {
                  return 'Enter valid date';
                } else {
                  return null;
                }, 
                onSaved: (val) => _date = DateTime.parse(val),
                initialValue: id == 0 ? '' : expenses.byId(id).formattedDate, keyboardType: TextInputType.datetime, 
                ),
              TextFormField(
                style: const TextStyle(fontSize: 22), decoration: const InputDecoration(
                  icon: Icon(Icons.category),
                  labelText: 'Category',
                  labelStyle: TextStyle(fontSize: 18),
                  onSaved: (val) => _category = val,
                  initalValue: id == 0 ? '' : expenses.byId(id).category.toString(),
                ), 
                RaisedButton(
                  child: const Text('Submit'),
                  onPressed: _submit,
                ),
            ], 
           )))); 
              }
           
  
}
