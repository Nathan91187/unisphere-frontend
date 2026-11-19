import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_event.dart';
import 'package:uni_sphere/features/profile/presentation/bloc/profile_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/profile_user.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser profileUser;

  const EditProfilePage({super.key, required this.profileUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();

  final usernameController = TextEditingController();

  @override
  void dispose() {
    displayNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    displayNameController.text = widget.profileUser.displayName;
    usernameController.text = widget.profileUser.username;
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            prefixText: prefixText,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            context.pop();
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
          }
          if (state is UsernameAvailabilityChecked) {
            if (state.isAvailable) {
              context.read<ProfileBloc>().add(
                SaveProfileChanges(

                  displayName: displayNameController.text.trim(),
                  username: usernameController.text.trim(),
                  image: selectedImage,
                  updateText: true
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'That username is already taken. Please choose another one.',
                  ),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: AppColors.selectedSurface,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : widget.profileUser.profileImageUrl != null
                                ? NetworkImage(
                                    widget.profileUser.profileImageUrl!,
                                  )
                                : null,
                            child:
                                selectedImage == null &&
                                    widget.profileUser.profileImageUrl == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: pickProfileImage,
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Change photo'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Personal information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Divider(height: 1, color: AppColors.border),

                    const SizedBox(height: 20),

                    _buildTextField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Display name can\'t be empty';
                        }
                        if (value.trim().length > 100) {
                          return 'Display name must not exceed 100 characters';
                        }
                        return null;
                      },
                      label: 'Display Name',
                      controller: displayNameController,
                    ),

                    const SizedBox(height: 20),

                    _buildTextField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a username';
                        }
                        final username = value.trim();
                        if (username.length < 3 || username.length > 20) {
                          return 'Username must be between 3 and 20 characters';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
                          return 'Use only letters, numbers, and underscores';
                        }
                        return null;
                      },
                      label: 'Username',
                      controller: usernameController,
                      prefixText: '@',
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Letters, numbers, and underscores only.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) return;

                                final username = usernameController.text.trim();
                                final displayName = displayNameController.text.trim();

                                final usernameChanged = username != widget.profileUser.username;
                                final displayNameChanged = displayName != widget.profileUser.displayName;
                                final imageChanged = selectedImage != null;

                                if (!usernameChanged && !displayNameChanged && !imageChanged) {
                                  context.pop();
                                  return;
                                }
                                final bloc = context.read<ProfileBloc>();

                                if (usernameChanged) {
                                  bloc.add(
                                    CheckUsernameAvailability(
                                      username: username,
                                    ),
                                  );
                                } else {
                                  bloc.add(
                                    SaveProfileChanges(
                                      username: username,
                                      displayName: displayName,
                                      updateText: displayNameChanged || usernameChanged,
                                      image: selectedImage,
                                    ),
                                  );
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => context.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryText,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
