import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AbsensiApp());
}

class AbsensiApp extends StatelessWidget {
  const AbsensiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Absensi",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const AbsensiPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final TextEditingController namaC = TextEditingController();
  final TextEditingController nimC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController deviceC = TextEditingController();

  String jenisKelamin = "Laki-Laki";

  Future<void> kirimAbsensi() async {
    final url = Uri.parse(
        "https://absensi-mobile.primakarauniversity.ac.id/api/absensi");

    final body = {
      "nama": namaC.text,
      "nim": nimC.text,
      "kelas": kelasC.text,
      "jenis_kelamin": jenisKelamin,
      "device": deviceC.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Berhasil"),
            content: Text(data["message"].toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        String pesanError = "";

        if (data["message"] is Map) {
          data["message"].forEach((key, value) {
            pesanError += "$key : ${value[0]}\n";
          });
        } else {
          pesanError = data["message"].toString();
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Gagal"),
            content: Text(pesanError),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
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
            ),
          ],
        ),
      );
    }
  }

  InputDecoration modernInput() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget fieldWithLabel(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Absensi"),
        centerTitle: true,
        elevation: 0,
      ),

      // ---------------------------------------------------
      // BUTTON SUBMIT DILETAKKAN DI BAWAH DENGAN safeArea
      // ---------------------------------------------------
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: kirimAbsensi,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Kirim Absensi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Isi Data Absensi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  fieldWithLabel(
                    "Nama Lengkap",
                    TextField(
                      controller: namaC,
                      decoration: modernInput(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  fieldWithLabel(
                    "NIM",
                    TextField(
                      controller: nimC,
                      decoration: modernInput(),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 15),

                  fieldWithLabel(
                    "Kelas",
                    TextField(
                      controller: kelasC,
                      decoration: modernInput(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  fieldWithLabel(
                    "Jenis Kelamin",
                    DropdownButtonFormField<String>(
                      value: jenisKelamin,
                      decoration: modernInput(),
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
                        setState(() => jenisKelamin = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  fieldWithLabel(
                    "Device",
                    TextField(
                      controller: deviceC,
                      decoration: modernInput(),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
