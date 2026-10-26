/// Emplacement publicitaire : code serveur → libellé et explication.
const placementLabels = {'home': 'Accueil', 'category': 'Catégorie', 'search': 'Recherche'};
const placementHints = {
  'home': "En tête de l'accueil, pour tout le monde.",
  'category': 'Dans votre catégorie, auprès de qui la filtre.',
  'search': 'Dans les résultats de recherche.',
};

/// Tarif d'un emplacement, fixé par la plateforme (USD par jour).
class AdPrice {
  final String placement;
  final double usdPerDay;
  const AdPrice(this.placement, this.usdPerDay);

  factory AdPrice.fromJson(Map<String, dynamic> j) =>
      AdPrice(j['placement'].toString(), (j['usd_per_day'] as num?)?.toDouble() ?? 0);

  String get label => placementLabels[placement] ?? placement;
}

/// Une campagne de mise en avant. Cycle : in_review → approved → running → finished
/// (ou rejected / cancelled).
class AdCampaign {
  final String id, placement, status;
  final DateTime startsOn, endsOn;
  final double quoted;
  final double? amount; // fixé par la plateforme à la validation
  final String? offerName, reviewNote;

  const AdCampaign({
    required this.id, required this.placement, required this.status,
    required this.startsOn, required this.endsOn, required this.quoted,
    this.amount, this.offerName, this.reviewNote,
  });

  factory AdCampaign.fromJson(Map<String, dynamic> j) => AdCampaign(
        id: j['id'].toString(),
        placement: j['placement'].toString(),
        status: j['status'].toString(),
        startsOn: DateTime.parse(j['starts_on'].toString()),
        endsOn: DateTime.parse(j['ends_on'].toString()),
        quoted: (j['quoted_amount'] as num?)?.toDouble() ?? 0,
        amount: (j['amount'] as num?)?.toDouble(),
        offerName: (j['offers'] is Map) ? j['offers']['name']?.toString() : null,
        reviewNote: j['review_note']?.toString(),
      );

  String get statusLabel => const {
        'in_review': 'En examen', 'approved': 'Validée', 'running': 'En diffusion',
        'finished': 'Terminée', 'rejected': 'Refusée', 'cancelled': 'Annulée',
      }[status] ?? status;

  /// Une campagne terminée, refusée ou annulée ne peut plus être annulée.
  bool get isOver => const {'finished', 'rejected', 'cancelled'}.contains(status);

  /// Montant à retenir : celui de la plateforme, sinon le devis.
  double get due => amount ?? quoted;
  String get target => offerName ?? 'Tout le commerce';
}
