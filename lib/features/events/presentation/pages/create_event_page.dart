
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/features/events/domain/entities/event.dart';
import 'package:uni_sphere/features/events/domain/entities/event_category.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_bloc.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_event.dart';
import 'package:uni_sphere/features/events/presentation/bloc/event_state.dart';

class CreateEventPage extends StatefulWidget {
  final Event? event;
  final int? clubId;
  const CreateEventPage({
    super.key,
    this.clubId,
    this.event,
  });

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();
  final capacityController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  EventCategory? selectedCategory;
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  bool get isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.event?.name ?? '';
    descriptionController.text = widget.event?.description ?? '';
    imageUrlController.text = widget.event?.imageUrl ?? '';
    capacityController.text = widget.event?.capacity.toString() ?? '';
    locationController.text = widget.event?.location ?? '';

    selectedCategory = widget.event?.category;
    selectedDate = widget.event?.date;

    if (widget.event != null) {
      dateController.text = _formatDate(widget.event!.date);

      selectedStartTime = _parseTime(widget.event!.startTime);
      selectedEndTime = _parseTime(widget.event!.endTime);
    }

    startTimeController.text =
    selectedStartTime != null ? _formatTimeForDisplay(selectedStartTime!) : '';

    endTimeController.text =
    selectedEndTime != null ? _formatTimeForDisplay(selectedEndTime!) : '';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    capacityController.dispose();
    locationController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();

    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');

    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeForDisplay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeForApi(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        dateController.text = _formatDate(date);
      });
    }
  }

  Future<void> _selectTime({required bool isStartTime}) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? selectedStartTime ?? const TimeOfDay(hour: 9, minute: 0)
          : selectedEndTime ?? const TimeOfDay(hour: 10, minute: 0),
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          selectedStartTime = selectedTime;
          startTimeController.text = _formatTimeForDisplay(selectedTime);
        } else {
          selectedEndTime = selectedTime;
          endTimeController.text = _formatTimeForDisplay(selectedTime);
        }
      });
    }
  }

  bool _isValidTimeRange() {
    if (selectedStartTime == null || selectedEndTime == null) {
      return false;
    }
    final startMinutes =
        selectedStartTime!.hour * 60 + selectedStartTime!.minute;
    final endMinutes =
        selectedEndTime!.hour * 60 + selectedEndTime!.minute;
    return endMinutes > startMinutes;
  }
  void _submitEvent() {
    if (!_formKey.currentState!.validate()) return;

    if (!_isValidTimeRange()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be later than start time'),
        ),
      );
      return;
    }
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final imageUrl = imageUrlController.text.trim().isEmpty
        ? null
        : imageUrlController.text.trim();
    final category = selectedCategory!;
    final date = selectedDate!;
    final startTime = _formatTimeForApi(selectedStartTime!);
    final endTime = _formatTimeForApi(selectedEndTime!);
    final capacity = int.parse(capacityController.text.trim());
    final location = locationController.text.trim();
    if (isEditing) {
      context.read<EventBloc>().add(
        UpdateEvent(
          eventId: widget.event!.id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          category: category,
          date: date,
          startTime: startTime,
          endTime: endTime,
          capacity: capacity,
          location: location,
        ),
      );
    } else {
      context.read<EventBloc>().add(
        CreateEvent(
          name: name,
          description: description,
          imageUrl: imageUrl,
          category: category,
          date: date,
          startTime: startTime,
          endTime: endTime,
          capacity: capacity,
          location: location,
          clubId: widget.clubId
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        title: Text(
          isEditing ? 'Edit Event' : 'Create Event',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMsg)),
              );
            }

            if (state is EventOperationSuccess && state.event != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.pop(state.event);
            }
          },
          builder: (context, state) {
            final isLoading = state is EventLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Update your event' : 'Plan your event',
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isEditing
                          ? 'Make changes to your event details.'
                          : 'Create an event and bring your university community together.',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 25),

                    _buildLabel('Event name'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: nameController,
                      maxLength: 100,
                      enabled: !isLoading,
                      decoration: _inputDecoration(
                        hint: 'e.g. Flutter Development Workshop',
                        icon: Icons.event_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an event name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Description'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: descriptionController,
                      maxLength: 2000,
                      maxLines: 5,
                      enabled: !isLoading,
                      decoration: _inputDecoration(
                        hint: 'What is this event about?',
                        icon: Icons.description_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Category'),
                    const SizedBox(height: 7),
                    DropdownButtonFormField<EventCategory>(
                      initialValue: selectedCategory,
                      decoration: _inputDecoration(
                        hint: 'Select a category',
                        icon: Icons.category_outlined,
                      ),
                      items: EventCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name[0].toUpperCase() +
                                category.name.substring(1),
                          ),
                        );
                      }).toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Event date'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      enabled: !isLoading,
                      onTap: _selectDate,
                      decoration: _inputDecoration(
                        hint: 'Select event date',
                        icon: Icons.calendar_today_outlined,
                      ),
                      validator: (value) {
                        if (selectedDate == null) {
                          return 'Please select an event date';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Start time'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: startTimeController,
                      readOnly: true,
                      enabled: !isLoading,
                      onTap: () => _selectTime(isStartTime: true),
                      decoration: _inputDecoration(
                        hint: 'Select start time',
                        icon: Icons.access_time_outlined,
                      ),
                      validator: (value) {
                        if (selectedStartTime == null) {
                          return 'Please select a start time';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('End time'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: endTimeController,
                      readOnly: true,
                      enabled: !isLoading,
                      onTap: () => _selectTime(isStartTime: false),
                      decoration: _inputDecoration(
                        hint: 'Select end time',
                        icon: Icons.access_time_filled_outlined,
                      ),
                      validator: (value) {
                        if (selectedEndTime == null) {
                          return 'Please select an end time';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Capacity'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: capacityController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        hint: 'Maximum number of attendees',
                        icon: Icons.people_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the event capacity';
                        }

                        final capacity = int.tryParse(value.trim());

                        if (capacity == null || capacity <= 0) {
                          return 'Enter a valid positive number';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Location'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: locationController,
                      maxLength: 255,
                      enabled: !isLoading,
                      decoration: _inputDecoration(
                        hint: 'Where will the event take place?',
                        icon: Icons.location_on_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the event\'s location';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    _buildLabel('Image URL'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: imageUrlController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.url,
                      decoration: _inputDecoration(
                        hint: 'https://example.com/image.jpg',
                        icon: Icons.image_outlined,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Optional. You can add an event image later.',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : _submitEvent,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surface,
                          ),
                        )
                            : Icon(isEditing ? Icons.save_outlined : Icons.add),
                        label: Text(
                          isLoading
                              ? (isEditing ? 'Updating...' : 'Creating...')
                              : (isEditing ? 'Update Event' : 'Create Event'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.secondaryText.withValues(alpha: 0.8),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.secondary.withValues(alpha: 0.7),
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}
