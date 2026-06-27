import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_materi_screen.dart';

class ManageMateriScreen extends StatefulWidget {
  final String? kategoriTerpilih;
  
  const ManageMateriScreen({Key? key, this.kategoriTerpilih}) : super(key: key);

  @override
  State<ManageMateriScreen> createState() => _ManageMateriScreenState();
}

class _ManageMateriScreenState extends State<ManageMateriScreen> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.kategoriTerpilih ?? 'HTML';
  }

  // 🛠️ FUNGSI BARU: Normalisasi kategori agar selalu pas menembak dokumen Kapital (HTML, CSS, JS)
  String _getNormalizedDocId() {
    String kategori = selectedCategory.trim().toUpperCase();
    if (kategori == "JAVASCRIPT") {
      return "JS";
    }
    return kategori;
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan ID dokumen yang sudah bersih dan terstandardisasi
    final String docId = _getNormalizedDocId();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Daftar Materi $selectedCategory', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18)),
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
                    MaterialPageRoute(
                      builder: (context) => EditMateriScreen(category: selectedCategory),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
                label: const Text("Tambah Materi Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              // 🛠️ PERBAIKAN 1: Pipa Stream sekarang mendengarkan dokumen Kapital yang Valid (docId)
              stream: FirebaseFirestore.instance.collection('courses').doc(docId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF6B11D6)));
                }
                
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildEmptyState();
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final List<dynamic> daftarBab = data?['daftar_bab'] ?? [];

                if (daftarBab.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: daftarBab.length,
                  itemBuilder: (context, index) {
                    final bab = daftarBab[index] as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          '${index + 1}. ${bab['judul_bab']}', 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 14)
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, color: Color(0xFF6B11D6), size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditMateriScreen(
                                      category: selectedCategory,
                                      materiData: bab,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                              onPressed: () => _deleteMateri(bab),
                            ),
                          ],
                        ),
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
          Icon(Icons.menu_book_rounded, size: 60, color: Color(0xFFCBD5E1)),
          SizedBox(height: 16),
          Text('Belum ada materi', style: TextStyle(color: Color(0xFF64748B), fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _deleteMateri(Map<String, dynamic> materiData) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Materi'),
        content: const Text('Apakah kamu yakin ingin menghapus materi ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final String docId = _getNormalizedDocId();
      
      // 🛠️ PERBAIKAN 2: Proses hapus array juga diarahkan ke dokumen Kapital (docId)
      await FirebaseFirestore.instance.collection('courses').doc(docId).update({
        'daftar_bab': FieldValue.arrayRemove([materiData])
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Materi berhasil dihapus!')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus materi: $e')));
    }
  }
}