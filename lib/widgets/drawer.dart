import 'package:flutter/material.dart';
import 'package:school_app/screens/home_screen.dart';
import 'package:school_app/screens/login_screen.dart';
import 'package:school_app/services/auth_service.dart';
import 'dart:io' show exit;

import 'package:school_app/theme/color.dart';

class MyDrawer extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const MyDrawer({super.key, this.userData});

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  late String? nomEtudiant;
  late String? emailEtudiant;
  late String? prenomEtudiant;

  @override
  void initState() {
    super.initState();
    nomEtudiant = widget.userData?['nom'];
    emailEtudiant = widget.userData?['email'];
    prenomEtudiant = widget.userData?['prenom'];
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;
    print("User data in drawer build: $userData");

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // 👤 Header avec avatar & infos utilisateur
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [myblueColor, myredColor]),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 15,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage:
                          userData != null && userData['photoUrl'] != null
                          ? NetworkImage(userData['photoUrl'])
                          : null,
                      child: (userData == null || userData['photoUrl'] == null)
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white.withOpacity(0.8),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '${prenomEtudiant ?? ""} ${nomEtudiant ?? ""}'
                            .trim()
                            .isEmpty
                        ? "Utilisateur anonyme"
                        : '${prenomEtudiant ?? ""} ${nomEtudiant ?? ""}'.trim(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    emailEtudiant ?? "email.non.fourni@exemple.com",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // 📋 Menu principal
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.home_outlined,
                  title: 'Accueil',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(userData: userData!),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                // _buildMenuItem(
                //   icon: Icons.groups_2_outlined,
                //   title: 'Groupes',
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const GroupesScreen(),
                //       ),
                //     );
                //   },
                // ),
                // const Divider(height: 1, indent: 20, endIndent: 20),
                // _buildMenuItem(
                //   icon: Icons.monitor_heart_outlined,
                //   title: 'Suivi du groupe',
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const CotisationsScreen(),
                //       ),
                //     );
                //   },
                // ),
                // const Divider(height: 1, indent: 20, endIndent: 20),
                _buildMenuItem(
                  icon: Icons.logout_outlined,
                  title: "Déconnexion",
                  textColor: Colors.red.shade700,
                  iconColor: Colors.red.shade700,
                  onTap: () async {
                    await AuthService().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildMenuItem(
                  icon: Icons.exit_to_app_outlined,
                  title: 'Quitter l’application',
                  textColor: Colors.grey.shade700,
                  iconColor: Colors.grey.shade700,
                  onTap: () {
                    exit(0);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? myblueColor, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade100,
      splashColor: myblueColor.withOpacity(0.2),
      focusColor: myblueColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
