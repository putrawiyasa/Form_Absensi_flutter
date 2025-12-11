import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AbsensiPage(),
    );
  }
}

class AbsensiPage extends StatefulWidget {
  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController nimC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController deviceC = TextEditingController();

  String? selectedJK; // dropdown value

  Future<void> submitAbsensi() async {
    final url = Uri.parse(
      "https://absensi-mobile.primakarauniversity.ac.id/api/absensi",
    );

    final body = {
      "nama": namaC.text,
      "kelas": kelasC.text,
      "nim": nimC.text,
      "jenis_kelamin": selectedJK ?? "",
      "device": deviceC.text,
    };

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (data["status"] == "success") {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Sukses"),
            content: Text(data["message"]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(data["message"].toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Terjadi kesalahan: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Form Absensi",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    buildField("Nama", namaC),
                    buildField("NIM", nimC),
                    buildField("Kelas", kelasC),

                    // 🔽 Dropdown Jenis Kelamin
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: DropdownButtonFormField<String>(
                        value: selectedJK,
                        decoration: InputDecoration(
                          labelText: "Jenis Kelamin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Laki-Laki",
                            child: Text("Laki-Laki"),
                          ),
                          DropdownMenuItem(
                            value: "Perempuan",
                            child: Text("Perempuan"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedJK = value;
                          });
                        },
                      ),
                    ),

                    buildField("Device", deviceC),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: submitAbsensi,
                      child: const Text("Submit Absensi"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
