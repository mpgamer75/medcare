import 'package:flutter/material.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/models/models.dart';
import 'package:medcare/models/medical_document.dart';
import 'package:intl/intl.dart';

class DocumentViewerScreen extends StatefulWidget {
  final MedicalDocument document;

  const DocumentViewerScreen({super.key, required this.document});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  // État pour le zoom
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Fonctionnalité de partage simulée
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité de partage à venir'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Fonctionnalité de téléchargement simulée
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Document téléchargé'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec les informations du document
          _buildDocumentHeader(),

          // Visualiseur de document
          Expanded(child: _buildDocumentViewer()),
        ],
      ),
      // Barre d'outils flottante
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _scale = (_scale - 0.1).clamp(0.5, 3.0);
                  });
                },
              ),
              Text(
                '${(_scale * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _scale = (_scale + 0.1).clamp(0.5, 3.0);
                  });
                },
              ),
              const VerticalDivider(width: 32, thickness: 1),
              IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () {
                  // Rotation simulée
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rotation à venir'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: () {
                  // Impression simulée
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Impression à venir'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // En-tête avec les informations du document
  Widget _buildDocumentHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et type de document
          Row(
            children: [
              Icon(
                _getDocumentIcon(widget.document.type),
                color: _getDocumentColor(widget.document.type),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getDocumentTypeName(widget.document.type),
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Date et médecin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(widget.document.date),
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    widget.document.doctor,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Description si présente
          if (widget.document.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 4),
            Text(
              widget.document.description,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  // Visualiseur de document
  Widget _buildDocumentViewer() {
    return Center(
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 3.0,
        scaleEnabled: true,
        child: FractionallySizedBox(
          widthFactor: _scale,
          child: _buildDocumentPlaceholder(),
        ),
      ),
    );
  }

  // Placeholder pour le document (en attendant une vraie visualisation)
  Widget _buildDocumentPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête du document
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.document.doctor,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(widget.document.date),
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const Divider(),
          // Contenu du document (simulé)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Contenu du document: ${widget.document.title}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.document.type == DocumentType.prescription) ...[
                  _buildPrescriptionContent(),
                ] else if (widget.document.type == DocumentType.labResult) ...[
                  _buildLabResultContent(),
                ] else ...[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 100,
                          color: AppTheme.textSecondary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aperçu du document',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cette fonctionnalité sera disponible prochainement',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Pied de page du document
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Document médical - '),
              Text(
                'MedCare',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Contenu d'une ordonnance (simulé)
  Widget _buildPrescriptionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDONNANCE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Patient: Sophie Martin'),
        const Text('Date de naissance: 15/05/1985'),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'R/',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        _buildMedicationItem(
          'Paracétamol 1000mg',
          'Prendre 1 comprimé toutes les 6 heures si besoin. Ne pas dépasser 4 comprimés par jour.',
        ),
        _buildMedicationItem(
          'Amoxicilline 500mg',
          'Prendre 1 comprimé 2 fois par jour, matin et soir, pendant 7 jours.',
        ),
        _buildMedicationItem(
          'Ventoline 100μg',
          'Inhaler 2 bouffées en cas de crise d\'asthme. Renouveler si nécessaire.',
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Signature du médecin:',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.document.doctor,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Item de médicament
  Widget _buildMedicationItem(String name, String instructions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• $name', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(instructions, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Contenu d'un résultat d'analyse (simulé)
  Widget _buildLabResultContent() {
    return Column(
      children: [
        const Text(
          'RÉSULTATS D\'ANALYSE SANGUINE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Patient: Sophie Martin'),
        const Text('Date du prélèvement: 22/01/2025'),
        const SizedBox(height: 16),
        // Tableau de résultats
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Paramètre',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Résultat',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Valeurs normales',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            _buildLabResultRow('Hémoglobine', '13.5 g/dL', '12.0 - 16.0 g/dL'),
            _buildLabResultRow('Globules blancs', '7.2 G/L', '4.0 - 10.0 G/L'),
            _buildLabResultRow('Plaquettes', '250 G/L', '150 - 400 G/L'),
            _buildLabResultRow('Glycémie', '5.1 mmol/L', '3.9 - 6.1 mmol/L'),
            _buildLabResultRow(
              'Cholestérol total',
              '4.5 mmol/L',
              '< 5.2 mmol/L',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Commentaire: Résultats dans les limites normales.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  // Ligne de résultat d'analyse
  TableRow _buildLabResultRow(
    String parameter,
    String result,
    String normalRange,
  ) {
    bool isNormal = true;

    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(parameter),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              result,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isNormal ? Colors.black : AppTheme.error,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              normalRange,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  // Obtenir l'icône correspondant au type de document
  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.prescription:
        return Icons.receipt;
      case DocumentType.labResult:
        return Icons.science;
      case DocumentType.medicalReport:
        return Icons.description;
      case DocumentType.imaging:
        return Icons.image;
      case DocumentType.other:
        return Icons.folder;
    }
  }

  // Obtenir la couleur correspondant au type de document
  Color _getDocumentColor(DocumentType type) {
    switch (type) {
      case DocumentType.prescription:
        return AppTheme.primaryColor;
      case DocumentType.labResult:
        return const Color(0xFF3DA5D9);
      case DocumentType.medicalReport:
        return const Color(0xFF38B2AC);
      case DocumentType.imaging:
        return const Color(0xFFDD6B20);
      case DocumentType.other:
        return AppTheme.textSecondary;
    }
  }

  // Obtenir le nom du type de document
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
