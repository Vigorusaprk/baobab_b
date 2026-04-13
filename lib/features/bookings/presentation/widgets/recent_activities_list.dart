import 'package:flutter/material.dart';

class RecentActivity {
  final String title;
  final String subtitle;
  final String date;
  final double? amount;
  final IconData icon;
  final Color iconColor;

  RecentActivity({
    required this.title,
    required this.subtitle,
    required this.date,
    this.amount,
    required this.icon,
    this.iconColor = Colors.grey,
  });
}

class RecentActivitiesList extends StatelessWidget {
  final List<RecentActivity> activities;
  final String title;
  final VoidCallback? onViewAll;

  const RecentActivitiesList({
    super.key,
    required this.activities,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('Voir tout'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final a = activities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: a.iconColor.withOpacity(0.1),
                    child: Icon(a.icon, color: a.iconColor),
                  ),
                  title: Text(a.title),
                  subtitle: Text(a.subtitle),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (a.amount != null)
                        Text(
                          '${a.amount!.toStringAsFixed(2)} €',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      Text(
                        a.date,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}