import 'package:flutter/material.dart';
import '../../core/database_helper.dart';
import '../../models/weblearn_models.dart';
import 'edit_materi_screen.dart';

class ManageMateriScreen extends StatefulWidget {
  final String judulKategori;

  const ManageMateriScreen({Key? key, required this.judulKategori}) : super(key: key);

  @override
  State<ManageMateriScreen> createState() => _ManageMateriScreenState();

}

class _ManageMateriScreenState extends State<ManageMateriScreen> {
  List<Modul> daftarSubMateri = [];
  Kategori? kategori;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMateri();
  }

  Future<void> _loadMateri() async {
    setState(() => isLoading = true);
    kategori = await DatabaseHelper.instance.getKategoriByName(widget.judulKategori);
    if (kategori != null) {
      daftarSubMateri = await DatabaseHelper.instance.getModulByKategori(kategori!.id!);
    } else {
      daftarSubMateri = [];
    }
    setState(() => isLoading = false);
  }

  Future<void> _deleteMateri(Modul modul) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Materi'),
        content: const Text('Apakah Anda yakin ingin menghapus materi ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteKuisByModul(modul.id!);
      await DatabaseHelper.instance.deleteKontenByModul(modul.id!);
      await DatabaseHelper.instance.deleteModul(modul.id!);
      await _loadMateri();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Materi berhasil dihapus.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Daftar Materi ${widget.judulKategori}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B11D6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: kategori == null
                    ? null
                    : () async {
                        final created = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditMateriScreen(
                              kategoriId: kategori!.id!,
                              judulKategori: widget.judulKategori,
                            ),
                          ),
                        );
                        if (created == true) {
                          await _loadMateri();
                        }
                      },
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 20),
                label: const Text('Tambah Materi Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : daftarSubMateri.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            kategori == null
                                ? 'Kategori tidak ditemukan.'
                                : 'Belum ada materi di kategori ${widget.judulKategori}. Silakan tambahkan materi baru.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: daftarSubMateri.length,
                        itemBuilder: (context, index) {
                          final materi = daftarSubMateri[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              title: Text(
                                materi.judul,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 14),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: Color(0xFF6B11D6), size: 20),
                                    onPressed: () async {
                                      final konten = await DatabaseHelper.instance.getKontenByModul(materi.id!);
                                      if (!mounted) return;
                                      final navigator = Navigator.of(context);
                                      final updated = await navigator.push<bool>(
                                        MaterialPageRoute(
                                          builder: (_) => EditMateriScreen(
                                            kategoriId: kategori!.id!,
                                            judulKategori: widget.judulKategori,
                                            modul: materi,
                                            konten: konten,
                                          ),
                                        ),
                                      );
                                      if (!mounted) return;
                                      if (updated == true) {
                                        await _loadMateri();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                    onPressed: () => _deleteMateri(materi),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
