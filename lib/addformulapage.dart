// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddFormulaPage extends StatefulWidget {
//   @override
//   _AddFormulaPageState createState() => _AddFormulaPageState();
// }

// class _AddFormulaPageState extends State<AddFormulaPage> {
//   final _formKey = GlobalKey<FormState>();
//   String formulaName = '';
//   String formulaDescription = '';

//   void _saveFormula() {
//     if (_formKey.currentState?.validate() ?? false) {
//       FirebaseFirestore.instance.collection('formulas').add({
//         'name': formulaName,
//         'expression': formulaDescription, // เก็บสูตร
//       }).then((_) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Formula Saved')));
//         Navigator.pop(context);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Formula')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Formula Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a formula name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   formulaName = value ?? '';
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Formula Expression'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a formula expression';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   formulaDescription = value ?? '';
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: _saveFormula,
//                 child: Text('Save Formula'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFormulaPage extends StatefulWidget {
  @override
  _AddFormulaPageState createState() => _AddFormulaPageState();
}

class _AddFormulaPageState extends State<AddFormulaPage> {
  final _formKey = GlobalKey<FormState>();
  String formulaName = '';
  String formulaExpression = '';

  void _saveFormula() {
    // ตรวจสอบการ validate ของฟอร์ม
    if (_formKey.currentState?.validate() ?? false) {
      // เรียก save() เพื่อให้ onSaved ของ TextFormField ทำงาน
      _formKey.currentState?.save();

      FirebaseFirestore.instance.collection('formulas').add({
        'name': formulaName,
        'expression': formulaExpression,
        // 'createdAt': FieldValue.serverTimestamp(), // ถ้าต้องการเก็บเวลา
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Formula Saved')),
        );
        Navigator.pop(context); // กลับไปหน้าก่อน
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Formula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ช่องกรอกชื่อสูตร
              TextFormField(
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
              // ช่องกรอกสมการสูตร
              TextFormField(
                decoration: InputDecoration(labelText: 'Formula Expression'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a formula expression';
                  }
                  return null;
                },
                onSaved: (value) {
                  formulaExpression = value ?? '';
                },
              ),
              SizedBox(height: 16),
              // ปุ่มบันทึกสูตร
              ElevatedButton(
                onPressed: _saveFormula,
                child: Text('Save Formula'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
