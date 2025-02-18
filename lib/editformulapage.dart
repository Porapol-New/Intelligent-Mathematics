import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditFormulaPage extends StatefulWidget {
  final String formulaId;
  final String initialFormulaName;
  final String initialFormulaDescription;

  EditFormulaPage({
    required this.formulaId,
    required this.initialFormulaName,
    required this.initialFormulaDescription,
  });

  @override
  _EditFormulaPageState createState() => _EditFormulaPageState();
}

class _EditFormulaPageState extends State<EditFormulaPage> {
  final _formKey = GlobalKey<FormState>();
  late String formulaName;
  late String formulaDescription;

  @override
  void initState() {
    super.initState();
    formulaName = widget.initialFormulaName;
    formulaDescription = widget.initialFormulaDescription;
  }

  // ฟังก์ชันอัปเดตสูตรใน Firestore
  void _updateFormula() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        // อัปเดตสูตรใน Firestore
        await FirebaseFirestore.instance
            .collection('formulas')
            .doc(widget.formulaId)
            .update({
          'name': formulaName,
          'expression': formulaDescription,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Formula Updated')));
        Navigator.pop(context); // กลับไปหน้าก่อนหน้าเมื่ออัปเดตเสร็จ
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating formula: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Formula')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: formulaName,
                decoration: InputDecoration(labelText: 'Formula Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a formula name';
                  }
                  return null;
                },
                onSaved: (value) {
                  formulaName = value ?? '';
                },
              ),
              TextFormField(
                initialValue: formulaDescription,
                decoration: InputDecoration(labelText: 'Formula Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  formulaDescription = value ?? '';
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateFormula,
                child: Text('Update Formula'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
