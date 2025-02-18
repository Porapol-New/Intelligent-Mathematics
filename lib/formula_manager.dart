import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_loginsystems_1/addformulapage.dart';
import 'package:flutter_loginsystems_1/editformulapage.dart';

class FormulaManager extends StatefulWidget {
  @override
  _FormulaManagerState createState() => _FormulaManagerState();
}

class _FormulaManagerState extends State<FormulaManager> {
  final CollectionReference formulasRef =
      FirebaseFirestore.instance.collection('formulas');
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('จัดการสูตรคำนวณ')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ค้นหาสูตร',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: formulasRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final formulas = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toLowerCase();
                  return name.contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: formulas.length,
                  itemBuilder: (context, index) {
                    final data = formulas[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? 'ไม่ระบุชื่อ'),
                      subtitle: Text(data['expression'] ?? 'ไม่มีสูตร'),
                      onTap: () => _showCalculateDialog(
                          data['name'], data['expression']),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFormulaPage(
                                  formulaId:
                                      formulas[index].id, // ส่ง formulaId
                                  initialFormulaName:
                                      data['name'] ?? '', // ส่งชื่อสูตร
                                  initialFormulaDescription:
                                      data['expression'] ??
                                          '', // ส่งคำอธิบายสูตร
                                ),
                              ),
                            );
                          } else if (value == 'delete') {
                            formulasRef.doc(formulas[index].id).delete();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'edit', child: Text('แก้ไข')),
                          PopupMenuItem(value: 'delete', child: Text('ลบ')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFormulaPage()),
          );
        },
      ),
    );
  }

  void _showCalculateDialog(String formulaName, String formulaExpression) {
    // ค้นหาตัวแปรในสูตร เช่น "radius", "height"
    RegExp regex = RegExp(r'[a-zA-Z]+');
    Iterable<Match> matches = regex.allMatches(formulaExpression);
    List<String> variables = matches.map((m) => m.group(0)!).toSet().toList();

    // สร้าง TextEditingController สำหรับแต่ละตัวแปร
    Map<String, TextEditingController> controllers = {
      for (var varName in variables) varName: TextEditingController()
    };

    double result = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // ฟังก์ชันคำนวณ
            void _calculate() {
              String evaluatedExpression = formulaExpression;
              try {
                // แทนค่าตัวแปรด้วยค่าที่ผู้ใช้กรอก
                controllers.forEach((key, controller) {
                  evaluatedExpression =
                      evaluatedExpression.replaceAll(key, controller.text);
                });
                // ใช้ math_expressions คำนวณผลลัพธ์
                Parser p = Parser();
                Expression exp = p.parse(evaluatedExpression);
                ContextModel cm = ContextModel();
                double calcResult = exp.evaluate(EvaluationType.REAL, cm);

                // อัปเดตค่า result ภายใน Dialog
                setStateDialog(() {
                  result = calcResult;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('คำนวณไม่ได้: ${e.toString()}')),
                );
              }
            }

            return AlertDialog(
              title: Text(formulaName),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // สร้าง TextField สำหรับแต่ละตัวแปร
                    for (var varName in variables)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextField(
                          controller: controllers[varName],
                          decoration:
                              InputDecoration(labelText: 'ป้อนค่า $varName'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculate,
                      child: Text('คำนวณ'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ผลลัพธ์: $result',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ปิด'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
