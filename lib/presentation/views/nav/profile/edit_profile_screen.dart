import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repx/data/providers/user_data_provider.dart';
import 'package:repx/presentation/widgets/custom_app_bar.dart';
import 'package:repx/presentation/widgets/custom_text_field.dart';

GlobalKey<FormState> _key = GlobalKey<FormState>();

class EditProfileScreen extends ConsumerWidget {
  static const String id = 'edit_profile_screen';
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    final user = ref.watch(userDataProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final userRepo = ref.watch(userRepositoryProvider);

    final userNameController = TextEditingController();
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    final ageController = TextEditingController();
    final genderController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final nameController = TextEditingController();

    Future<void> updateData() async {
      ref.read(isLoadingProvider.notifier).state = true;
      print(
        'Updating user data... ${userNameController.text}=============================',
      );
      try {
        final currentUser = user.value;
        if (currentUser == null) throw Exception('User data not loaded');

        // Create updated user using copyWith
        final updatedUser = currentUser.copyWith(
          username: userNameController.text.isNotEmpty
              ? userNameController.text
              : null,
          name: nameController.text.trim(),
          weight: int.tryParse(weightController.text),
          height: int.tryParse(heightController.text),
          age: int.tryParse(ageController.text),
          gender: genderController.text.isNotEmpty
              ? genderController.text
              : null,
          phoneNumber: phoneNumberController.text.trim(),
        );

        // Save updated user
        await userRepo.updateUser(updatedUser);

        ref.read(isLoadingProvider.notifier).state = false;
        ref.invalidate(userDataProvider);

        Navigator.pop(context);
      } catch (e) {
        ref.read(isLoadingProvider.notifier).state = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    }

    return user.when(
      data: (userData) {
        userNameController.text = userData.username ?? '';
        weightController.text = userData.weight?.toString() ?? '';
        heightController.text = userData.height?.toString() ?? '';
        ageController.text = userData.age?.toString() ?? '';
        genderController.text = userData.gender ?? '';
        phoneNumberController.text = userData.phoneNumber ?? '';
        nameController.text = userData.name ?? '';

        return Form(
          key: _key,
          child: Scaffold(
            appBar: CustomAppBar(title: "Edit Profile"),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      fillColor: Colors.white,
                    ),
                    controller: userNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      } else if (value.contains(' ')) {
                        return "Username shouldn't have spaces";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Name',
                    controller: nameController,
                    width: width * 0.9,
                  ),
                  SizedBox(height: 16),

                  CustomTextField(
                    labelText: 'Weight (kg)',
                    controller: weightController,
                    width: width * 0.9,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Height (cm)',
                    controller: heightController,
                    width: width * 0.9,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Age',
                    controller: ageController,
                    width: width * 0.9,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    labelText: 'Phone Number',
                    controller: phoneNumberController,
                    width: width * 0.9,
                  ),
                  SizedBox(height: 16),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            if (_key.currentState?.validate() ?? false) {
                              updateData();
                            }
                          },
                          child: Text('Save Changes'),
                        ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
