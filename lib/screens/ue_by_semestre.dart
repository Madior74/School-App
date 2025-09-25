import 'package:flutter/material.dart';
import 'package:school_app/dto/semestre_dto.dart';
import 'package:school_app/model/model_ue.dart';
import 'package:school_app/model/module.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';
import 'modules_by_ue.dart';

class UeBySemestre extends StatefulWidget {
  final SemestreDTO semestre;
  const UeBySemestre({super.key, required this.semestre});

  @override
  State<UeBySemestre> createState() => _UeBySemestreState();
}

class _UeBySemestreState extends State<UeBySemestre> {
  late Future<List<UE>> futureUes;

  final List<int> credits = [4, 5, 6];

  @override
  void initState() {
    super.initState();
    futureUes = AllServices().getUesBySemestre(widget.semestre.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: myblueColor,
        centerTitle: true,
        title: Text(
          " ${widget.semestre.nomSemestre} Liste des UES",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: FutureBuilder<List<UE>>(
        future: futureUes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune UE trouvée"));
          } else {
            List<UE> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                UE ue = items[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModulesByUEPage(ueId: ue.id!, ueNom: ue.nomUE),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.indigo.shade700,
                              child: Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ue.nomUE,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.code,
                                        size: 18,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        ue.codeUE,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.amber.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${ue.getTotalCredits().toStringAsFixed(1)} crédits',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.amber.shade800,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
