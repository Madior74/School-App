import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' as _httpClient;
import 'package:school_app/config/config.dart';
import 'package:school_app/dto/evaluation_dto.dart';
import 'package:school_app/dto/note_dto.dart';
import 'package:school_app/dto/seance_dto.dart';
import 'package:school_app/dto/semestre_dto.dart';
import 'package:school_app/model/assiduite_dto.dart';
import 'package:school_app/model/model_ue.dart';
import 'package:school_app/model/module.dart';
import 'package:school_app/model/profil_etudiant.dart';
import 'package:school_app/model/salle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllServices {
  final http.Client _httplient = http.Client();
  final String baseUrl = AppConfig.baseUrl;

  //Assiduites
  Future<List<AssiduiteDto>> getAllMyAssiduite() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await _httplient.get(
        Uri.parse('$baseUrl/assiduites/mes-absences'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Iterable jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return List<AssiduiteDto>.from(
          jsonResponse.map((asd) => AssiduiteDto.fromJson(asd)),
        );
      } else {
        throw Exception(
          "Erreur lors de la recupération des Assiduité :${response.body}",
        );
      }
    } catch (e) {
      print("Erreur lors de la recupération des Assiduité :${e}");

      throw Exception("Erreur lors de la recupération des Assiduité ");
    }
  }

  //Par Module
  Future<List<AssiduiteDto>> getAssiduiteeParSeance(int moduleId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      final response = await _httplient.get(
        Uri.parse('$baseUrl/assiduite/module/$moduleId'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => AssiduiteDto.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
  //Evaluation

  Future<List<EvaluationDTO>> getAllEvaluations() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/evaluations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((e) => EvaluationDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load evaluations');
    }
  }

  //Salles
  Future<List<Salle>> getAllSalles() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/salles/statut-now'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(
          utf8.decode(response.bodyBytes),
        );
        return jsonResponse
            .map((salle) => Salle.fromJson(salle as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des salles');
      }
    } catch (e) {
      print("Erreur lors de la requête : $e");
      throw Exception('Erreur lors de la récupération des salles');
    }
  }

  //Seances absentes
  Future<List<SeanceDTO>> getAllAbsentes() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/assiduites/mes-absences'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SeanceDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des absences');
    }
  }

  Future<List<SemestreDTO>> getAllMySemestres() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/semestres'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SemestreDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des semestres');
    }
  }
  //UEs by Semestre

  Future<List<UE>> getUesBySemestre(int semestreId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/semestre/$semestreId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((ue) => UE.fromJson(ue)).toList();
    } else {
      throw Exception('Failed to load ues');
    }
  }

  //Notes
  Future<List<NoteDTO>> getAllNotes() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/mes-notes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body notes: ${response.body}'); // Debug line

    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => NoteDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la recupération des Notes');
    }
  }

  //Seances
  Future<List<SeanceDTO>> getAllSeances() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/seances'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response body: ${response.body}'); // Debug line

    if (response.statusCode == 200 || response.statusCode == 201) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => SeanceDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors de la recupération des Seances');
    }
  }

  //Module By Ue
  //get  Modules by UE
  Future<List<Module>> getModulesByUE(int ueId) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/ue/$ueId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      // Vérifier si "data" est null ou vide
      final data = jsonResponse['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) {
        throw Exception('Aucun module trouvé pour cette UE');
      }

      return data.map((module) => Module.fromJson(module)).toList();
    } else if (response.statusCode == 404) {
      // Gérer explicitement le cas 404
      throw Exception('Aucun module trouvé pour cette UE');
    } else {
      // Gérer les autres erreurs HTTP
      throw Exception('Failed to load modules: ${response.statusCode}');
    }
  }

  //mon profil
  Future<ProfilEtudiant> getProfilEtudiant() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/mon-profil'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return ProfilEtudiant.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Profil non trouvé');
    } else {
      throw Exception('Erreur du serveur (${response.statusCode})');
    }
  }
}
