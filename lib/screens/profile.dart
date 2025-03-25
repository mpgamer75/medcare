import 'package:flutter/material.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/models/models.dart';
import 'package:medcare/models/medical_document.dart';
import 'package:medcare/services/data_service.dart';
import 'package:medcare/screens/document_viewer.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // Service de données
  final DataService _dataService = DataService();

  // Données de l'utilisateur
  late User _userProfile;

  // Documents médicaux
  late List<MedicalDocument> _documents;

  @override
  void initState() {
    super.initState();
    _userProfile = _dataService.currentUser;
    _documents = _dataService.documents;
  }

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
                children: [
                  _buildProfileSectionCard(
                    title: 'Informations personnelles',
                    icon: Icons.person,
                    color: AppTheme.primaryColor,
                    onTap:
                        () => _openProfileSection('Informations personnelles'),
                  ),
                  _buildProfileSectionCard(
                    title: 'Informations médicales',
                    icon: Icons.medical_information,
                    color: const Color(0xFF3DA5D9),
                    onTap: () => _openProfileSection('Informations médicales'),
                  ),
                  _buildProfileSectionCard(
                    title: 'Mes documents médicaux',
                    icon: Icons.description,
                    color: const Color(0xFF38B2AC),
                    onTap: () => _openProfileSection('Mes documents médicaux'),
                  ),
                  _buildProfileSectionCard(
                    title: 'Contact d\'urgence',
                    icon: Icons.emergency,
                    color: const Color(0xFFDD6B20),
                    onTap: () => _openProfileSection('Contact d\'urgence'),
                  ),
                  _buildProfileSectionCard(
                    title: 'Mon médecin traitant',
                    icon: Icons.local_hospital,
                    color: const Color(0xFF38B2AC),
                    onTap: () => _openProfileSection('Mon médecin traitant'),
                  ),
                  _buildProfileSectionCard(
                    title: 'Paramètres',
                    icon: Icons.settings,
                    color: const Color(0xFF718096),
                    onTap: () => _openProfileSection('Paramètres'),
                  ),
                  _buildProfileSectionCard(
                    title: 'Aide et support',
                    icon: Icons.help,
                    color: const Color(0xFF3182CE),
                    onTap: () => _openProfileSection('Aide et support'),
                  ),
                ],
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
        currentIndex: 2,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Traitements',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/traitements');
          } else if (index == 2) {
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
              _getInitials(_userProfile.name),
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
            _userProfile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            _userProfile.email,
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
                  value: '${_userProfile.age} ans',
                ),
                _buildQuickInfoItem(
                  icon: Icons.height,
                  label: 'Taille',
                  value: _userProfile.height,
                ),
                _buildQuickInfoItem(
                  icon: Icons.monitor_weight,
                  label: 'Poids',
                  value: _userProfile.weight,
                ),
                _buildQuickInfoItem(
                  icon: Icons.bloodtype,
                  label: 'Groupe',
                  value: _userProfile.bloodType,
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

  // Widget pour la carte du médecin traitant
  Widget _buildDoctorCard(DoctorInfo doctor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoItem(
              title: 'Téléphone',
              value: doctor.phone,
              icon: Icons.phone,
              isActionable: true,
              action: () {
                // Action pour appeler le médecin
              },
            ),
            _buildInfoItem(
              title: 'Adresse',
              value: doctor.address,
              icon: Icons.location_on,
              isActionable: true,
              action: () {
                // Action pour ouvrir l'adresse sur une carte
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher un document médical
  Widget _buildDocumentCard(MedicalDocument document) {
    IconData iconData;
    Color iconColor;

    switch (document.type) {
      case DocumentType.prescription:
        iconData = Icons.receipt;
        iconColor = AppTheme.primaryColor;
        break;
      case DocumentType.labResult:
        iconData = Icons.science;
        iconColor = const Color(0xFF3DA5D9);
        break;
      case DocumentType.medicalReport:
        iconData = Icons.description;
        iconColor = const Color(0xFF38B2AC);
        break;
      case DocumentType.imaging:
        iconData = Icons.image;
        iconColor = const Color(0xFFDD6B20);
        break;
      case DocumentType.other:
        iconData = Icons.folder;
        iconColor = AppTheme.textSecondary;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(document.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${document.doctor} • ${_formatDate(document.date)}'),
            if (document.description.isNotEmpty)
              Text(
                document.description,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Ouvrir le visualiseur de document
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentViewerScreen(document: document),
            ),
          );
        },
      ),
    );
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
              value: _userProfile.name,
              icon: Icons.person,
            ),
            _buildInfoItem(
              title: 'Email',
              value: _userProfile.email,
              icon: Icons.email,
            ),
            _buildInfoItem(
              title: 'Téléphone',
              value: _userProfile.phone,
              icon: Icons.phone,
            ),
            _buildInfoItem(
              title: 'Date de naissance',
              value:
                  '${_userProfile.birthdate.day}/${_userProfile.birthdate.month}/${_userProfile.birthdate.year}',
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
              value: _userProfile.height,
              icon: Icons.height,
            ),
            _buildInfoItem(
              title: 'Poids',
              value: _userProfile.weight,
              icon: Icons.monitor_weight,
            ),
            _buildInfoItem(
              title: 'Groupe sanguin',
              value: _userProfile.bloodType,
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
                  _userProfile.allergies.map((allergy) {
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
                  _userProfile.chronicDiseases.map((disease) {
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

      case 'Mes documents médicaux':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Documents récents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Ajouter'),
                  onPressed: () {
                    _showAddDocumentDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._documents
                .map((document) => _buildDocumentCard(document))
                .toList(),
            if (_documents.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: AppTheme.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun document',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Ajouter un document'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          _showAddDocumentDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );

      case 'Contact d\'urgence':
        final emergencyContact = _userProfile.emergencyContact;
        return Column(
          children: [
            _buildContactCard(
              name: emergencyContact.name,
              relation: emergencyContact.relation,
              phone: emergencyContact.phone,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text('Appeler'),
                  onPressed: () {
                    // Simuler un appel (pas d'implémentation réelle)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appel à ${emergencyContact.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.message, size: 16),
                  label: const Text('SMS'),
                  onPressed: () {
                    // Simuler un SMS (pas d'implémentation réelle)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('SMS à ${emergencyContact.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Modifier le contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      // Fonction pour modifier le contact d'urgence
                      _showEditEmergencyContactDialog();
                    },
                  ),
                ),
              ],
            ),
          ],
        );

      case 'Mon médecin traitant':
        final doctorInfo = _userProfile.doctorInfo;
        return Column(
          children: [
            _buildDoctorCard(doctorInfo),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text('Appeler'),
                  onPressed: () {
                    // Simuler un appel (pas d'implémentation réelle)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appel au Dr. ${doctorInfo.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Carte'),
                  onPressed: () {
                    // Simuler l'ouverture d'une carte (pas d'implémentation réelle)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Ouverture de la carte'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Modifier les informations'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      // Fonction pour modifier les infos du médecin
                      _showEditDoctorInfoDialog();
                    },
                  ),
                ),
              ],
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
            _buildSettingsItem(
              title: 'Sauvegardes',
              subtitle: 'Gérer vos sauvegardes',
              icon: Icons.backup,
              onTap: () {
                // Action pour gérer les sauvegardes
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
              subtitle: 'Version 1.2.0',
              icon: Icons.info,
              onTap: () {
                // Action pour ouvrir la page "À propos"
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Besoin d\'aide immédiate ?'),
                TextButton(
                  onPressed: () {
                    // Action pour appeler le support
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appel au support'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Appelez-nous'),
                ),
              ],
            ),
          ],
        );

      default:
        return const Center(child: Text('Contenu non disponible'));
    }
  }

  // Widget pour la carte de contact d'urgence
  Widget _buildContactCard({
    required String name,
    required String relation,
    required String phone,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                name
                    .split(' ')
                    .map((part) => part.isNotEmpty ? part[0] : '')
                    .join('')
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              relation,
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Boîte de dialogue pour éditer le profil
  void _showEditProfileDialog() {
    // Controllers pour les champs du formulaire
    final nameController = TextEditingController(text: _userProfile.name);
    final emailController = TextEditingController(text: _userProfile.email);
    final phoneController = TextEditingController(text: _userProfile.phone);

    // Pour la date de naissance
    DateTime selectedBirthdate = _userProfile.birthdate;

    // Pour la taille, le poids et le groupe sanguin
    final heightController = TextEditingController(text: _userProfile.height);
    final weightController = TextEditingController(text: _userProfile.weight);
    final bloodTypeController = TextEditingController(
      text: _userProfile.bloodType,
    );

    // Pour les allergies et maladies chroniques
    final allergiesController = TextEditingController(
      text: _userProfile.allergies.join(', '),
    );
    final chronicDiseasesController = TextEditingController(
      text: _userProfile.chronicDiseases.join(', '),
    );

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Éditer le profil'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informations personnelles
                      const Text(
                        'Informations personnelles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom complet',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      // Date de naissance avec sélecteur
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date de naissance:'),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedBirthdate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  selectedBirthdate = pickedDate;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: AppTheme.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(selectedBirthdate),
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      // Informations médicales
                      const Text(
                        'Informations médicales',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          labelText: 'Taille (cm)',
                          prefixIcon: Icon(Icons.height),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          labelText: 'Poids (kg)',
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: bloodTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Groupe sanguin',
                          prefixIcon: Icon(Icons.bloodtype),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Allergies
                      TextField(
                        controller: allergiesController,
                        decoration: const InputDecoration(
                          labelText: 'Allergies (séparées par des virgules)',
                          prefixIcon: Icon(Icons.warning_amber),
                          hintText: 'Ex: Arachide, Pénicilline',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),

                      // Maladies chroniques
                      TextField(
                        controller: chronicDiseasesController,
                        decoration: const InputDecoration(
                          labelText:
                              'Maladies chroniques (séparées par des virgules)',
                          prefixIcon: Icon(Icons.medical_information),
                          hintText: 'Ex: Asthme, Diabète',
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      // Traiter les allergies et les maladies chroniques
                      final List<String> allergies =
                          allergiesController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();

                      final List<String> chronicDiseases =
                          chronicDiseasesController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();

                      // MAJ de l'utilisateur
                      final updatedUser = _userProfile.copyWith(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        birthdate: selectedBirthdate,
                        height: heightController.text,
                        weight: weightController.text,
                        bloodType: bloodTypeController.text,
                        allergies: allergies,
                        chronicDiseases: chronicDiseases,
                      );

                      // Sauvegarder les modifications
                      _dataService.updateUser(updatedUser);

                      // Mettre à jour l'état local
                      setState(() {
                        _userProfile = updatedUser;
                      });

                      // Fermer la boîte de dialogue
                      Navigator.pop(context);

                      // Afficher un message de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profil mis à jour avec succès'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                    child: const Text('Enregistrer'),
                  ),
                ],
              );
            },
          ),
    );
  }

  // Boîte de dialogue pour éditer le contact d'urgence
  void _showEditEmergencyContactDialog() {
    // Controllers pour les champs du formulaire
    final nameController = TextEditingController(
      text: _userProfile.emergencyContact.name,
    );
    final relationController = TextEditingController(
      text: _userProfile.emergencyContact.relation,
    );
    final phoneController = TextEditingController(
      text: _userProfile.emergencyContact.phone,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Modifier le contact d\'urgence'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: relationController,
                    decoration: const InputDecoration(
                      labelText: 'Relation',
                      prefixIcon: Icon(Icons.family_restroom),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                onPressed: () {
                  // Mise à jour du contact d'urgence
                  final updatedContact = EmergencyContact(
                    name: nameController.text,
                    relation: relationController.text,
                    phone: phoneController.text,
                  );

                  final updatedUser = _userProfile.copyWith(
                    emergencyContact: updatedContact,
                  );

                  _dataService.updateUser(updatedUser);

                  // Mettre à jour l'état local
                  setState(() {
                    _userProfile = updatedUser;
                  });

                  Navigator.pop(context);

                  // Afficher un message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact d\'urgence mis à jour'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  // Boîte de dialogue pour éditer les informations du médecin
  void _showEditDoctorInfoDialog() {
    // Controllers pour les champs du formulaire
    final nameController = TextEditingController(
      text: _userProfile.doctorInfo.name,
    );
    final specialtyController = TextEditingController(
      text: _userProfile.doctorInfo.specialty,
    );
    final phoneController = TextEditingController(
      text: _userProfile.doctorInfo.phone,
    );
    final addressController = TextEditingController(
      text: _userProfile.doctorInfo.address,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Modifier les informations du médecin'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du médecin',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: specialtyController,
                    decoration: const InputDecoration(
                      labelText: 'Spécialité',
                      prefixIcon: Icon(Icons.medical_services),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                onPressed: () {
                  // Mise à jour des informations du médecin
                  final updatedDoctorInfo = DoctorInfo(
                    name: nameController.text,
                    specialty: specialtyController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                  );

                  final updatedUser = _userProfile.copyWith(
                    doctorInfo: updatedDoctorInfo,
                  );

                  _dataService.updateUser(updatedUser);

                  // Mettre à jour l'état local
                  setState(() {
                    _userProfile = updatedUser;
                  });

                  Navigator.pop(context);

                  // Afficher un message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informations du médecin mises à jour'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  // Boîte de dialogue pour ajouter un document
  void _showAddDocumentDialog() {
    // Controllers pour les champs du formulaire
    final titleController = TextEditingController();
    final doctorController = TextEditingController();
    final descriptionController = TextEditingController();

    DocumentType selectedType = DocumentType.prescription;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un document'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre du document *',
                        hintText: 'Ex: Ordonnance médicale',
                      ),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<DocumentType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type de document *',
                      ),
                      items:
                          DocumentType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(_getDocumentTypeName(type)),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: doctorController,
                      decoration: const InputDecoration(
                        labelText: 'Médecin / Établissement *',
                        hintText: 'Ex: Dr. Dupont / Laboratoire Central',
                      ),
                    ),
                    const SizedBox(height: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date du document:'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(selectedDate),
                                  style: TextStyle(color: AppTheme.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Ex: Résultats d\'analyse sanguine',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: () {
                        // Cette fonction serait normalement utilisée pour
                        // charger un document réel, mais ici c'est simulé
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fonctionnalité de chargement à venir',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Charger un document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  onPressed: () {
                    // Valider les champs obligatoires
                    if (titleController.text.isEmpty ||
                        doctorController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Veuillez remplir tous les champs obligatoires',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    // Créer un nouveau document
                    final newDocument = MedicalDocument(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      type: selectedType,
                      date: selectedDate,
                      doctor: doctorController.text,
                      description: descriptionController.text,
                      path: 'assets/documents/placeholder.pdf', // Chemin fictif
                    );

                    // Ajouter le document à la base de données
                    _dataService.addDocument(newDocument);

                    // Mettre à jour l'état local
                    setState(() {
                      _documents = _dataService.documents;
                    });

                    // Fermer la boîte de dialogue
                    Navigator.pop(context);

                    // Afficher un message de confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Document "${newDocument.title}" ajouté'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
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

  // Helper pour formater les dates
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Helper pour obtenir le nom du type de document
  String _getDocumentTypeName(DocumentType type) {
    switch (type) {
      case DocumentType.prescription:
        return 'Ordonnance';
      case DocumentType.labResult:
        return 'Résultat d\'analyse';
      case DocumentType.medicalReport:
        return 'Compte-rendu médical';
      case DocumentType.imaging:
        return 'Imagerie médicale';
      case DocumentType.other:
        return 'Autre document';
    }
  }
}
