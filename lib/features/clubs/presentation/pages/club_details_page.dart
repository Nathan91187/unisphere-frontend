import 'package:flutter/material.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club.dart';

import '../../../../core/theme/app_colors.dart';
class ClubDetailsPage extends StatelessWidget {
  final Club club;
  const ClubDetailsPage({
    super.key,
    required this.club
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.primaryText;
    final textSecondary = AppColors.secondaryText;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Club Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Image.asset(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        "assets/images/ronaldo_crying.png"
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                      color: colors.secondary.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    club.category.name.toUpperCase(),
                    style: TextStyle(
                        color: colors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  club.name,
                  style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 6,),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: colors.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          "${club.memberCount.toString()} members",
                          style: TextStyle(
                              color: textSecondary,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6,),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {},
                    child: const Text('Join club'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "About",
                  style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15

                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  club.description,
                  style: TextStyle(
                      color: textSecondary
                  ),
                ),
                SizedBox(height: 10,),
                Divider(height: 1,color: textSecondary.withValues(alpha: 0.3)),
                SizedBox(height: 15,),
                Text(
                  "Upcoming club events",
                  style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
