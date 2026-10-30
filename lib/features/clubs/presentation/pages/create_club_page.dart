import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_sphere/core/theme/app_colors.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_bloc.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_state.dart';

class CreateClubPage extends StatefulWidget {
  const CreateClubPage({super.key});

  @override
  State<CreateClubPage> createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();

  ClubCategory? selectedCategory;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        title: const Text(
          'Create Club',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ClubBloc, ClubState>(
          listener: (context, state) {
            if (state is ClubError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
            }

            if (state is ClubOperationSuccess && state.club != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              // Close CreateClubPage and return the Club received from the backend.
              // This value completes the Future being awaited in ClubsPage
              context.pop(state.club); //return the club back
            }
          },
          builder: (context, state) {
            final isLoading = state is ClubLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Build your community',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create a club and bring students together around a shared interest.',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),

                    _buildLabel('Club name'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: nameController,
                      maxLength: 100,
                      decoration: _inputDecoration(
                        hint: 'e.g. GDG on Campus',
                        icon: Icons.groups_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a club name';
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
                      decoration: _inputDecoration(
                        hint: 'What is your club about?',
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
                    DropdownButtonFormField<ClubCategory>(
                      initialValue: selectedCategory,
                      decoration: _inputDecoration(
                        hint: 'Select a category',
                        icon: Icons.category_outlined,
                      ),
                      items: ClubCategory.values.map((category) {
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
                    _buildLabel('Image URL'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: imageUrlController,
                      keyboardType: TextInputType.url,
                      decoration: _inputDecoration(
                        hint: 'https://example.com/image.jpg',
                        icon: Icons.image_outlined,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Optional. You can add a club image later.',
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
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ClubBloc>().add(
                                    CreateClub(
                                      name: nameController.text.trim(),
                                      description: descriptionController.text
                                          .trim(),
                                      imageUrl:
                                          imageUrlController.text.trim().isEmpty
                                          ? null
                                          : imageUrlController.text.trim(),
                                      category: selectedCategory!,
                                    ),
                                  );
                                }
                              },
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
                            : const Icon(Icons.add),
                        label: Text(
                          isLoading ? 'Creating...' : 'Create Club',
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
      prefixIcon: Icon(icon, color: AppColors.secondary.withValues(alpha: 0.7)),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
