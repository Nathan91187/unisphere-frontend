import 'package:flutter/material.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';

abstract final class EventCategoryIcon {
  static const Map<EventCategory, IconData> icons = {
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

  static IconData getIcon(EventCategory category) {
    return icons[category] ?? Icons.event_outlined;
  }
}