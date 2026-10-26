import 'package:baobab_business/core/merchant/merchant_api.dart';
import 'ad_models.dart';

/// Tarifs et campagnes d'un commerce.
class AdBoard {
  final List<AdPrice> prices;
  final List<AdCampaign> campaigns;
  const AdBoard(this.prices, this.campaigns);
}

/// Publicité via les Edge Functions `get-ad-campaigns`, `create-ad-campaign`
/// et `update-ad-campaign`. Le prix n'est jamais envoyé : le serveur le calcule.
class AdsApi {
  final _api = MerchantApi.instance;

  List<T> _rows<T>(Object? v, T Function(Map<String, dynamic>) f) => (v is List ? v : const [])
      .whereType<Map>().map((e) => f(Map<String, dynamic>.from(e))).toList();

  Future<AdBoard> load(String businessId) async {
    final d = await _api.fetch('get-ad-campaigns', query: {'businessId': businessId});
    return AdBoard(_rows(d['prices'], AdPrice.fromJson), _rows(d['campaigns'], AdCampaign.fromJson));
  }

  /// Dépose une demande (statut « en examen »). Dates au format AAAA-MM-JJ.
  Future<void> request({
    required String businessId, required String placement,
    required DateTime start, required DateTime end, String? offerId,
  }) => _api.call('create-ad-campaign', {
        'businessId': businessId,
        'placement': placement,
        'startsOn': _day(start),
        'endsOn': _day(end),
        if (offerId != null) 'offerId': offerId,
      });

  Future<void> cancel(String campaignId) =>
      _api.call('update-ad-campaign', {'campaignId': campaignId, 'action': 'cancel'});

  static String _day(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
