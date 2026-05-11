import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:baobab_business/core/themes/app_diemens.dart';
import 'package:baobab_business/features/auth/domain/entities/user.dart';
import 'package:baobab_business/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeadereTablet extends StatelessWidget {
  const HeadereTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as AuthAuthenticated).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: AppColors.primaryLight, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Recherché",
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppColors.primaryLight, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(width: double.infinity,)),
            Container(
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS_10),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.settings, color: AppColors.primaryLight,)
                  ),
                  SizedBox(width: 15,),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimens.BORDER_RADIUS_10),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.notifications_rounded,  color: AppColors.primaryLight,)
                  ),
                  SizedBox(width: 10,),
                  _buildProfileImage(user), // ✅ Remplacé CircleAvatar() par l'avatar
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bonjour,", style: TextStyle(fontSize: 35, fontFamily: 'Poppins', fontWeight: FontWeight.bold),),
            Text(user.name, style: TextStyle(fontSize: 20, fontFamily: 'Poppins', ),),

            Row(
              children: [
                Text("Locolisation, loca", style: TextStyle(color: Colors.grey),),
                SizedBox(width: 10,),
                Icon(Icons.arrow_drop_down_sharp, color: Colors.grey,)
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildProfileImage(User? user) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    final hasProfile = user.imgUrl != null && user.imgUrl!.isNotEmpty;
    final avatarColor = _getAvatarColor(user.name);
    final initials = _getInitials(user.name);

    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: hasProfile
            ? Image.network(
          user.imgUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildInitialsAvatar(avatarColor, initials);
          },
        )
            : _buildInitialsAvatar(avatarColor, initials),
      ),
    );
  }

  // Widget pour les initiales dans le cercle
  Widget _buildInitialsAvatar(Color color, String initials) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Extrait les initiales du nom (ex: "Jean Dupont" -> "JD")
  String _getInitials(String name) {
    if (name.isEmpty || name.trim().isEmpty) return "?";
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return "?";
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts.last[0]).toUpperCase();
    }
  }

  // Obtient une couleur cohérente à partir du nom
  Color _getAvatarColor(String name) {
    if (name.isEmpty) return Colors.blue;

    // Utilisation d'une liste de couleurs prédéfinies
    final List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    int index = name.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}