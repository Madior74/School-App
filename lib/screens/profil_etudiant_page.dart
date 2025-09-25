// lib/pages/profil_page.dart

import 'package:flutter/material.dart';
import 'package:school_app/model/profil_etudiant.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';

class ProfilEtudiantPage extends StatefulWidget {
  const ProfilEtudiantPage({super.key});

  @override
  State<ProfilEtudiantPage> createState() => _ProfilEtudiantPageState();
}

class _ProfilEtudiantPageState extends State<ProfilEtudiantPage> {
  late Future<ProfilEtudiant> _futureProfil;
  final AllServices _service = AllServices();

  @override
  void initState() {
    super.initState();
    _futureProfil = _service.getProfilEtudiant();
  }

  Future<void> _refreshProfil() async {
    setState(() {
      _futureProfil = _service.getProfilEtudiant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: myblueColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProfil,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: FutureBuilder<ProfilEtudiant>(
        future: _futureProfil,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildProfilContent(snapshot.data!);
          } else {
            return const Center(child: Text('Aucune donnée'));
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger le profil',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _refreshProfil,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilContent(ProfilEtudiant profil) {
    return RefreshIndicator(
      onRefresh: _refreshProfil,
      child: CustomScrollView(
        slivers: [
          // En-tête avec photo et nom
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Fond flou ou couleur
                  Container(color: Colors.grey[300]),
                  // Image de profil
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: profil.imagePath.startsWith('http')
                            ? NetworkImage(profil.imagePath)
                            : AssetImage(profil.imagePath) as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                '${profil.prenom} ${profil.nom}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),

          // Corps du profil
          SliverList(
            delegate: SliverChildListDelegate([
              _buildInfoCard(context, profil),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ProfilEtudiant profil) {
    final List<InfoRow> infos = [
      InfoRow(icon: Icons.email, label: 'Email', value: profil.email),
      InfoRow(icon: Icons.phone, label: 'Téléphone', value: profil.telephone),
      InfoRow(
        icon: Icons.cake,
        label: 'Date de naissance',
        value: profil.dateDeNaissance,
      ),
      InfoRow(
        icon: Icons.location_on,
        label: 'Pays de naissance',
        value: profil.paysDeNaissance,
      ),
      InfoRow(icon: Icons.home, label: 'Adresse', value: profil.adresse),
      InfoRow(icon: Icons.credit_card, label: 'CNI', value: profil.cni),
      InfoRow(icon: Icons.school, label: 'INE', value: profil.ine),
      InfoRow(icon: Icons.person, label: 'Sexe', value: profil.sexe),
      InfoRow(icon: Icons.lock, label: 'Rôle', value: profil.role),
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations personnelles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            for (var info in infos)
              _buildInfoTile(info.icon, info.label, info.value),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow {
  final IconData icon;
  final String label;
  final String value;

  InfoRow({required this.icon, required this.label, required this.value});
}
