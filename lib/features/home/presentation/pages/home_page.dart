import 'package:flutter/material.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';
import 'package:uni_sphere/features/home/utils/event_category_icon.dart';

class HomePage extends StatelessWidget {
  final textPrimary = AppColors.primaryText;
  final textSecondary = AppColors.secondaryText;


  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          leading: Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.school_outlined,
                color: AppColors.background,
              ),
            ),
          ),
          titleSpacing: 0,
          title: const Text('UniSphere'),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Discover",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 20),
              Text(
                "What's happening around campus",
                style: TextStyle(
                  color: textSecondary,
                ),
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Upcoming events",
                      style: TextStyle(
                          color: textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: textSecondary.withValues(alpha: 0.20),
                      width: 0.5
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: colors.surface,
                  child: InkWell(
                    onTap: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.secondary.withValues(alpha: 0.30),
                              borderRadius: BorderRadius.circular(4),

                            ),
                            child: Icon(
                                EventCategoryIcon.getIcon(EventCategory.academic),
                                color: colors.primary,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Campus Tech Meetup",
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Oct 24, 10:00 AM",
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 15
                                  ),

                                ),
                              SizedBox(height: 8),
                              Text(
                                "Main Auditorium",
                                style: TextStyle(
                                    color: textSecondary,
                                )
                              ),
                              ],
                          )),
                          Icon(
                            Icons.chevron_right,
                            color: textSecondary,
                            size: 22,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: textSecondary.withValues(alpha: 0.20),
                      width: 0.5
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                color: colors.surface,
                child: InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.secondary.withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(4),

                          ),
                          child: Icon(
                            EventCategoryIcon.getIcon(EventCategory.religious),
                            color: colors.primary,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gibi Gubae",
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Oct 25, 8:00 AM",
                                  style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 15
                                  ),

                                ),
                                SizedBox(height: 8),
                                Text(
                                    "Church",
                                    style: TextStyle(
                                      color: textSecondary,
                                    )
                                ),
                              ],
                            )),
                        Icon(
                          Icons.chevron_right,
                          color: textSecondary,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: textSecondary.withValues(alpha: 0.20),
                      width: 0.5
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                color: colors.surface,
                child: InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.secondary.withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(4),

                          ),
                          child: Icon(
                            EventCategoryIcon.getIcon(EventCategory.career),
                            color: colors.primary,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Career Path Session",
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Oct 24, 12:00 AM",
                                  style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 15
                                  ),

                                ),
                                SizedBox(height: 8),
                                Text(
                                    "LT-47",
                                    style: TextStyle(
                                      color: textSecondary,
                                    )
                                ),
                              ],
                            )),
                        Icon(
                          Icons.chevron_right,
                          color: textSecondary,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
