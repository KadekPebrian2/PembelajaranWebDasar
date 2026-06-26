import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_quiz_screen.dart';

class ManageQuizScreen extends StatefulWidget {
  final String? kategoriTerpilih;

  const ManageQuizScreen({Key? key, this.kategoriTerpilih}) : super(key: key);

  @override
  State<ManageQuizScreen> createState() => _ManageQuizScreenState();
}

class _ManageQuizScreenState extends State<ManageQuizScreen> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.kategoriTerpilih ?? 'HTML';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Paket Kuis $selectedCategory', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B11D6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditQuizScreen(category: selectedCategory)),
                  );
                },
                icon: const Icon(Icons.add_box_rounded, color: Colors.white),
                label: const Text("Tambah Paket Kuis Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('kuis').doc(selectedCategory).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF6B11D6)));
                }
                
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildEmptyState();
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final List<dynamic> daftarPaket = data?['daftar_paket'] ?? []; 

                if (daftarPaket.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: daftarPaket.length,
                  itemBuilder: (context, index) {
                    final paket = daftarPaket[index] as Map<String, dynamic>;
                    final List pertanyaan = paket['pertanyaan'] ?? [];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.quiz_rounded, color: Color(0xFF9333EA)),
                        ),
                        title: Text(
                          paket['judul_paket'] ?? 'Paket Kuis', 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 15)
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('${pertanyaan.length} Soal', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditQuizScreen(
                                category: selectedCategory,
                                paketData: paket,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.quiz_outlined, size: 60, color: Color(0xFFCBD5E1)),
          SizedBox(height: 16),
          Text('Belum ada paket kuis', style: TextStyle(color: Color(0xFF64748B), fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}