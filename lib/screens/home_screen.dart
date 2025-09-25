import 'package:flutter/material.dart';
import 'package:school_app/dto/evaluation_dto.dart';
import 'package:school_app/dto/note_dto.dart';
import 'package:school_app/dto/seance_dto.dart';
import 'package:school_app/dto/semestre_dto.dart';
import 'package:school_app/model/assiduite_dto.dart';
import 'package:school_app/model/salle.dart';
import 'package:school_app/screens/list_semestre.dart';
import 'package:school_app/screens/liste_absences.dart';
import 'package:school_app/screens/liste_evaluation.dart';
import 'package:school_app/screens/liste_notes.dart';
import 'package:school_app/screens/liste_salle_libres.dart';
import 'package:school_app/screens/liste_seance.dart';
import 'package:school_app/screens/profil_etudiant_page.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/widgets/drawer.dart';
import 'package:school_app/widgets/home_widgets/stat_card.dart';
import 'package:school_app/widgets/home_widgets/feature_card.dart';
import 'package:school_app/theme/color.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AssiduiteDto> listeAssiduite = [];
  List<Salle> listeSalles = [];
  List<EvaluationDTO> listeEvaluation = [];
  List<SeanceDTO> listeSeances = [];
  List<SemestreDTO> listeSemestres = [];
  List<NoteDTO> listeNotes = [];
  bool _isRefreshing = false;

  // List<AssiduiteDto> listeAssiduite = [];
  @override
  void initState() {
    super.initState();
    // Single entry point to load data on start
    _refresh(showFeedback: false);
  }

  Future<void> _refresh({bool showFeedback = true}) async {
    if (_isRefreshing) return; // prevent concurrent refreshes
    setState(() {
      _isRefreshing = true;
    });

    try {
      await Future.wait([
        _fetchAssiduites(),
        _fetchSalles(),
        _fetchEvaluation(),
        _fetchSemestres(),
        _fetchSeances(),
        _fetchNotes(),
      ]);
      if (mounted && showFeedback) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Données actualisées')));
      }
    } catch (e) {
      if (mounted && showFeedback) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'actualisation: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _fetchAssiduites() async {
    try {
      List<AssiduiteDto> data = await AllServices().getAllMyAssiduite();
      if (!mounted) return;
      setState(() {
        listeAssiduite = data;
      });
    } catch (e) {
      debugPrint("Erreur lors de la recupération des Assiduité :$e");
    }
  }

  Future<void> _fetchSalles() async {
    try {
      List<Salle> data = await AllServices().getAllSalles();
      if (!mounted) return;
      setState(() {
        listeSalles = data;
      });
    } catch (e) {
      debugPrint("Erreur lors de la recupération des Salles :$e");
    }
  }

  Future<void> _fetchEvaluation() async {
    try {
      List<EvaluationDTO> data = await AllServices().getAllEvaluations();
      if (!mounted) return;
      setState(() {
        listeEvaluation = data;
      });
    } catch (e) {
      debugPrint("Erreur lors de la recupération des evaluations :$e");
    }
  }

  Future<void> _fetchSemestres() async {
    try {
      List<SemestreDTO> data = await AllServices().getAllMySemestres();
      if (!mounted) return;
      setState(() {
        listeSemestres = data;
      });
    } catch (e) {
      debugPrint("Erreur lors de la recupération des Semestres :$e");
    }
  }

  Future<void> _fetchSeances() async {
    try {
      List<SeanceDTO> data = await AllServices().getAllSeances();
      if (!mounted) return;
      setState(() {
        listeSeances = data;
      });
    } catch (e) {
      debugPrint("Erreur lors de la recupération des Seances :$e");
    }
  }

  Future<void> _fetchNotes() async {
    try {
      List<NoteDTO> data = await AllServices().getAllNotes();
      if (!mounted) return;
      setState(() {
        listeNotes = data;
      });
    } catch (e) {
      debugPrint("Erreur lors de la recupération des Notes :$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        backgroundColor: myblueColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _refresh();
              },
            ),
        ],
      ),
      // drawer: MyDrawer(userData: widget.userData),
      body: RefreshIndicator(
        onRefresh: () => _refresh(showFeedback: false),
        color: myblueColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section de bienvenue
              _buildWelcomeSection(),
              const SizedBox(height: 24),

              // Section des statistiques rapides
              _buildStatsSection(),
              const SizedBox(height: 24),

              // Section des fonctionnalités principales
              _buildFeaturesSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [myblueColor, myblueColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: myblueColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour,',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.userData['prenom']} ${widget.userData['nom']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.userData['email']}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    int nbNotes = listeNotes.length;
    int nbSalleLibre = 0;
    for (var s in listeSalles) {
      if (s.occupee == false) {
        nbSalleLibre += 1;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Prochains Cours',
                value: listeSeances.length.toString(),
                icon: Icons.school,
                color: mathColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SeancesPage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Evaluations',
                value: listeEvaluation.length.toString(),
                icon: Icons.assignment,
                color: warningColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EvaluationsPage()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Notes',
                value: nbNotes.toString(),
                icon: Icons.grade,
                color: successColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotesPage()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Absences',
                value: listeAssiduite.length.toString(),
                icon: Icons.event_busy,
                color: dangerColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MesAbsencesPage()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Salles Libres',
                value: nbSalleLibre.toString(),
                icon: Icons.meeting_room,
                color: dangerColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListSalles()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fonctionnalités',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            FeatureCard(
              title: 'Mes Modules',
              icon: Icons.book,
              color: mathColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListSemestre()),
                );
              },
            ),
            FeatureCard(
              title: 'Devoirs',
              icon: Icons.assignment,
              color: warningColor,
              onTap: () => _navigateToAssignments(),
            ),

            FeatureCard(
              title: 'Bibliothèque',
              icon: Icons.library_books,
              color: computerColor,
              onTap: () => _navigateToLibrary(),
            ),
            FeatureCard(
              title: 'Profil',
              icon: Icons.person,
              color: physicsColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilEtudiantPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToAssignments() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité en cours de développement')),
    );
  }

  void _navigateToLibrary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité en cours de développement')),
    );
  }

  void _navigateToMessages() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité en cours de développement')),
    );
  }
}
