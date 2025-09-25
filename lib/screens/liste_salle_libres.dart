import 'package:flutter/material.dart';
import 'package:school_app/model/salle.dart' show Salle;
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';
import 'package:school_app/theme/my_styles.dart';
import 'package:flutter/material.dart';

class ListSalles extends StatefulWidget {
  const ListSalles({super.key});

  @override
  State<ListSalles> createState() => _ListSallesState();
}

class _ListSallesState extends State<ListSalles> {
  late Future<List<Salle>> futureSalles;

  @override
  void initState() {
    super.initState();
    futureSalles = AllServices().getAllSalles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Liste des Salles",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: myblueColor,
        elevation: 4,
      ),
      body: FutureBuilder<List<Salle>>(
        future: futureSalles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(myblueColor),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Chargement des salles...",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: myredColor),
                  SizedBox(height: 16),
                  Text(
                    "Erreur de chargement",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: myredColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Erreur: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        futureSalles = AllServices().getAllSalles();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text("Réessayer"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myblueColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.meeting_room_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Aucune salle trouvée",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Les salles apparaîtront ici une fois ajoutées",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          } else {
            List<Salle> salles = snapshot.data!;
            final filteredSalles = salles
                .where((salle) => salle.occupee == false)
                .toList();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec compteur
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Salles disponibles (${salles.length})",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              futureSalles = AllServices().getAllSalles();
                            });
                          },
                          icon: Icon(Icons.refresh),
                          tooltip: "Actualiser",
                        ),
                      ],
                    ),
                  ),

                  // Liste des cartes
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSalles.length,
                      itemBuilder: (context, index) {
                        final salle = filteredSalles[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // En-tête de la carte avec nom de salle
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        salle.nomSalle ?? "Salle Non Définie",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: myblueColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "Salle ${index + 1}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: myblueColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12),

                                // Section équipements
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.build_circle_outlined,
                                      size: 20,
                                      color: Colors.grey.shade600,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Équipements",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            salle.equipements?.isNotEmpty ==
                                                    true
                                                ? salle.equipements!
                                                : "Aucun équipement disponible",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  salle
                                                          .equipements
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade500,
                                              fontStyle:
                                                  salle
                                                          .equipements
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? FontStyle.normal
                                                  : FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Ligne séparatrice optionnelle
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
        },
      ),
    );
  }
}
