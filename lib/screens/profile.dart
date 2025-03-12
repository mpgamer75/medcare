import 'package:flutter/material.dart';
import 'package:medcare/constants/theme.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // Données factices de l'utilisateur
  final Map<String, dynamic> _userProfile = {
    'name': 'Sophie Martin',
    'email': 'sophie.martin@example.com',
    'phone': '06 12 34 56 78',
    'birthdate': '15/05/1985',
    'height': '168 cm',
    'weight': '65 kg',
    'bloodType': 'A+',
    'allergies': ['Arachide', 'Pénicilline'],
    'chronicDiseases': ['Asthme'],
    'emergencyContact': {
      'name': 'Pierre Martin',
      'relation': 'Époux',
      'phone': '06 87 65 43 21',
    },
    'doctorInfo': {
      'name': 'Dr. Bernard Dupont',
      'specialty': 'Médecin généraliste',
      'phone': '01 23 45 67 89',
      'address': '15 rue des Lilas, 75001 Paris',
    },
  };

  // Sections du profil à afficher
  final List<Map<String, dynamic>> _profileSections = [
    {
      'title': 'Informations personnelles',
      'icon': Icons.person,
      'color': Color(0xFF01A86C),
    },
    {
      'title': 'Informations médicales',
      'icon': Icons.medical_information,
      'color': Color(0xFF3DA5D9),
    },
    {
      'title': 'Contact d\'urgence',
      'icon': Icons.emergency,
      'color': Color(0xFFDD6B20),
    },
    {
      'title': 'Mon médecin traitant',
      'icon': Icons.medical_services,
      'color': Color(0xFF38B2AC),
    },
    {'title': 'Paramètres', 'icon': Icons.settings, 'color': Color(0xFF718096)},
    {
      'title': 'Aide et support',
      'icon': Icons.help,
      'color': Color(0xFF3182CE),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Fonction pour éditer le profil
              _showEditProfileDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête du profil
            _buildProfileHeader(),

            // Sections du profil
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children:
                    _profileSections.map((section) {
                      return _buildProfileSectionCard(
                        title: section['title'],
                        icon: section['icon'],
                        color: section['color'],
                        onTap: () {
                          // Fonction pour ouvrir la section correspondante
                          _openProfileSection(section['title']);
                        },
                      );
                    }).toList(),
              ),
            ),

            // Bouton de déconnexion
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: TextButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Déconnexion'),
                onPressed: () {
                  // Fonction pour se déconnecter
                  _showLogoutConfirmationDialog();
                },
                style: TextButton.styleFrom(foregroundColor: AppTheme.error),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Traitements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rendez-vous',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/traitements');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/rendezvous');
          } else if (index == 3) {
            // Déjà sur l'écran de profil
          }
        },
      ),
    );
  }

  // En-tête du profil avec avatar et informations principales
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              _getInitials(_userProfile['name']),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nom
          Text(
            _userProfile['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            _userProfile['email'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Carte d'information rapide
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickInfoItem(
                  icon: Icons.cake,
                  label: 'Âge',
                  value: '40 ans',
                ),
                _buildQuickInfoItem(
                  icon: Icons.height,
                  label: 'Taille',
                  value: _userProfile['height'],
                ),
                _buildQuickInfoItem(
                  icon: Icons.monitor_weight,
                  label: 'Poids',
                  value: _userProfile['weight'],
                ),
                _buildQuickInfoItem(
                  icon: Icons.bloodtype,
                  label: 'Groupe',
                  value: _userProfile['bloodType'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Élément d'information rapide pour l'en-tête
  Widget _buildQuickInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  // Carte de section de profil
  Widget _buildProfileSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Obtenir les initiales à partir du nom
  String _getInitials(String name) {
    final nameParts = name.split(' ');
    String initials = '';

    if (nameParts.length >= 2) {
      initials = nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      initials = nameParts[0][0];
    }

    return initials.toUpperCase();
  }

  // Ouvrir une section du profil
  void _openProfileSection(String sectionTitle) {
    // Implémentation future pour afficher les détails de chaque section
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppTheme.textSecondary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      sectionTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionContent(sectionTitle),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Contenu de chaque section
  Widget _buildSectionContent(String sectionTitle) {
    switch (sectionTitle) {
      case 'Informations personnelles':
        return Column(
          children: [
            _buildInfoItem(
              title: 'Nom complet',
              value: _userProfile['name'],
              icon: Icons.person,
            ),
            _buildInfoItem(
              title: 'Email',
              value: _userProfile['email'],
              icon: Icons.email,
            ),
            _buildInfoItem(
              title: 'Téléphone',
              value: _userProfile['phone'],
              icon: Icons.phone,
            ),
            _buildInfoItem(
              title: 'Date de naissance',
              value: _userProfile['birthdate'],
              icon: Icons.cake,
            ),
          ],
        );

      case 'Informations médicales':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(
              title: 'Taille',
              value: _userProfile['height'],
              icon: Icons.height,
            ),
            _buildInfoItem(
              title: 'Poids',
              value: _userProfile['weight'],
              icon: Icons.monitor_weight,
            ),
            _buildInfoItem(
              title: 'Groupe sanguin',
              value: _userProfile['bloodType'],
              icon: Icons.bloodtype,
            ),
            const SizedBox(height: 16),
            Text(
              'Allergies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (_userProfile['allergies'] as List<String>).map((allergy) {
                    return Chip(
                      backgroundColor: AppTheme.error.withOpacity(0.1),
                      label: Text(
                        allergy,
                        style: TextStyle(color: AppTheme.error),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Maladies chroniques',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  (_userProfile['chronicDiseases'] as List<String>).map((
                    disease,
                  ) {
                    return Chip(
                      backgroundColor: AppTheme.info.withOpacity(0.1),
                      label: Text(
                        disease,
                        style: TextStyle(color: AppTheme.info),
                      ),
                    );
                  }).toList(),
            ),
          ],
        );

      case 'Contact d\'urgence':
        final emergencyContact =
            _userProfile['emergencyContact'] as Map<String, dynamic>;
        return Column(
          children: [
            _buildInfoItem(
              title: 'Nom',
              value: emergencyContact['name'],
              icon: Icons.person,
            ),
            _buildInfoItem(
              title: 'Relation',
              value: emergencyContact['relation'],
              icon: Icons.family_restroom,
            ),
            _buildInfoItem(
              title: 'Téléphone',
              value: emergencyContact['phone'],
              icon: Icons.phone,
              isActionable: true,
              action: () {
                // Action pour appeler le contact d'urgence
              },
            ),
          ],
        );

      case 'Mon médecin traitant':
        final doctorInfo = _userProfile['doctorInfo'] as Map<String, dynamic>;
        return Column(
          children: [
            _buildInfoItem(
              title: 'Nom',
              value: doctorInfo['name'],
              icon: Icons.person,
            ),
            _buildInfoItem(
              title: 'Spécialité',
              value: doctorInfo['specialty'],
              icon: Icons.medical_services,
            ),
            _buildInfoItem(
              title: 'Téléphone',
              value: doctorInfo['phone'],
              icon: Icons.phone,
              isActionable: true,
              action: () {
                // Action pour appeler le médecin
              },
            ),
            _buildInfoItem(
              title: 'Adresse',
              value: doctorInfo['address'],
              icon: Icons.location_on,
              isActionable: true,
              action: () {
                // Action pour ouvrir l'adresse sur une carte
              },
            ),
          ],
        );

      case 'Paramètres':
        return Column(
          children: [
            _buildSettingsItem(
              title: 'Notifications',
              subtitle: 'Gérer les notifications de l\'application',
              icon: Icons.notifications,
              onTap: () {
                // Action pour ouvrir les paramètres de notification
              },
            ),
            _buildSettingsItem(
              title: 'Confidentialité',
              subtitle: 'Gérer vos données personnelles',
              icon: Icons.privacy_tip,
              onTap: () {
                // Action pour ouvrir les paramètres de confidentialité
              },
            ),
            _buildSettingsItem(
              title: 'Langue',
              subtitle: 'Français',
              icon: Icons.language,
              onTap: () {
                // Action pour changer la langue
              },
            ),
            _buildSettingsItem(
              title: 'Thème',
              subtitle: 'Clair',
              icon: Icons.brightness_6,
              onTap: () {
                // Action pour changer le thème
              },
            ),
          ],
        );

      case 'Aide et support':
        return Column(
          children: [
            _buildSettingsItem(
              title: 'Centre d\'aide',
              subtitle: 'Questions fréquentes et guides',
              icon: Icons.help_center,
              onTap: () {
                // Action pour ouvrir le centre d'aide
              },
            ),
            _buildSettingsItem(
              title: 'Contacter le support',
              subtitle: 'Nous sommes là pour vous aider',
              icon: Icons.support_agent,
              onTap: () {
                // Action pour contacter le support
              },
            ),
            _buildSettingsItem(
              title: 'Signaler un problème',
              subtitle: 'Aidez-nous à améliorer l\'application',
              icon: Icons.bug_report,
              onTap: () {
                // Action pour signaler un problème
              },
            ),
            _buildSettingsItem(
              title: 'À propos',
              subtitle: 'Version 1.0.0',
              icon: Icons.info,
              onTap: () {
                // Action pour ouvrir la page "À propos"
              },
            ),
          ],
        );

      default:
        return const Center(child: Text('Contenu non disponible'));
    }
  }

  // Élément d'information pour les sections
  Widget _buildInfoItem({
    required String title,
    required String value,
    required IconData icon,
    bool isActionable = false,
    VoidCallback? action,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isActionable && action != null)
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              iconSize: 16,
              color: AppTheme.primaryColor,
              onPressed: action,
            ),
        ],
      ),
    );
  }

  // Élément de paramètres
  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Boîte de dialogue pour éditer le profil
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Éditer le profil'),
            content: const SingleChildScrollView(
              child: Text('Formulaire d\'édition du profil (à implémenter)'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logique pour sauvegarder les modifications
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  // Boîte de dialogue pour confirmer la déconnexion
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logique pour se déconnecter
                  Navigator.pop(context);
                  // Rediriger vers l'écran de connexion (à implémenter)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                ),
                child: const Text('Déconnexion'),
              ),
            ],
          ),
    );
  }
}
