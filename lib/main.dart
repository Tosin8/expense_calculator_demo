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
      body:
            ScopedModelDescendant<ExpenseListModel>(
              builder: (context, child, expenses) {
                return ListView.separated(
                  itemCount: expenses.items == null ? 1: expenses.items.length + 1, 
                  itemBuilder: (context, index) {if (index == 0) {
                    return ListTile(
                      title: Text('Total expenses: '+expenses.totalExpense.toString(), 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
                      ),
                    ); 
                  } 
                  else {
                    index = index - 1;
                    return Dismissible (
                      key: Key(expenses.items[index].id.toString()),
                      onDismissed: (direction) {
                        expenses.delete(expenses.items[index]);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item with id, ' + expenses.items[index].id.toString() + ' is dismissed'))); 
                      }, 
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormPage(id: expenses.items[index].id),
                              expenses: expenses,
                            ))); 
           
                      
                        }, 
                        leading: const Icon(Icons.monetization_on), 
                        trailing: const Icon(Icons.keyboard_arrow_right), 
                        title: T
                      )
                            
                    