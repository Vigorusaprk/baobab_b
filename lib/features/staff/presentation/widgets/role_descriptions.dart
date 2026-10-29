// lib/features/staff/presentation/widgets/role_descriptions.dart
//
// Descriptions des rôles et aide au choix lors de l'invitation.

class RoleDescription {
  final String key;
  final String title;
  final String hint;

  const RoleDescription(this.key, this.title, this.hint);

  static const all = [
    RoleDescription('owner', 'Propriétaire', 'Accès complet (boutique, équipe, publicités, finances).'),
    RoleDescription('manager', 'Gérant', 'Gère les offres, commandes, réservations et l\'équipe (sauf propriétaire).'),
    RoleDescription('staff', 'Employé', 'Gère les commandes et les réservations clients.'),
    RoleDescription('kitchen', 'Cuisine', 'Visualise et fait avancer les commandes en cuisine.'),
  ];

  /// Liste des rôles qu'un utilisateur peut attribuer selon son rôle actuel.
  static List<RoleDescription> allowedFor(String callerRole) {
    if (callerRole == 'owner') return all;
    // Un gérant ne peut pas nommer un propriétaire
    return all.where((r) => r.key != 'owner').toList();
  }
}
