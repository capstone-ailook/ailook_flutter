import 'package:ailook_flutter/presentation/providers/user/profile_edit_provider.dart';
import 'package:ailook_flutter/presentation/widgets/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileEditPage extends BasePage {
  const ProfileEditPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'EDIT PROFILE',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: state.isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) 
            : const Icon(Icons.check_rounded, color: Colors.black, size: 28),
          onPressed: state.isLoading ? null : () async {
            final success = await ref.read(profileEditProvider.notifier).save();
            if (success && context.mounted) {
              Navigator.of(context).pop();
            } else if (state.error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditProvider);
    final nicknameController = useTextEditingController(text: state.nickname);
    final heightController = useTextEditingController(text: state.height.toString());
    final weightController = useTextEditingController(text: state.weight.toString());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: ref.read(profileEditProvider.notifier).pickImage,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: state.pickedImage != null
                          ? FileImage(state.pickedImage!)
                          : (state.photoUrl != null ? NetworkImage(state.photoUrl!) as ImageProvider : null),
                      child: (state.pickedImage == null && state.photoUrl == null)
                          ? const Icon(Icons.person_rounded, size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _SectionTitle('Nickname'),
          TextField(
            controller: nicknameController,
            onChanged: (val) => ref.read(profileEditProvider.notifier).updateNickname(val),
            decoration: _inputDecoration('Your nickname'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),

          _SectionTitle('Gender'),
          Row(
            children: [
              _GenderButton(
                label: '남성',
                isSelected: state.gender == '남성',
                onTap: () => ref.read(profileEditProvider.notifier).updateGender('남성'),
              ),
              const SizedBox(width: 12),
              _GenderButton(
                label: '여성',
                isSelected: state.gender == '여성',
                onTap: () => ref.read(profileEditProvider.notifier).updateGender('여성'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          _SectionTitle('Age Stage'),
          DropdownButtonFormField<String>(
            value: state.age,
            decoration: _inputDecoration('Pick your age range'),
            dropdownColor: Colors.white,
            items: ['10대', '20대', '30대', '40대', '50대 이상']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) ref.read(profileEditProvider.notifier).updateAge(val);
            },
            style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle('Height'),
                    TextField(
                      controller: heightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null) ref.read(profileEditProvider.notifier).updateHeight(parsed);
                      },
                      decoration: _inputDecoration('Height').copyWith(suffixText: 'cm'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle('Weight'),
                    TextField(
                      controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null) ref.read(profileEditProvider.notifier).updateWeight(parsed);
                      },
                      decoration: _inputDecoration('Weight').copyWith(suffixText: 'kg'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _SectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
