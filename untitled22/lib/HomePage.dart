import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled22/desing.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, int> makroDegerler = {
    'Protein': 0,
    'Karbonhidrat': 0,
    'Yağ': 0,
  };

  Map<String, int> almamizGerekenDegerler = {
    'Protein': 100,
    'Karbonhidrat': 200,
    'Yağ': 50,
  };

  String selectedMakro = 'Protein';
  TextEditingController degerController = TextEditingController();

  bool get tumDegerlerGirildiMi =>
      makroDegerler.values.every((value) => value > 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Tracker',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 22,
            backgroundColor: Colors.white54,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: makroDegerler.entries.map((entry) {
                  return BesinDeger(makro: entry.key, deger: entry.value);
                }).toList(),
              ),
              const SizedBox(height: 30),
              if (tumDegerlerGirildiMi) ...[
                Text(
                  "Günlük Alınan Makro Değerler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            dataMap: makroDegerler.map(
                                  (key, value) => MapEntry(key, value.toDouble()),
                            ),
                            chartType: ChartType.disc,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 32,
                            chartRadius: MediaQuery.of(context).size.width / 3,
                            colorList: [Colors.blue, Colors.red, Colors.green],
                            legendOptions: LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: true,
                              showChartValuesOutside: true,
                              decimalPlaces: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMakroRow("Protein", makroDegerler['Protein']!, Colors.blue),
                        _buildMakroRow("Karbonhidrat", makroDegerler['Karbonhidrat']!, Colors.red),
                        _buildMakroRow("Yağ", makroDegerler['Yağ']!, Colors.green),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Günlük Alınması Gereken Makro Değerler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            dataMap: almamizGerekenDegerler.map(
                                  (key, value) => MapEntry(key, value.toDouble()),
                            ),
                            chartType: ChartType.disc,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 32,
                            chartRadius: MediaQuery.of(context).size.width / 3,
                            colorList: [Colors.orange, Colors.purple, Colors.yellow],
                            legendOptions: LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: true,
                              showChartValuesOutside: true,
                              decimalPlaces: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMakroRow("Protein", almamizGerekenDegerler['Protein']!, Colors.orange),
                        _buildMakroRow("Karbonhidrat", almamizGerekenDegerler['Karbonhidrat']!, Colors.purple),
                        _buildMakroRow("Yağ", almamizGerekenDegerler['Yağ']!, Colors.yellow),
                      ],
                    ),
                  ],
                ),
              ] else
                Center(
                  child: Text(
                    "Lütfen tüm makro değerlerinizi giriniz.",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    title: const Text("Makro Giriniz"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: selectedMakro,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedMakro = newValue;
                              });
                            }
                          },
                          items: ['Protein', 'Karbonhidrat', 'Yağ']
                              .map<DropdownMenuItem<String>>((String oge) {
                            return DropdownMenuItem<String>(
                              value: oge,
                              child: Text(oge),
                            );
                          }).toList(),
                        ),
                        TextField(
                          controller: degerController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Değer giriniz",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (degerController.text.isNotEmpty) {
                            setState(() {
                              makroDegerler[selectedMakro] =
                                  int.parse(degerController.text);
                            });
                          }
                          degerController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Ekle"),
                      ),
                      TextButton(
                        onPressed: () {
                          degerController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("İptal"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.purple),
      ),
    );
  }

  Widget _buildMakroRow(String name, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          "$name: $value g",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
