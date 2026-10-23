import 'package:flutter/material.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';

import '../../clubs/domain/entities/club_category.dart';

abstract final class CategoryIconMapper {
  static const Map<EventCategory, IconData> eventIcons = {
    EventCategory.academic: Icons.school_outlined,
    EventCategory.technology: Icons.code,
    EventCategory.sports: Icons.sports_soccer,
    EventCategory.arts: Icons.palette_outlined,
    EventCategory.cultural: Icons.diversity_3,
    EventCategory.religious: Icons.church_outlined,
    EventCategory.social: Icons.groups_outlined,
    EventCategory.political: Icons.account_balance_outlined,
    EventCategory.volunteering: Icons.volunteer_activism_outlined,
    EventCategory.professional: Icons.work_outline,
    EventCategory.career: Icons.trending_up,
    EventCategory.entrepreneurship: Icons.lightbulb_outline,
    EventCategory.workshop: Icons.handyman_outlined,
    EventCategory.conference: Icons.forum_outlined,
    EventCategory.seminar: Icons.co_present_outlined,
    EventCategory.competition: Icons.emoji_events_outlined,
    EventCategory.gaming: Icons.sports_esports_outlined,
    EventCategory.other: Icons.event_outlined,
  };
  static const Map<ClubCategory, IconData> clubIcons = {
    ClubCategory.academic: Icons.school_outlined,
    ClubCategory.technology: Icons.computer_outlined,
    ClubCategory.sports: Icons.sports_soccer_outlined,
    ClubCategory.arts: Icons.palette_outlined,
    ClubCategory.cultural: Icons.diversity_3_outlined,
    ClubCategory.religious: Icons.church_outlined,
    ClubCategory.social: Icons.groups_outlined,
    ClubCategory.political: Icons.account_balance_outlined,
    ClubCategory.volunteering: Icons.volunteer_activism_outlined,
    ClubCategory.professional: Icons.work_outline,
    ClubCategory.entrepreneurship: Icons.lightbulb_outline,
    ClubCategory.media: Icons.campaign_outlined,
    ClubCategory.gaming: Icons.sports_esports_outlined,
    ClubCategory.other: Icons.category_outlined,
  };

  static IconData getEventIcon(EventCategory category) {
    return eventIcons[category] ?? Icons.event_outlined;
  }
  static IconData getClubIcon(ClubCategory category){
    return clubIcons[category] ?? Icons.people_outline;
  }
}